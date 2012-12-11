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
#include "../tree/PolarRootTree.h"
#include "PolarLayer.h"
#include "../colorer/Colorer.h"
#include "../density/Patch.h"
#include <stdlib.h>
#include <time.h>

EngineShape::EngineShape(ImageShape* shape, unsigned int sid):skipReason(0),desiredPlacementIndex(NULL),desiredPlacements(0),uid(sid),renderedPlacement(NULL),_winningSeq(-1),referenceCounter(0){
    for(int i=0;i<NUM_THREADS;i++){
        currentPlacement[i]=new Placement(sid);
    }
    this->shape = shape;
    this->shape->getTree();
    drawSamples();
}

EngineShape::~EngineShape(){
    delete shape;
    for(int i=0;i<NUM_THREADS;i++){
        delete currentPlacement[i];
    }
}

void EngineShape::drawSamples(){
    this->samplePoints = new vector<PolarPoint>();
    int numSamples = int((shape->getWidth() * shape->getHeight() / SAMPLE_DISTANCE));
    //				var numSamples = 10;
    // TODO: devise better lower bound
    if (numSamples < 20)
        numSamples = 20;
    for(int i=0; i<numSamples;i++){
			double relativeX= int((rand() % shape->getWidth()));
			double relativeY= int((rand() % shape->getHeight()));
			if(shape->containsPoint(relativeX, relativeY))
			{
				relativeX -= shape->getWidth()/2;
				relativeY -= shape->getHeight()/2;
				double d = sqrt(pow(relativeX,2)+pow(relativeY,2));
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
    currentPlacement[seq]->location = p->location;
    currentPlacement[seq]->patch = p->patch;
    
    double angle= angler->angleFor(seq,this);
    currentPlacement[seq]->rotation = p->rotation = angle;
    this->getShape()->getTree()->setRotation(seq,angle);
    
    currentPlacement[seq]->rotation = p->rotation;
    shape->getTree()->setLocation(seq,currentPlacement[seq]->location.x,
                       currentPlacement[seq]->location.y);
    shape->getTree()->setRotation(seq,currentPlacement[seq]->rotation);
}

void EngineShape::finalizePlacement(int final_seq){
#if NUM_THREADS > 1
    shape->getTree()->setFinalSeq(final_seq);
#endif
    shape->getTree()->setLocation(shape->getTree()->getFinalSeq(),currentPlacement[final_seq]->location.x, currentPlacement[final_seq]->location.y);
    
    unsigned int color= currentPlacement[final_seq]->patch->getLayer()->getColorer()->colorFor(currentPlacement[final_seq]);
    currentPlacement[final_seq]->color = color;
    renderedPlacement = currentPlacement[final_seq];

    currentPlacement[final_seq]->patch->getShapes()->push_back(this);
}

Placement* EngineShape::getFinalPlacement(){
    return renderedPlacement;
}
Placement* EngineShape::getOrCreateFinalPlacement(){
    if( renderedPlacement==NULL)
        renderedPlacement = new Placement(this->getUid());
    return renderedPlacement;
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
    double x = this->currentPlacement[seq]->location.x;
    double y = this->currentPlacement[seq]->location.y;
    if(x<0||y<0||x>layer->getWidth()||y>layer->getHeight())
        return true;
    
    // float right = (float) (this.currentLocation.x + bounds
    // .getWidth());
    // float bottom = (float) (this.currentLocation.y + bounds
    // .getHeight());
    //		Assert.isTrue( this.shape.textField.width>0);
    //		Assert.isTrue( this.shape.textField.height > 0);
    
    if (layer->containsAllPolarPoints(this->currentPlacement[seq]->location.x ,
                                     this->currentPlacement[seq]->location.y, this->samplePoints, currentPlacement[seq]->rotation,
                                     this->currentPlacement[seq]->location.x,
                                     this->currentPlacement[seq]->location.y
                                     ))
    {
        return (layer->aboveContainsAnyPolarPoints(this->currentPlacement[seq]->location.x ,
                                                  this->currentPlacement[seq]->location.y, this->samplePoints, currentPlacement[seq]->rotation,
                                                  this->currentPlacement[seq]->location.x,
                                                  this->currentPlacement[seq]->location.y
                                                  ));
    }
    
    //		if (layer.contains(x, y, this.shape.textField.width, this.shape.textField.height, rotation, false))
    //	    {
    //			return (!layer.aboveContains(x, y, this.shape.textField.width, this.shape.textField.height, rotation, false));
    //		}
    return true;
}