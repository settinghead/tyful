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
#include "../density/DensityPatchIndex.h"
#include "structs.h"
#include <cmath>
#include <limits>
#include <cstdlib>
#include <ctime>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>


struct thread_param {
    int seq;
    PolarCanvas* canvas;
};

ThreadControllers PolarCanvas::threadControllers;

PolarCanvas* PolarCanvas::current = NULL;

PolarCanvas::PolarCanvas():failureCount(0),numRetries(0),totalAttempted(0),
width(NAN),height(NAN),status(PAUSED),_sizer(NULL),_nudger(NULL),_placer(NULL),_patchIndex(NULL),
perseverance(DEFAULT_PERSEVERANCE),diligence(DEFAULT_DILIGENCE),_lastCollidedWith(NULL),_attempt(0),
_shapeToWorkOn(NULL),_numActiveThreads(0), slaps(new queue<SlapInfo*>()), pendingShapes(new queue<EngineShape*>)
{
    this->shapes = new vector<EngineShape*>();
    this->displayShapes = new vector<EngineShape*>();
    this->retryShapes = new vector<EngineShape*>();

    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_mutex_init(&shape_mutex, NULL);
    pthread_mutex_init(&attempt_mutex, NULL);
    pthread_mutex_init(&numActiveThreads_mutex,NULL);
    pthread_cond_init (&count_threshold_cv, NULL);
    

    
    //spawn threads
	if ((pool = threadpool_init(NUM_THREADS)) == NULL) {
		printf("Error! Failed to create a thread pool struct.\n");
		exit(EXIT_FAILURE);
	}

}

PolarCanvas::~PolarCanvas(){
    pthread_attr_destroy(&attr);
    pthread_mutex_destroy(&numActiveThreads_mutex);
    pthread_mutex_destroy(&shape_mutex);
    pthread_mutex_destroy(&attempt_mutex);
    pthread_cond_destroy(&count_threshold_cv);
    
    threadpool_free(pool,1);
    
    delete shapes;
    delete pendingShapes;
    
}


void PolarCanvas::feedShape(ImageShape* shape, unsigned int sid){
    if(failureCount <= perseverance && status == RENDERING){
        EngineShape* eShape = generateEngineWord(shape,sid);
        pendingShapes->push(eShape);
    }
}

EngineShape* PolarCanvas::generateEngineWord(ImageShape* shape,unsigned int sid){
//    int newIndex = totalAttempted<tu.words.size?totalAttemptedWords
    //				+ indexOffset
//    :tu.words.size;
    
    EngineShape* eShape = new EngineShape(shape,sid);
    return eShape;
}

void PolarCanvas::tryNextEngineShape(){
    if(!pendingShapes->empty()){
        EngineShape* eShape = pendingShapes->front();
        pendingShapes->pop();
        placeShape(eShape);
        if(eShape->wasSkipped()){
            if(getSizer()->hasNextSize()){
                if(totalAttempted>0){
                    retryShapes->push_back(eShape);
                    numRetries++;
                }
                else
                    numRetries = MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;
                if(numRetries==MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE ){
                    getSizer()->switchToNextSize();
                    numRetries = 0;
                }
                return;
            }
        }
        
        shapes->push_back(eShape);
        if(!eShape->wasSkipped()){
            if(failureCount>1) failureCount -= 2;
            displayShapes->push_back(eShape);
        }
        else{
            failureCount++;
            if(failureCount>perseverance){
                status = PAUSED;
            }
        }
        //TODO: notify arrival of new display shape
        Placement* placement= eShape->getFinalPlacement();
        
        if(placement!=NULL){
            printf("Coord: %f, %f; rotation: %f, color: 0x%x\n"
                   ,eShape->getShape()->getTree()->getTopLeftLocation(eShape->getShape()->getTree()->getFinalSeq()).x
                   ,eShape->getShape()->getTree()->getTopLeftLocation(eShape->getShape()->getTree()->getFinalSeq()).y
                   ,eShape->getShape()->getTree()->getRotation(eShape->getShape()->getTree()->getFinalSeq()),placement->color);
            SlapInfo* place = new SlapInfo;
            place->location = eShape->getShape()->getTree()->getTopLeftLocation(eShape->getShape()->getTree()->getFinalSeq());
            place->rotation = eShape->getShape()->getTree()->getRotation(eShape->getShape()->getTree()->getFinalSeq());
            place->color = placement->color;
            place->failureCount = getFailureCount();
            place->sid = eShape->getUid();
            slaps->push(place);
            
        }
    
    }
}


Nudger* PolarCanvas::getNudger(){
    if(_nudger==NULL){
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
    EngineShape* lastCollidedWith = NULL;
    int seq = tp->seq;
    int start=-1;
    int end=-1;
    
    pthread_mutex_lock(&canvas->numActiveThreads_mutex);
    canvas->_numActiveThreads++;
    pthread_cond_signal(&canvas->count_threshold_cv);
    pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
    while(true) {
        bool over = canvas->_attempt>=canvas->_maxAttemptsToPlace || canvas->_found || canvas->_shapeToWorkOn==NULL;
        if(over){
            pthread_mutex_lock(&canvas->numActiveThreads_mutex);
            canvas->_numActiveThreads--;
            pthread_cond_signal(&canvas->count_threshold_cv);
            pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
            return;
        }
        
        pthread_mutex_lock(&(canvas->attempt_mutex));
        start = canvas->_attempt;
        end = canvas->_attempt+THREAD_STEP_SIZE<canvas->_maxAttemptsToPlace?canvas->_attempt+THREAD_STEP_SIZE:canvas->_maxAttemptsToPlace;
        canvas->_attempt = end;
        pthread_mutex_unlock(&(canvas->attempt_mutex));
        
        for(int currentAttempt=start;currentAttempt<end;currentAttempt++)
        {
            Placement* relative = canvas->getNudger()->nudgeFor(canvas->_shapeToWorkOn, canvas->_candidatePlacement, currentAttempt,canvas->_maxAttemptsToPlace);
            Placement newPlacement = (*canvas->_candidatePlacement + (*relative));
            canvas->_shapeToWorkOn->nudgeTo(seq,&newPlacement,canvas->_candidatePlacement->patch->getLayer()->getAngler());
            

            //
            if (canvas->_shapeToWorkOn->trespassed(seq,canvas->_candidatePlacement->patch->getLayer()))
                continue;
            CartisianPoint loc = canvas->_shapeToWorkOn->getCurrentPlacement(tp->seq)->location;
            if (loc.x < 0|| loc.y < 0|| loc.x + canvas->_shapeToWorkOn->getShape()->getWidth() >= canvas->width
                || loc.y + canvas->_shapeToWorkOn->getShape()->getHeight() >= canvas->height) {
                continue;
            }
            
            if (canvas->_lastCollidedWith != NULL && canvas->_shapeToWorkOn->getShape()->getTree()->overlaps(seq,canvas->_lastCollidedWith->getShape()->getTree())) {
                continue;
            }
            
            bool foundOverlap= false;
            
            //					for (var i:int= 0; !foundOverlap && i < neighboringEWords.length; i++) {
            for (int i= 0; !foundOverlap && i < canvas->shapes->size(); i++) {
                //						var otherWord:EngineWordVO= neighboringEWords[i];
                EngineShape* otherShape = canvas->shapes->at(i);
                if (otherShape->wasSkipped()) continue; //can't overlap with skipped word
                
                if (canvas->_shapeToWorkOn->getShape()->getTree()->overlaps(seq,otherShape->getShape()->getTree())) {
                    foundOverlap = true;
                    
                    lastCollidedWith = otherShape;
                    goto end_of_inner;
                }
            }
            if(canvas->_found){
                pthread_mutex_lock(&canvas->numActiveThreads_mutex);
                canvas->_numActiveThreads--;
                pthread_cond_signal(&canvas->count_threshold_cv);
                pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
                return;
            }
            pthread_mutex_unlock(&canvas->shape_mutex);
            if (!foundOverlap) {
                canvas->_winningSeq = seq;
                //						successCount++;
                canvas->_candidatePlacement->patch->setLastAttempt(currentAttempt);
                canvas->_found = true;
            }
            pthread_mutex_unlock(&canvas->shape_mutex);
            if(!foundOverlap){
                pthread_mutex_lock(&canvas->numActiveThreads_mutex);
                canvas->_numActiveThreads--;
                pthread_cond_signal(&canvas->count_threshold_cv);
                pthread_mutex_unlock(&canvas->numActiveThreads_mutex);
                return;
            }
            if(lastCollidedWith!=NULL)canvas->_lastCollidedWith=lastCollidedWith;
        }
    end_of_inner:
        continue;
    }
    assert(false);
    return;

}

bool PolarCanvas::placeShape(EngineShape* eShape){
    computeDesiredPlacements(eShape);

    while(eShape->hasNextDesiredPlacement()){
        
        _candidatePlacement = eShape->nextDesiredPlacement();
        _maxAttemptsToPlace = MAX_ATTEMPTS_TO_PLACE > 0 ? MAX_ATTEMPTS_TO_PLACE : calculateMaxAttemptsFromShapeSize(eShape, _candidatePlacement->patch);
        
//        int seq[maxAttemptsToPlace];
//        for(int i=0;i<maxAttemptsToPlace;i++)
//            seq[i]=i;
//        shuffle(seq, maxAttemptsToPlace);
////
        _found = false;
        _attempt = 0;
        
        //unleash thread workers
        _shapeToWorkOn = eShape;
        
        thread_param *tp;

#if NUM_THREADS>1
        pthread_mutex_lock(&numActiveThreads_mutex);
        for(int t=0; t<NUM_THREADS; t++){
            tp = (thread_param *)malloc(sizeof(thread_param));
            tp->seq = t;
            tp->canvas = this;
            //        pthread_create(&threads[t], &attr, attempt_nudge, (void *)tp);
//            thpool_add_work(threadpool, attempt_nudge, (void*)tp);
			threadpool_add_task(pool,attempt_nudge,(void*)tp,1);
        }
        
        while((!_found && _attempt<_maxAttemptsToPlace) || _numActiveThreads>0){
            pthread_cond_wait(&count_threshold_cv, &numActiveThreads_mutex);
        };
        pthread_mutex_unlock(&numActiveThreads_mutex);
#else
        tp = (thread_param *)malloc(sizeof(thread_param));
        tp->seq = 0;
        tp->canvas = this;
        attempt_nudge(tp);
#endif
        if(!_found){
            _candidatePlacement->patch->setLastAttempt(_attempt);
            _candidatePlacement->patch->fail();
        }
        else{
            _candidatePlacement->patch->mark(eShape->getShape()->getWidth()*eShape->getShape()->getHeight(), false);
            eShape->finalizePlacement(_winningSeq);
            getPlacer()->success(eShape->getDesiredPlacements());
            _shapeToWorkOn = NULL;
            return true;
            //                placer->success();
        }
    }
    //lock thread workers
    _shapeToWorkOn = NULL;

    skipShape(eShape, SKIP_REASON_NO_SPACE);
    //			info.patch.mark(wordImageWidth*wordImageHeight, true);
    getPlacer()->fail(eShape->getDesiredPlacements());
    //			tu.failedLastVar = true;
    return false;
}

void PolarCanvas::skipShape(EngineShape* shape, int reason){
    shape->skipBecause(reason);
}

inline float PolarCanvas::getHeight(){
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

inline float PolarCanvas::getWidth(){
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

int PolarCanvas::calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p){
    srand((unsigned)time(NULL));
    int original = (p->getWidth() * p->getHeight())  / (shape->getShape()->getWidth() * shape->getShape()->getHeight()) * diligence;
    return original * (1+ ((double) rand() / (RAND_MAX)) * 0.2);
}

void PolarCanvas::computeDesiredPlacements(EngineShape* shape){
    shape->setDesiredPlacements(getPlacer()->place(shape, shapes->size()));
    
}

DensityPatchIndex* PolarCanvas::getPatchIndex(){
    if(_patchIndex==NULL){
        _patchIndex = new DensityPatchIndex(this);
    }
    return _patchIndex;
}

void PolarCanvas::setStatus(STATUS status){
    this->status = status;
}

STATUS PolarCanvas::getStatus(){
    return this->status;
}

void PolarCanvas::addLayer (PolarLayer* val){
    push_back(val);
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
