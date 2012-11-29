//
//  Patch.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "Patch.h"
#include "PatchQueue.h"
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"
#include "../model/EngineShape.h"
#include "../model/WordLayer.h"
#include "../model/PolarCanvas.h"


Patch::Patch(double x, double y, double width, double height, int rank, Patch* parent, PatchQueue* queue, WordLayer* layer):averageAlpha(NAN),alphaSum(NAN),area(NAN),children(NULL),numberOfFailures(0),lastAttempt(0){
    this->x = x; this->y = y; this->width = width; this->height = height;
    this->parent = parent;
    this->rank = rank;
    this->queue = queue;
    this->layer = layer;
    this->shapes = new vector<EngineShape*>();
}

PolarCanvas* Patch::getCanvas(){
    return queue->getMap()->getIndex()->getCanvas();
}


double Patch::getAverageAlpha(){
    if(isnan(averageAlpha)){
        averageAlpha = getAlphaSum();
        averageAlpha /= getArea();
    }
    return averageAlpha;
}

double Patch::getArea() {
    if (isnan(area))
        area = width * height;
        return area;
}


int Patch::getLevel(){
    return queue->getLevel();
}

