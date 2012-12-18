//
//  PolarCanvas.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PolarCanvas.h"
#include "EngineShape.h"
#include "../sizer/Sizer.h"
#include "../sizer/ByWeightSizer.h"
#include "../placer/Placer.h"
#include "../placer/ColorMapPlacer.h"
#include "../density/Patch.h"
#include "WordLayer.h"
#include "../angler/Angler.h"
#include "../angler/ColorMapAngler.h"
#include "../tree/PolarRootTree.h"
#include "../nudger/Nudger.h"
#include "../placer/Placer.h"
#include "../placer/ColorMapPlacer.h"
#include "../nudger/ColorMapZigzagNudger.h"
#include "../nudger/ColorMapSpiralNudger.h"
#include "../density/DensityPatchIndex.h"
#include "structs.h"
//#include "concurrent_queue.h"
#include <cmath>
#include <tr1/unordered_set>
#include <tr1/unordered_map>
#include <limits>
#include <cstdlib>
#include <ctime>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <errno.h>

#if NUM_THREADS > 1
#include <pthread.h>
#include "../threads/threadpool.h"
threadpool *PolarCanvas::pool;

#endif

static int id_counter = 0;

struct thread_param {
    int seq;
    PolarCanvas* canvas;
};


ThreadControllers PolarCanvas::threadControllers;

PolarCanvas* PolarCanvas::current = NULL;

PolarCanvas* PolarCanvas::pending = new PolarCanvas();

PolarCanvas::PolarCanvas():failureCount(0),numRetries(0),totalAttempted(0),
width(NAN),height(NAN),_status(PAUSED),_sizer(NULL),_nudger(NULL),_placer(NULL),_patchIndex(NULL),
perseverance(DEFAULT_PERSEVERANCE),diligence(DEFAULT_DILIGENCE),_lastCollidedWith(NULL),_attempt(0),
_shapeToWorkOn(NULL),
//_shapes(new vector<EngineShape*>),
//fixedShapes(new tr1::unordered_set<unsigned int>()),
_id(id_counter++)
{
    
    pthread_attr_init(&attr);
    //    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_mutex_init(&shape_mutex, NULL);
    pthread_mutex_init(&attempt_mutex, NULL);
    pthread_mutex_init(&numActiveThreads_mutex,NULL);
    pthread_cond_init (&count_threshold_cv, NULL);
    pthread_mutex_init (&count_threshold_mutex, NULL);
    pthread_cond_init (&status_cv, NULL);
    pthread_mutex_init (&status_mutex, NULL);
    //    printf("pthread related init complete.\n");
    
#if NUM_THREADS > 1
    //spawn threads
    for(int i=0;i<NUM_THREADS;i++)
        _signoffSheet[i] = false;
	if ((pool = threadpool_init(NUM_THREADS)) == NULL) {
		printf("Error! Failed to create a thread pool struct.\n");
		exit(EXIT_FAILURE);
	}
#endif
    
}

PolarCanvas::~PolarCanvas(){

    
    pthread_attr_destroy(&attr);
    pthread_mutex_destroy(&numActiveThreads_mutex);
    pthread_mutex_destroy(&shape_mutex);
    pthread_mutex_destroy(&attempt_mutex);
    pthread_cond_destroy(&count_threshold_cv);
    pthread_mutex_destroy(&count_threshold_mutex);
    pthread_cond_destroy(&status_cv);
    pthread_mutex_destroy(&status_mutex);
    
//#if NUM_THREADS > 1
//    threadpool_free(pool,1);
//#endif

    for ( std::tr1::unordered_map<int, EngineShape*>::iterator it = _shapeMap.begin(); it != _shapeMap.end(); ++it ){
        it->second->referenceCounter--;
        if(it->second->referenceCounter==0){
            printf("Shape #%d deleted.\n",it->second->getUid());
            delete (it->second);
        }

    }

//    for ( vector<EngineShape*>::iterator it = _shapes->begin(); it != _shapes->end(); ){
//            delete * it;
//    it = _shapes->erase(it);
//    }
//    delete _shapes;
//    delete pendingShapes;
//    delete displayShapes;
//    delete retryShapes;
//    delete fixedShapes;
    delete _nudger;
    if(_patchIndex!=NULL)
        delete _patchIndex;
    for(int i=0;i<size();i++)
        delete at(i);
    
    
}


void PolarCanvas::feedShape(ImageShape* shape, unsigned int sid){
    std::tr1::unordered_map<int,EngineShape*>::const_iterator got = _shapeMap.find (sid);
    EngineShape* eShape = NULL;
    if(got == _shapeMap.end()){
        if(failureCount <= perseverance && getStatus() == RENDERING){
            eShape = new EngineShape(shape,sid);

            pendingShapes.push(eShape);
    //        printf("Shape fed. width: %d, height: %d.\n",shape->getWidth(),shape->getHeight());
        }
    }
    else{
        EngineShape* old = got->second;
        //transfer location and rotation info
        printf("Shape exists. Replacing...\n");
        eShape = new EngineShape(shape,old);
    }
    registerShape(eShape);
}

void PolarCanvas::removeShape(unsigned int sid){
    if(_shapeMap.find(sid)!=_shapeMap.end()){
        _shapeMap[sid]->referenceCounter--;
        pthread_mutex_lock(&shape_mutex);
        this->_shapeMap.erase(sid);
        this->displayShapes.erase(sid);
        pthread_mutex_unlock(&shape_mutex);
    }
}



void PolarCanvas::tryNextEngineShape(){
    if(!pendingShapes.empty()){
//    assert(!pendingShapes->empty());
        EngineShape* eShape = pendingShapes.front();
        pendingShapes.pop();
        placeShape(eShape);
        if(eShape->wasSkipped()){
            if(getSizer()->hasNextSize()){
                if(totalAttempted>0){
                    retryShapes.push_back(eShape);
                    numRetries++;
                }
                else
                    numRetries = MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;
                if(numRetries==MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE ){
                    numRetries = 0;
                    if (getSizer()->switchToNextSize()){
                        while(pendingShapes.size()>0){
                            pendingShapes.pop();
                        }
                    }
                }
                return;
            }
        }
        
        if(!eShape->wasSkipped()){
            if(failureCount>1) failureCount--;
            displayShapes[eShape->getUid()]=eShape;
        }
        else{
            failureCount++;
            if(failureCount>perseverance){
                setStatus(PAUSED);
                printf("Rendering complete.\n");
            }
        }
        //TODO: notify arrival of new display shape
         Placement placement = eShape->getFinalPlacement();
        
        if(!isnan(placement.location.x)){
            printf("Coord: %f, %f; rotation: %f, color: 0x%x\n"
                   ,eShape->getShape()->getTree()->getRootX(eShape->getShape()->getTree()->getFinalSeq())
                   ,eShape->getShape()->getTree()->getRootY(eShape->getShape()->getTree()->getFinalSeq())
                   ,eShape->getShape()->getTree()->getRotation(eShape->getShape()->getTree()->getFinalSeq()),placement.color);
            
//            SlapInfo* place = new SlapInfo(eShape->getUid(),getId(),
//                                            eShape->getShape()->getTree()->getTopLeftLocation(eShape->getShape()->getTree()->getFinalSeq()),
//                                           eShape->getShape()->getTree()->getRotation(eShape->getShape()->getTree()->getFinalSeq()),
//                                           placement.patch->getLayer()->lid,
//                                           placement.color,
//                                           getFailureCount())
//                                        ;
            CartisianPoint loc(eShape->getShape()->getTree()->getRootX(eShape->getShape()->getTree()->getFinalSeq()),
                               eShape->getShape()->getTree()->getRootY(eShape->getShape()->getTree()->getFinalSeq()));
            SlapInfo* place = new SlapInfo(eShape->getUid(),getId(),
                                           loc,
                                           eShape->getShape()->getTree()->getRotation(eShape->getShape()->getTree()->getFinalSeq()),
                                           placement.patch->getLayer()->lid,
                                           placement.color,
                                           getFailureCount())
            ;
            slaps.push(place);
            
        }
        
    }
    else{
        printf("No new shape this time around. Skipping...\n");
    }
}


Nudger* PolarCanvas::getNudger(){
    if(_nudger==NULL){
//        _nudger = new ColorMapSpiralNudger();
        _nudger = new ColorMapZigzagNudger();
    }
    return _nudger;
}

/* Arrange the N elements of ARRAY in random order.
 Only effective if N is much smaller than RAND_MAX;
 if this may not be the case, use a better random
 number generator. */
static void shuffle(int *array, size_t n)
{
    if (n > 1) {
        size_t i;
        for (i = 0; i < n - 1; i++) {
            size_t j = i + rand() / (RAND_MAX / (n - i) + 1);
            int t = array[j];
            array[j] = array[i];
            array[i] = t;
        }
    }
}





void PolarCanvas::attempt_nudge(void *arg){
    
    struct thread_param* tp = ((struct thread_param*)arg);
    PolarCanvas* canvas  = tp->canvas;
    EngineShape* shapeToWorkOn = canvas->_shapeToWorkOn;
    EngineShape* lastCollidedWith = NULL;
    int seq = tp->seq;
    int start=-1;
    int end=-1;
    
//    pthread_mutex_lock(&canvas->numActiveThreads_mutex);
//    canvas->_signoffSheet[seq] = false;
//    pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
    pthread_mutex_lock(&canvas->count_threshold_mutex);
    pthread_cond_broadcast(&canvas->count_threshold_cv);
    pthread_mutex_unlock(&canvas->count_threshold_mutex);
    while(canvas->_attempt<canvas->_maxAttemptsToPlace &&  shapeToWorkOn!=NULL && !shapeToWorkOn->_found) {
        pthread_mutex_lock(&(canvas->attempt_mutex));
        start = canvas->_attempt;
        end = canvas->_attempt+THREAD_STEP_SIZE<canvas->_maxAttemptsToPlace?canvas->_attempt+THREAD_STEP_SIZE:canvas->_maxAttemptsToPlace;
        canvas->_attempt = end;
        pthread_mutex_unlock(&(canvas->attempt_mutex));
        
        for(int currentAttempt=start;currentAttempt<end && canvas->_attempt<canvas->_maxAttemptsToPlace && !shapeToWorkOn->_found;currentAttempt++)
        {
            Placement* relative = canvas->getNudger()->nudgeFor(shapeToWorkOn, canvas->_candidatePlacement, currentAttempt,canvas->_maxAttemptsToPlace);
            Placement newPlacement = (*canvas->_candidatePlacement + (*relative));
            shapeToWorkOn->nudgeTo(seq,&newPlacement,canvas->_candidatePlacement->patch->getLayer()->getAngler());
            delete relative;
            
            //
            if (shapeToWorkOn->trespassed(seq,canvas->_candidatePlacement->patch->getLayer()))
                continue;
            CartisianPoint loc = shapeToWorkOn->getCurrentPlacement(tp->seq)->location;
            if (loc.x < 0|| loc.y < 0|| loc.x + shapeToWorkOn->getShape()->getWidth() >= canvas->width
                || loc.y + shapeToWorkOn->getShape()->getHeight() >= canvas->height) {
                continue;
            }
            
            if (canvas->_lastCollidedWith != NULL && shapeToWorkOn->getShape()->getTree()->overlaps(seq,canvas->_lastCollidedWith->getShape()->getTree(),canvas->_lastCollidedWith->getShape()->getTree()->getFinalSeq())) {
                continue;
            }
            
            //            bool foundOverlap= false;
            
            //					for (var i:int= 0; !foundOverlap && i < neighboringEWords.length; i++) {
            for (tr1::unordered_map<unsigned int,EngineShape*>::iterator it=canvas->displayShapes.begin(); it != canvas->displayShapes.end(); ++it ) {
                //						var otherWord:EngineWordVO= neighboringEWords[i];
                EngineShape* otherShape = it->second;
                if (otherShape->wasSkipped()) continue; //can't overlap with skipped word
#if NUM_THREADS>1
                assert(shapeToWorkOn->getShape()->getTree()->getFinalSeq()<0);
#endif
                if (shapeToWorkOn->getShape()->getTree()->overlaps(seq,otherShape->getShape()->getTree(),otherShape->getShape()->getTree()->getFinalSeq())) {
                    //                    foundOverlap = true;
                    
                    lastCollidedWith = otherShape;
                    goto end_of_inner;
                }
            }
            for (tr1::unordered_map<unsigned int,EngineShape*>::iterator it=canvas->fixedShapes.begin(); it != canvas->fixedShapes.end(); ++it ) {
                EngineShape* otherShape = it->second;
                if (otherShape->wasSkipped()) continue; //can't overlap with skipped word
                
                if (shapeToWorkOn->getShape()->getTree()->overlaps(seq,otherShape->getShape()->getTree(),otherShape->getShape()->getTree()->getFinalSeq())) {
                    
                    lastCollidedWith = otherShape;
                    goto end_of_inner;
                }
            }
            if(shapeToWorkOn->_found){
                pthread_mutex_lock(&canvas->numActiveThreads_mutex);
                canvas->_signoffSheet[seq]=true;
                pthread_mutex_lock(&canvas->count_threshold_mutex);
                pthread_cond_broadcast(&canvas->count_threshold_cv);
                pthread_mutex_unlock(&canvas->count_threshold_mutex);
                pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
                return;
            }
            
            if(lastCollidedWith!=NULL)canvas->_lastCollidedWith=lastCollidedWith;

            
            pthread_mutex_lock(&canvas->shape_mutex);
            if (!shapeToWorkOn->_found) {
                shapeToWorkOn->_winningSeq = seq;
                //						successCount++;
                canvas->_candidatePlacement->patch->setLastAttempt(currentAttempt);
                shapeToWorkOn->_found = true;
            }
            pthread_mutex_unlock(&canvas->shape_mutex);
            //            if(!foundOverlap){
            pthread_mutex_lock(&canvas->numActiveThreads_mutex);
            canvas->_signoffSheet[seq]=true;
            pthread_mutex_lock(&canvas->count_threshold_mutex);
            pthread_cond_broadcast(&canvas->count_threshold_cv);
            pthread_mutex_unlock(&canvas->count_threshold_mutex);
            pthread_mutex_unlock(&canvas->numActiveThreads_mutex);

            return;
            //            }
        end_of_inner:
            continue;
        }
    }
    pthread_mutex_lock(&canvas->numActiveThreads_mutex);
    canvas->_signoffSheet[seq]=true;
    pthread_mutex_lock(&canvas->count_threshold_mutex);
    pthread_cond_broadcast(&canvas->count_threshold_cv);
    pthread_mutex_unlock(&canvas->count_threshold_mutex);
    pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
}

int PolarCanvas::calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p, double shrinkage){
    srand((unsigned)time(NULL));
    int original = (p->getWidth() * p->getHeight())  / (shape->getShape()->getWidth() * shape->getShape()->getHeight()) * diligence;
    return original * (1+ ((double) rand() / double(RAND_MAX)) * 0.2)
    * (shrinkage+0.3)
    ;
}

bool PolarCanvas::placeShape(EngineShape* eShape){
    computeDesiredPlacements(eShape);
    
    while(eShape->hasNextDesiredPlacement()){
        
        _candidatePlacement = eShape->nextDesiredPlacement();
        _maxAttemptsToPlace = MAX_ATTEMPTS_TO_PLACE > 0 ? MAX_ATTEMPTS_TO_PLACE : calculateMaxAttemptsFromShapeSize(eShape, _candidatePlacement->patch, this->getSizer()->getCurrentSize());
        
        //        int seq[maxAttemptsToPlace];
        //        for(int i=0;i<maxAttemptsToPlace;i++)
        //            seq[i]=i;
        //        shuffle(seq, maxAttemptsToPlace);
        ////
        eShape->_found = false;
        _attempt = 0;
        
        //unleash thread workers
        _shapeToWorkOn = eShape;
        
        thread_param *tp;
        this->_lastCollidedWith = NULL;
#if NUM_THREADS>1
        for(int i=0;i<NUM_THREADS;i++){
            _signoffSheet[i] = false;
        }
        pthread_mutex_lock(&count_threshold_mutex);

               for(int t=0; t<NUM_THREADS; t++){
            tp = (thread_param *)malloc(sizeof(thread_param));
            tp->seq = t;
            tp->canvas = this;
            //        pthread_create(&threads[t], &attr, attempt_nudge, (void *)tp);
            //            thpool_add_work(threadpool, attempt_nudge, (void*)tp);
			threadpool_add_task(pool,attempt_nudge,(void*)tp,1);
        }
    while(true){
        printf("PlaceShape waiting on count_threshold_cv...\n");
        pthread_cond_wait(&count_threshold_cv, &count_threshold_mutex);
        printf("PlaceShape wait is over on count_threshold_cv.\n");

//        pthread_mutex_lock(&numActiveThreads_mutex);
        bool allSignedOff = true;
        for(int i=0;i<NUM_THREADS;i++){
            if(!_signoffSheet[i]) {
                allSignedOff = false;
                break;
            }
        }
//        pthread_mutex_unlock(&numActiveThreads_mutex);
        if(allSignedOff){
            break;
        }
    }
        pthread_mutex_unlock(&count_threshold_mutex);
//        pthread_mutex_lock(&numActiveThreads_mutex);
//        printf("numActiveThreads: %d\n",_signoffSheet);
//        assert(_signoffSheet==0);
//        pthread_mutex_unlock(&numActiveThreads_mutex);

        //        };
//        
#else
        tp = (thread_param *)malloc(sizeof(thread_param));
        tp->seq = 0;
        tp->canvas = this;
        attempt_nudge(tp);
        free(tp);
#endif
        if(!eShape->_found){
            _candidatePlacement->patch->setLastAttempt(_attempt);
            _candidatePlacement->patch->fail();
        }
        else{
            _candidatePlacement->patch->mark(eShape->getShape()->getWidth()*eShape->getShape()->getHeight(), false);
            eShape->finalizePlacement(eShape->_winningSeq);
            getPlacer()->success(eShape->getDesiredPlacements());
            return true;
            //                placer->success();
        }
    }
    
    skipShape(eShape, SKIP_REASON_NO_SPACE);
    //			info.patch.mark(wordImageWidth*wordImageHeight, true);
    getPlacer()->fail(eShape->getDesiredPlacements());
    printf("Shape #%d render failed.\n",eShape->getUid());
    //			tu.failedLastVar = true;
    return false;
}

void PolarCanvas::skipShape(EngineShape* shape, int reason){
    shape->skipBecause(reason);
}

float PolarCanvas::getHeight(){
    if(isnan(height)){
        float maxHeight = 0;
        for (vector<PolarLayer*>::iterator it = begin();
             it != end(); ++it) {
            PolarLayer* l = (*it);
            if(maxHeight < l->getHeight()) maxHeight = l->getHeight();
        }
        if(maxHeight > 0) height = maxHeight;
    }
    return height;
}

float PolarCanvas::getWidth(){
    if(isnan(width)){
        float maxWidth = 0;
        for (vector<PolarLayer*>::iterator it = begin();
             it != end(); ++it) {
            PolarLayer* l = (*it);
            if(maxWidth < l->getWidth()) maxWidth = l->getWidth();
        }
        if(maxWidth > 0) width = maxWidth;
    }
    return width;
}

void PolarCanvas::computeDesiredPlacements(EngineShape* shape){
    shape->setDesiredPlacements(getPlacer()->place(shape, _shapeMap.size()));
    
}

DensityPatchIndex* PolarCanvas::getPatchIndex(){
    if(_patchIndex==NULL){
        _patchIndex = new DensityPatchIndex(this);
    }
    return _patchIndex;
}

void PolarCanvas::setStatus(STATUS status){
    pthread_mutex_lock(&status_mutex);
    this->_status = (status==-1 && this->_status==0)?0:status;
    pthread_mutex_unlock(&status_mutex);
}

STATUS PolarCanvas::getStatus(){
//    pthread_mutex_lock(&status_mutex);
    return this->_status;
//    pthread_mutex_unlock(&status_mutex);

}

void PolarCanvas::addLayer (PolarLayer* val){
    push_back(val);
    printf("Layer added. w: %d, h: %d",val->getWidth(), val->getHeight());
    connectLayers();
}


Placer* PolarCanvas::getPlacer(){
    if(_placer==NULL){
        _placer = new ColorMapPlacer(this, getPatchIndex());
    }
    return _placer;
}


void PolarCanvas::connectLayers(){
    for(int i=0;i<size();i++){
        if(this->at(i)!=NULL){
            //may be null because zip module sometimes expands and fill in nulls to fit capacity
            this->at(i)->above = NULL;
            at(i)->below = NULL;
            if(i>0) PolarLayer::connect(at(i),at(i-1));
        }
    }
}

void PolarCanvas::fixShape(int sid){
    pthread_mutex_lock(&shape_mutex);

    EngineShape* shape = _shapeMap[sid];
    fixedShapes[shape->getUid()]=shape;
    

        printf("Shape #%d fixed at x:%f,y:%f, r: %f, scale: %f. Total num of fixed shapes: %ld\n",shape->getUid(),shape->getFinalPlacement().location.x,shape->getFinalPlacement().location.y,shape->getFinalPlacement().rotation,shape->getShape()->getTree()->getScale(),fixedShapes.size());
    pthread_mutex_unlock(&shape_mutex);

}

void PolarCanvas::fixShape(int sid, double x, double y, double rotation,double scaleX, double scaleY){
    EngineShape* shape = _shapeMap[sid];
    Placement place(sid);
    place.location.x = x;
    place.location.y = y;
    place.rotation = rotation;
    shape->setFinalPlacement(place);

    shape->getShape()->getTree()->setLocation(shape->getShape()->getTree()->getFinalSeq(), x, y);
    shape->getShape()->getTree()->setRotation(shape->getShape()->getTree()->getFinalSeq(), rotation);
    //TODO
    shape->getShape()->getTree()->setScale(scaleX);
    fixShape(sid);
}

vector<int> PolarCanvas::getShapesCollidingWith(int sid){
    EngineShape* shape = _shapeMap[sid];
    vector<int> overlaps;
    
    for (tr1::unordered_map<unsigned int,EngineShape*>::iterator it=displayShapes.begin(); it != displayShapes.end(); ++it ) {
        EngineShape* otherShape = it->second;
        if (otherShape->getUid()!=shape->getUid() && otherShape->getShape()->getTree()->overlaps(otherShape->getShape()->getTree()->getFinalSeq(),shape->getShape()->getTree(),shape->getShape()->getTree()->getFinalSeq()))
        {
            if(fixedShapes.find(otherShape->getUid())==fixedShapes.end()) overlaps.push_back(otherShape->getUid());
        }
    }
    return overlaps;
}


void PolarCanvas::resetFixedShapes(){
    this->_shapeMap.clear();
}

double PolarCanvas::getSuccessRate(){
    return (float)displayShapes.size()/(float)_shapeMap.size();
}

void PolarCanvas::registerShape(EngineShape *shape){
    pthread_mutex_lock(&shape_mutex);
    if(shape!=NULL){
//    _shapes->push_back(shape);
    shape->referenceCounter++;
    _shapeMap[shape->getUid()] = shape;
        printf("Shape registered. sid:%d, w:%d,h:%d\n",_shapeMap[shape->getUid()]->getUid(),_shapeMap[shape->getUid()]->getShape()->getWidth(),_shapeMap[shape->getUid()]->getShape()->getHeight());
//    _shapeMap.insert(std::make_pair<int,EngineShape*>(shape->getUid(),shape));
    }
    pthread_mutex_unlock(&shape_mutex);

}
