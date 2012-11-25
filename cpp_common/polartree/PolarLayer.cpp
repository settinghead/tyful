//
//  PolarLayer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PolarLayer.h"
#include "PixelImageShape.h"
#include "PolarCanvas.h"
#include <math.h>

PolarLayer::PolarLayer(unsigned int const * pixels, int width, int height, bool revert)
:PixelImageShape::PixelImageShape(pixels,width,height,revert), type(WORD_LAYER),above(NULL),below(NULL){
}

bool PolarLayer::containsAllPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX,double refY){
    for(int i = 0 ;i<points->size();i++){
        double theta = points->at(i).r;
        double d = points->at(i).d;
        theta -= rotation;
        double x = centerX + cos(theta) * d;
        double y = centerY + sin(theta) * d;
        
        if(!containsPoint(x,y, refX,refY)) return false;
    }
    return true;
}

bool PolarLayer::containsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX, double refY){
    for(int i=0;i<points->size();i++){
        double theta = points->at(i).r;
        double d = points->at(i).d;
        theta -= rotation;
        double x = centerX + cos(theta) * d;
        double y = centerY + sin(theta) * d;
        
        if(containsPoint(x,y,refX,refY)) return true;
    }
    return false;
}

bool PolarLayer::aboveContains(double x, double y, double width, double height,double rotation) {
    if(above!=NULL){
        if(above->contains(x,y,width,height, rotation)) return true;
        else return above->aboveContains(x,y,width,height,rotation);
			}
    else return false;
}

bool PolarLayer::aboveContainsPoint(double x, double y, double refX, double refY) {
    if(above!=NULL){
        if(above->containsPoint(x,y, refX, refY)) return true;
        else return above->aboveContainsPoint(x,y,refX, refY);
			}
    else return false;
}

bool PolarLayer::aboveContainsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX,double refY){
    if(above!=NULL){
        if(above->containsAnyPolarPoints(centerX,centerY,points, rotation,refX,refY)) return true;
        else return above->aboveContainsAnyPolarPoints(centerX,centerY, points, rotation, refX,refY);
			}
    else return false;
}