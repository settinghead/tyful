//
//  ByWeightSizer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ByWeightSizer.h"
#include <math.h>
ByWeightSizer::ByWeightSizer(int minSize, int maxSize){
    this->minSize = minSize;
    this->maxSize = maxSize;
    reset();
}
double ByWeightSizer::sizeFor(EngineShape* shape, int rank, int count){
    
    //TODO: revise logic
    return maxSize	- pow(sqrt((maxSize-minSize))*rank/count,2);
 
}
bool ByWeightSizer::switchToNextSize(){
    if(currentSize>minSize){
        currentSize-= decr;
        if(currentSize<minSize)
            currentSize = minSize;
        return true;
    }
    else
        return false;
    
}
double ByWeightSizer::getCurrentSize(){
    return currentSize;
}
void ByWeightSizer::reset(){
    currentSize = maxSize;
    decr = (maxSize-minSize)/20;
    if(decr<1) decr=1;
}
bool ByWeightSizer::hasNextSize(){
    return currentSize > minSize;

}