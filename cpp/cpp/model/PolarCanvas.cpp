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
#include <cmath>
#include <limits>
#include <cstdlib>
#include <ctime>
#include <pthread.h>




PolarCanvas::PolarCanvas():failureCount(0),numRetries(0),totalAttempted(0),
width(NAN),height(NAN),status(PAUSED),_sizer(NULL),_nudger(NULL),_placer(NULL),_patchIndex(NULL),
perseverance(DEFAULT_PERSEVERANCE),diligence(DEFAULT_DILIGENCE)
{
    this->layers = new vector<PolarLayer*>();
    this->shapes = new vector<EngineShape*>();
    this->displayShapes = new vector<EngineShape*>();
    this->retryShapes = new vector<EngineShape*>();

}


Placement* PolarCanvas::slapShape(ImageShape* shape){
    if(failureCount <= perseverance && status == RENDERING){
        EngineShape* eShape = generateEngineWord(shape);
        Placement* p = tryCurrentSize(eShape);
        if(p!=NULL) return p;
    }
    return NULL;
}

EngineShape* PolarCanvas::generateEngineWord(ImageShape* shape){
//    int newIndex = totalAttempted<tu.words.size?totalAttemptedWords
    //				+ indexOffset
//    :tu.words.size;
    
    EngineShape* eShape = new EngineShape(shape);
    return eShape;
}

vector<PolarLayer*>* PolarCanvas::getLayers(){
    return layers;
}

Placement* PolarCanvas::tryCurrentSize(EngineShape * shape){
    placeShape(shape);
    if(shape->wasSkipped()){
        if(getSizer()->hasNextSize()){
            if(totalAttempted>0){
                retryShapes->push_back(shape);
                numRetries++;
            }
            else
                numRetries = MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;
            if(numRetries==MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE ){
                getSizer()->switchToNextSize();
                numRetries = 0;
            }
            return NULL;
        }
    }
    
    shapes->push_back(shape);
    if(!shape->wasSkipped()){
        if(failureCount>1) failureCount -= 2;
        displayShapes->push_back(shape);
    }
    else{
        failureCount++;
        if(failureCount>perseverance){
            status = PAUSED;
        }
    }
    //TODO: notify arrival of new display shape
    return shape->getFinalPlacement();
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

struct Settable{
    EngineShape* lastCollidedWith;
    int attempt;
    int numActiveThreads;
    bool found;
    int winningSeq;
    pthread_mutex_t shape_mutex;
    pthread_mutex_t numActiveThreads_lock;
};

struct thread_param {
    int seq;
    int maxAttemptsToPlace;
    EngineShape *shape;
    PolarCanvas* canvas;
    Placement* candidatePlacement;
    Settable* settable;

};



void *PolarCanvas::attempt_nudge(void *arg){
    struct thread_param* tp = ((struct thread_param*)arg);
    EngineShape* shape = tp->shape;
    Placement* candidatePlacement = tp->candidatePlacement;
    PolarCanvas* canvas = tp->canvas;
    pthread_mutex_lock(&(tp->settable->numActiveThreads_lock));
    tp->settable->numActiveThreads++;
    pthread_mutex_unlock(&(tp->settable->numActiveThreads_lock));


    int maxAttemptsToPlace = tp->maxAttemptsToPlace;
    int attempt;
    int lower = maxAttemptsToPlace/NUM_THREADS*tp->seq;
    int upper = lower+maxAttemptsToPlace/NUM_THREADS;
    if(lower>maxAttemptsToPlace) lower = maxAttemptsToPlace;
    EngineShape* lastCollidedWith = NULL;
    
    for (attempt= lower; attempt < upper; attempt++) {
        if(tp->settable->found){
            pthread_mutex_lock(&(tp->settable->numActiveThreads_lock));
            if(lastCollidedWith!=NULL) tp->settable->lastCollidedWith=lastCollidedWith;
            tp->settable->numActiveThreads--;
            pthread_mutex_unlock(&(tp->settable->numActiveThreads_lock));
            pthread_exit(NULL);
        }
        Placement* relative = tp->canvas->getNudger()->nudgeFor(shape, candidatePlacement, attempt,maxAttemptsToPlace);
        Placement newPlacement = (*candidatePlacement + (*relative));
        shape->nudgeTo(tp->seq,&newPlacement);
        
        double angle= candidatePlacement->patch->getLayer()->getAngler()->angleFor(tp->seq,shape);
        //			eWord.getTree().draw(destination.graphics);
        
        // // TODO
        shape->getShape()->getTree()->setRotation(tp->seq,angle);
        //
        if (shape->trespassed(tp->seq,candidatePlacement->patch->getLayer()))
            continue;
        CartisianPoint loc = shape->getCurrentPlacement(tp->seq)->location;
        if (loc.x < 0|| loc.y < 0|| loc.x + shape->getShape()->getWidth() >= canvas->width
            || loc.y + shape->getShape()->getHeight() >= canvas->height) {
            continue;
        }
        
        if (tp->settable->lastCollidedWith != NULL && shape->getShape()->getTree()->overlaps(tp->seq,tp->settable->lastCollidedWith->getShape()->getTree())) {
            continue;
        }
        
        bool foundOverlap= false;
        
        //					for (var i:int= 0; !foundOverlap && i < neighboringEWords.length; i++) {
        for (int i= 0; !foundOverlap && i < canvas->shapes->size(); i++) {
            //						var otherWord:EngineWordVO= neighboringEWords[i];
            EngineShape* otherShape = canvas->shapes->at(i);
            if (otherShape->wasSkipped()) continue; //can't overlap with skipped word
            
            if (shape->getShape()->getTree()->overlaps(tp->seq,otherShape->getShape()->getTree())) {
                foundOverlap = true;
                
                lastCollidedWith = otherShape;
                goto end_of_inner;
            }
        }
        if(tp->settable->found){
            pthread_mutex_lock(&(tp->settable->numActiveThreads_lock));
            if(lastCollidedWith!=NULL) tp->settable->lastCollidedWith=lastCollidedWith;
            tp->settable->numActiveThreads--;
            pthread_mutex_unlock(&(tp->settable->numActiveThreads_lock));
            pthread_exit(NULL);
        }
        if (!foundOverlap) {
            pthread_mutex_lock(&(tp->settable->shape_mutex));
            tp->settable->found = true;
            tp->settable->winningSeq = tp->seq;
            //						successCount++;
            candidatePlacement->patch->setLastAttempt(attempt);
            pthread_mutex_unlock(&(tp->settable->shape_mutex));
        }
    end_of_inner:
        continue;
    }
    pthread_mutex_lock(&(tp->settable->numActiveThreads_lock));
    tp->settable->attempt = attempt;
    tp->settable->numActiveThreads--;
    if(lastCollidedWith!=NULL) tp->settable->lastCollidedWith=lastCollidedWith;
    pthread_mutex_unlock(&(tp->settable->numActiveThreads_lock));
    pthread_exit(NULL);
}

bool PolarCanvas::placeShape(EngineShape * shape){
    computeDesiredPlacements(shape);
    while(shape->hasNextDesiredPlacement()){
        
        Placement* candidatePlacement = shape->nextDesiredPlacement();
        int maxAttemptsToPlace = MAX_ATTEMPTS_TO_PLACE > 0 ? MAX_ATTEMPTS_TO_PLACE : calculateMaxAttemptsFromShapeSize(shape, candidatePlacement->patch);
        Settable* settable = (Settable*) malloc(sizeof(Settable));
        settable->lastCollidedWith = NULL;
        settable->attempt = 0;
        
//        int seq[maxAttemptsToPlace];
//        for(int i=0;i<maxAttemptsToPlace;i++)
//            seq[i]=i;
//        shuffle(seq, maxAttemptsToPlace);
////
        pthread_t threads[NUM_THREADS];
        int t;
        int rc;
        settable->found = false;
        settable->numActiveThreads = 0;
        for(t=0; t<NUM_THREADS; t++){
            thread_param *tp;
            tp = (thread_param *)malloc(sizeof(thread_param));
            tp->seq = t;
            tp->maxAttemptsToPlace = maxAttemptsToPlace;
            tp->shape = shape;
            tp->settable = settable;
            tp->canvas = this;
            tp->candidatePlacement = candidatePlacement;

            pthread_mutex_init(&(tp->settable->shape_mutex), NULL);
            pthread_mutex_init(&(tp->settable->numActiveThreads_lock), NULL);
            
            rc = pthread_create(&threads[t], NULL, attempt_nudge, (void *)tp);
        }
        
        while(!settable->found && settable->numActiveThreads>0){};
        if(!settable->found){
            candidatePlacement->patch->setLastAttempt(settable->attempt);
            candidatePlacement->patch->fail();
        }
        else{
            candidatePlacement->patch->mark(shape->getShape()->getWidth()*shape->getShape()->getHeight(), false);
            getPlacer()->success(shape->getDesiredPlacements());
            //                placer->success();
            shape->finalizePlacement(settable->winningSeq);
        }
    }
        
    skipShape(shape, SKIP_REASON_NO_SPACE);
    //			info.patch.mark(wordImageWidth*wordImageHeight, true);
    getPlacer()->fail(shape->getDesiredPlacements());
    //			tu.failedLastVar = true;
    return false;
}

void PolarCanvas::skipShape(EngineShape* shape, int reason){
    shape->skipBecause(reason);
}

int PolarCanvas::getHeight(){
    if(isnan(height)){
        double maxHeight = 0;
        for (vector<PolarLayer*>::iterator it = layers->begin();
             it != layers->end(); ++it) {
            PolarLayer* l = (*it);
            if(maxHeight < l->getHeight()) maxHeight = l->getHeight();
        }
        if(maxHeight > 0) height = maxHeight;
    }
    return height;
}

int PolarCanvas::getWidth(){
    if(isnan(width)){
        double maxWidth = 0;
        for (vector<PolarLayer*>::iterator it = layers->begin();
             it != layers->end(); ++it) {
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
    return original * (1+ ((double) rand() / (RAND_MAX+1)) * 0.2);
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

Placer* PolarCanvas::getPlacer(){
    if(_placer==NULL){
        _placer = new ColorMapPlacer(this, getPatchIndex());
    }
    return _placer;
}
