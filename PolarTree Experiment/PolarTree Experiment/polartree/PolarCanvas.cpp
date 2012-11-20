//
//  PolarCanvas.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PolarCanvas.h"
#include "EngineShape.h"
#include "Sizer.h"
#include "ByWeightSizer.h"
#include "Placer.h"
#include "ColorMapPlacer.h"
#include "Patch.h"
#include "WordLayer.h"
#include "Angler.h"
#include "ColorMapAngler.h"
#include "PolarRootTree.h"
#include "Nudger.h"
#include "Placer.h"
#include "ColorMapPlacer.h"
#include "ColorMapZigzagNudger.h"
#include "DensityPatchIndex.h"
#include <cmath>
#include <limits>
#include <cstdlib>
#include <ctime>

PolarCanvas::PolarCanvas():failureCount(0),numRetries(0),totalAttempted(0),
width(NAN),height(NAN),status(PAUSED),_sizer(NULL),_nudger(NULL),_placer(NULL),_patchIndex(NULL),
perseverance(10),diligence(4)
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

bool PolarCanvas::placeShape(EngineShape * shape){
    computeDesiredPlacements(shape);
    while(shape->hasNextDesiredPlacement()){
        Placement* candidatePlacement = shape->nextDesiredPlacement();
        int maxAttemptsToPlace = MAX_ATTEMPTS_TO_PLACE > 0 ? MAX_ATTEMPTS_TO_PLACE : calculateMaxAttemptsFromShapeSize(shape, candidatePlacement->patch);
        EngineShape* lastCollidedWith = NULL;
        int attempt;
        for (attempt= 0; attempt < maxAttemptsToPlace; attempt++) {
            Placement* relative = getNudger()->nudgeFor(shape, candidatePlacement, attempt,maxAttemptsToPlace);
            Placement newPlacement = (*candidatePlacement + (*relative));
            shape->nudgeTo(&newPlacement);
            
            double angle= candidatePlacement->patch->getLayer()->getAngler()->angleFor(shape);
            //			eWord.getTree().draw(destination.graphics);
            
            // // TODO
            shape->getShape()->getTree()->setRotation(angle);
            //
            if (shape->trespassed(candidatePlacement->patch->getLayer()))
                continue;
            CartisianPoint loc = shape->getCurrentPlacement()->location;
            if (loc.x < 0|| loc.y < 0|| loc.x + shape->getShape()->getWidth() >= this->width
                || loc.y + shape->getShape()->getHeight() >= this->height) {
                continue;
            }
            
            if (lastCollidedWith != NULL && shape->getShape()->getTree()->overlaps(lastCollidedWith->getShape()->getTree())) {
                continue;
            }
            
            bool foundOverlap= false;
            
            //					for (var i:int= 0; !foundOverlap && i < neighboringEWords.length; i++) {
            for (int i= 0; !foundOverlap && i < shapes->size(); i++) {
                //						var otherWord:EngineWordVO= neighboringEWords[i];
                EngineShape* otherShape = shapes->at(i);
                if (otherShape->wasSkipped()) continue; //can't overlap with skipped word
                
                if (shape->getShape()->getTree()->overlaps(otherShape->getShape()->getTree())) {
                    foundOverlap = true;
                    
                    lastCollidedWith = otherShape;
                    goto end_of_inner;
                }
            }
            
            if (!foundOverlap) {
                candidatePlacement->patch->mark(shape->getShape()->getWidth()*shape->getShape()->getHeight(), false);
                getPlacer()->success(shape->getDesiredPlacements());
//                placer->success();
                shape->finalizePlacement();
                //						successCount++;
                candidatePlacement->patch->setLastAttempt(attempt);
                return true;
            }
        end_of_inner:
            continue;
        }
            candidatePlacement->patch->setLastAttempt(attempt);
            candidatePlacement->patch->fail();
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
