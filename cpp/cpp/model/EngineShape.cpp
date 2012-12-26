//
//  EngineShape.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "EngineShape.h"
#include "ImageShape.h"
#include "../angler/Angler.h"
#include "PolarCanvas.h"
#include "TextImageShape.h"
#include "PolarLayer.h"
#include "../colorer/Colorer.h"
#include "../density/Patch.h"
#include "../model/structs.h"
#include <stdlib.h>
#include <time.h>

void EngineShape::init(){
    assert(width>0&&height>0);
    drawSamples();
}

EngineShape::EngineShape(int sid, unsigned char * png, size_t size):TextImageShape(png,size),
skipReason(0),desiredPlacementIndex(0),desiredPlacements(NULL),uid(sid),referenceCounter(0){
    
}


EngineShape::EngineShape( int sid, unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb):
TextImageShape(pixels,width,height,revert,rgbaToArgb),
skipReason(0),desiredPlacementIndex(0),desiredPlacements(NULL),uid(sid),referenceCounter(0){
    init();
}

//EngineShape::EngineShape(PolarRootTree* shape, EngineShape* old):skipReason(0),desiredPlacementIndex(0),desiredPlacements(NULL),uid(old->getUid()),renderedPlacement(old->renderedPlacement),_winningSeq(old->_winningSeq),referenceCounter(0){
//    for(int i=0;i<NUM_THREADS;i++){
//        currentPlacement[i]=new Placement(uid);
//    }
//    
//    this->shape = shape;
////    PolarRootTree* oldTree = old->getTree();
////    PolarRootTree* newTree = getTree();
//#if NUM_THREADS > 1
//    int final_seq = old->getFinalSeq();
//    setFinalSeq(final_seq);
//#endif
//    setLocation(old->getCenterX(), old->getCenterY());
//    setRotation(old->getRotation());
//    //TODO
//    setScale(old->getScale());
////    drawSamples();
//
//}

EngineShape::~EngineShape(){
//    for(int i=0;i<NUM_THREADS;i++){
//        delete currentPlacement[i];
//    }
}

void EngineShape::drawSamples(){
    this->samplePoints = new vector<PolarPoint>();
    int numSamples = int((getWidth() * getHeight() / SAMPLE_DISTANCE));
    //				var numSamples = 10;
    // TODO: devise better lower bound
    if (numSamples < 20)
        numSamples = 20;
    for(int i=0; i<numSamples;i++){
			int relativeX= rand() % getWidth();
			int relativeY= rand() % getHeight();
			if(containsPoint(relativeX, relativeY))
			{
				relativeX -= getWidth()/2;
				relativeY -= getHeight()/2;
				double d = sqrt(relativeX*relativeX+relativeY*relativeY);
				double r = atan2(relativeY, relativeX);
                PolarPoint p(d,r);
				samplePoints->push_back(p);
			}
		}
}

bool EngineShape::wasSkipped(){
    return skipReason > 0;
}

void EngineShape::skipBecause(int reason){
//    printf("Skipped because %d\n",reason);
    this->skipReason = reason;
}

void EngineShape::nudgeTo(int seq,Placement *p,Angler* angler){
    setLocation(seq,p->location);
    
    double angle= angler->angleFor(seq,this,getRotation(seq));
    setRotation(seq,p->rotation = angle);
}


vector<Placement*>* EngineShape::getDesiredPlacements(){
    return desiredPlacements;
}

void EngineShape::setDesiredPlacements(vector<Placement*>* placements){
    if(desiredPlacements!=NULL){
        for(int i=0;i<desiredPlacements->size();i++)
            delete desiredPlacements->at(i);
        delete desiredPlacements;
    }
    desiredPlacements = placements;
}


bool EngineShape::trespassed(int seq,PolarLayer* layer){
    if(layer==NULL) return false;
    double x = this->currentPlacement[seq].location.x;
    double y = this->currentPlacement[seq].location.y;
    if(x<0||y<0||x>layer->getWidth()||y>layer->getHeight())
        return true;

    if (layer->suitableForPlacement(this->currentPlacement[seq].location.x ,
                                     this->currentPlacement[seq].location.y, this->samplePoints, currentPlacement[seq].rotation
                                     ))
    {
        return (layer->aboveContainsAnyPolarPoints(this->currentPlacement[seq].location.x ,
                                                  this->currentPlacement[seq].location.y, this->samplePoints, currentPlacement[seq].rotation
                                                  ));
    }
    
    return true;
}


void EngineShape::finalizePlacement(int final_seq, int canvasId, int failureCount){
    unsigned int color= currentPlacement[final_seq].patch->getLayer()->getColorer()->colorFor(&currentPlacement[final_seq]);
    renderedPlacement = new SlapInfo(getUid(), canvasId, currentPlacement[final_seq].location, currentPlacement[final_seq].rotation, currentPlacement[final_seq].layer,color,failureCount);
    currentPlacement[final_seq].patch->getShapes()->push_back(this);
}