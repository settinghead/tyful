//
//  DensityPatchIndex.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "DensityPatchIndex.h"
#include "PolarCanvas.h"
#include "LeveledPatchMap.h"
#include "Patch.h"
#include <assert.h>

DensityPatchIndex::DensityPatchIndex(PolarCanvas* canvas){
    this -> canvas = canvas;
    this -> map = new LeveledPatchMap(this);
}

vector<Patch*>* DensityPatchIndex::findPatchFor(int width, int height){
    vector<Patch*>* result = new vector<Patch*>();
    int level = findGranularityLevel(width,height);
    double area = width*height;
    
    for(int i=0;i<NUMBER_OF_ATTEMPTED_PATCHES; i++){
        Patch* p = getBestPatchAtLevel(level);
        if(p!=NULL) result->push_back(p);
    }
    assert(result->size()>0);
    return result;
}


Patch* DensityPatchIndex::getBestPatchAtLevel(int level) {
    Patch* result= map->getBestPatchAtLevel(level);
    //			if (result == null)
    //				return getBestPatchAtLevel(level - 1);
    //			else
    return result;
}

int DensityPatchIndex::findGranularityLevel(int width, int height) {
    int max = width > height ? width : height;
    max *= 2;
    int minContainerLength = canvas->getWidth() > canvas->getHeight() ? canvas->getWidth(): canvas->getHeight();
    int squareWidth = minContainerLength;
    int level = 0;
    
    while (squareWidth > max) {
        squareWidth /= NUMBER_OF_DIVISIONS;
        level++;
    }
    
    level -= 1;
    if(level<0) level = 0;
        return level;
}


PolarCanvas* DensityPatchIndex::getCanvas(){
    return canvas;
}