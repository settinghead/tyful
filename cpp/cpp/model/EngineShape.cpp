//
//  EngineShape.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "EngineShape.h"
#include "ImageShape.h"
#include "PolarCanvas.h"
#include "../tree/PolarRootTree.h"
#include "PolarLayer.h"
#include "../colorer/Colorer.h"
#include "../density/Patch.h"
#include <stdlib.h>
#include <time.h>

EngineShape::EngineShape(ImageShape* shape):skipReason(0),currentPlacement(NULL),renderedPlacement(NULL),desiredPlacementIndex(NULL),desiredPlacements(0){
    this->shape = shape;
    this->shape->getTree();
    drawSamples();
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
                PolarPoint p;
                p.d = d;
                p.r = r;
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

void EngineShape::nudgeTo(Placement *p){
    if(currentPlacement==NULL)
        currentPlacement = p;
    else{
        currentPlacement->location = p->location;
        currentPlacement->patch = p->patch;
    }
    shape->getTree()->setLocation(currentPlacement->location.x,
                       currentPlacement->location.y);
}

void EngineShape::finalizePlacement(){    
    shape->getTree()->setLocation(currentPlacement->location.x, currentPlacement->location.y);
    unsigned int color= currentPlacement->patch->getLayer()->getColorer()->colorFor(currentPlacement);
    currentPlacement->color = color;
    renderedPlacement = currentPlacement;

    currentPlacement->patch->getShapes()->push_back(this);
}

Placement* EngineShape::getFinalPlacement(){
    return renderedPlacement;
}

Placement* EngineShape::getCurrentPlacement(){
    return currentPlacement;
}

vector<Placement*>* EngineShape::getDesiredPlacements(){
    return desiredPlacements;
}

void EngineShape::setDesiredPlacements(vector<Placement*>* placements){
    if(desiredPlacements!=NULL)
        delete desiredPlacements;
    desiredPlacements = placements;
}


bool EngineShape::trespassed(PolarLayer* layer){
    if(layer==NULL) return false;
//    double x = (this->currentPlacement->location.x - this->shape->getWidth() / 2);
//    double y = (this->currentPlacement->location.y - this->shape->getHeight() / 2);
    
    // float right = (float) (this.currentLocation.x + bounds
    // .getWidth());
    // float bottom = (float) (this.currentLocation.y + bounds
    // .getHeight());
    //		Assert.isTrue( this.shape.textField.width>0);
    //		Assert.isTrue( this.shape.textField.height > 0);
    
    if (layer->containsAllPolarPoints(this->currentPlacement->location.x ,
                                     this->currentPlacement->location.y, this->samplePoints, getShape()->getTree()->getRotation(),
                                     this->currentPlacement->location.x,
                                     this->currentPlacement->location.y
                                     ))
    {
        return (layer->aboveContainsAnyPolarPoints(this->currentPlacement->location.x ,
                                                  this->currentPlacement->location.y, this->samplePoints, getShape()->getTree()->getRotation(),
                                                  this->currentPlacement->location.x,
                                                  this->currentPlacement->location.y
                                                  ));
    }
    
    //		if (layer.contains(x, y, this.shape.textField.width, this.shape.textField.height, rotation, false))
    //	    {
    //			return (!layer.aboveContains(x, y, this.shape.textField.width, this.shape.textField.height, rotation, false));
    //		}
    return true;
}