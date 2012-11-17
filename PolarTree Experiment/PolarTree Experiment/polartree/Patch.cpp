//
//  Patch.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "Patch.h"
#include "PolarCanvas.h"
#include "PatchQueue.h"
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"

Patch::Patch(int x, int y, int width, int height, int rank, Patch* parent, PatchQueue* queue, PolarLayer* layer){
    this->x = x; this->y = y; this->width = width; this->height = height;
    this->parent = parent;
    this->rank = rank;
    this->queue = queue;
    this->layer = layer;
}

PolarCanvas* Patch::getCanvas(){
    return queue->getMap()->getIndex()->getCanvas();
}

vector<Patch*>* Patch::divideIntoNineOrMore(PatchQueue* newQueue){
    vector<Patch*>* result = new vector<Patch*>();
    int min = width < height ? width:height;
    int squareLength = min / NUMBER_OF_DIVISIONS;
//    int centerCount = (NUMBER_OF_DIVISIONS + 1) / 2;
    
    bool breakI = false;
    for (int i= 0; i < width; i += squareLength) {
        int squareWidth;
        if (i + squareLength * 2> width) {
            squareWidth = width - i;
            // i = getWidth();
            breakI = true;
        } else
            squareWidth = squareLength;
        bool breakJ = false;
        
        for (int j= 0; j < height; j += squareLength) {
            int squareHeight;
            if (j + squareLength * 2> height) {
                squareHeight = height - j;
                // j = height;
                breakJ = true;
            } else
                squareHeight = squareLength;
            
            // the closer to the center, the higher the rank
            Patch* p = new Patch(x + i, y + j,
                                   squareWidth, squareHeight, 0, this, newQueue, this->layer);
            result->push_back(p);
            if (breakJ)
                break;
        }
        if (breakI)
            break;
    }
    
    this->children = result;
    return result;
}

double Patch::getAverageAlpha(){
    if(isnan(averageAlpha)){
        averageAlpha = getAlphaSum();
        averageAlpha /= getArea();
    }
    return averageAlpha;
}

double Patch::getAlphaSum(){
    if(isnan(alphaSum)){
        alphaSum = 1;
    }
    if(alphaSum==0){
        alphaSum = DBL_MIN;
    }
    return alphaSum;
}
