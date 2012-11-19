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
#include "EngineShape.h"

Patch::Patch(double x, double y, double width, double height, int rank, Patch* parent, PatchQueue* queue, WordLayer* layer){
    this->x = x; this->y = y; this->width = width; this->height = height;
    this->parent = parent;
    this->rank = rank;
    this->queue = queue;
    this->layer = layer;
    this->shapes = new vector<EngineShape*>();
}

const int Patch::getNumberOfFailures(){
    return numberOfFailures;
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
        alphaSum = NAN;
    }
    return alphaSum;
}

double Patch::getArea() {
    if (isnan(area))
        area = width * height;
        return area;
}

double Patch::getWidth(){
    return width;
}

double Patch::getHeight(){
    return height;
}

double Patch::getX(){
    return x;
}

double Patch::getY(){
    return y;
}

WordLayer* Patch::getLayer(){
    return layer;
}

vector<EngineShape*>* Patch::getShapes(){
    return shapes;
}

void Patch::setLastAttempt(int attempt){
    lastAttempt = attempt;
}

int Patch::getLastAttempt(){
    return lastAttempt;
}

void Patch::fail(){
    numberOfFailures++;
}

int Patch::getLevel(){
    return queue->getLevel();
}

void Patch::mark(int smearedArea, bool spreadSmearToChildren) {
    //			this.resetWorthCalculations();
    //			this.getAlphaSum();
    this->alphaSum -= smearedArea * MARK_FILL_FACTOR;
    if(spreadSmearToChildren)
        for (vector<Patch*>::iterator it = children->begin();
             it != children->end(); ++it){
            Patch* child = (*it);
            child->mark(smearedArea * MARK_FILL_FACTOR/children->size(), true);
            //				child._alphaSum -= smearedArea * DensityPatchIndex.MARK_FILL_FACTOR/this.getChildren().length;
            //				child._queue.remove(child);
            //				child._queue.tryAdd(child);
        }
            //			if (getParent() != null)
            //				getParent().markChild(this);
			if (parent != NULL){
				parent->mark(smearedArea, false);
                //				parent._queue.remove(parent);
                //				parent._queue.tryAdd(parent);
			}
}
