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
#include "PolarRootTree.h"
#include "PolarLayer.h"
#include "Patch.h"

EngineShape::EngineShape(ImageShape* shape){
    this->shape = shape;
}

bool EngineShape::wasSkipped(){
    return skipReason > 0;
}

void EngineShape::skipBecause(int reason){
    this->skipReason = reason;
}

ImageShape* EngineShape::getShape(){
    return shape;
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
    desiredPlacements = placements;
}

Placement* EngineShape::nextDesiredPlacement(){
    return desiredPlacements->at(desiredPlacementIndex++);
}

bool ::EngineShape::hasNextDesiredPlacement(){
    return desiredPlacementIndex < desiredPlacements->size();
}

bool EngineShape::trespassed(PolarLayer* layer){
    if(layer==NULL) return false;
    double x = (this->currentPlacement->location.x - this->shape->getWidth() / 2);
    double y = (this->currentPlacement->location.y - this->shape->getHeight() / 2);
    
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