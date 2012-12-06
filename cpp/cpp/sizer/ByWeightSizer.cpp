//
//  ByWeightSizer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ByWeightSizer.h"
#include <math.h>
#include "../constants.h"

ByWeightSizer::ByWeightSizer(int minSize, int maxSize):minSize(minSize),maxSize(maxSize),currentShift(0),sizeChanged(false){
    reset();
}
inline double ByWeightSizer::sizeFor(EngineShape* shape, int rank, int count){
    
    //TODO: revise logic
    return maxSize	- pow(sqrt((maxSize-minSize))*rank/count,2);
 
}
inline bool ByWeightSizer::switchToNextSize(){
    sizeChanged = true;
    if(currentSizes[currentShift]>minSize){
        currentSizes[currentShift]-= decr;
        if(currentSizes[currentShift]<minSize)
            currentSizes[currentShift] = minSize;
        return true;
    }
    else
        return false;
    
}
inline double ByWeightSizer::getCurrentSize(){
    return currentSizes[currentShift];
}
inline void ByWeightSizer::reset(){
    for(int i=0;i<MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;i++)
        currentSizes[i] = maxSize;
    decr = (maxSize-minSize)/NUMBER_OF_SIZE_REDUCTION_STEPS;
    sizeChanged = false;
}
inline bool ByWeightSizer::hasNextSize(){
    return currentSizes[currentShift] > minSize;
}
void ByWeightSizer::shift(){
    if(sizeChanged)
        currentShift++;
    if(currentShift==MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE){
        double max = minSize;
        for(int i=0;i<MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;i++)
            if(currentSizes[i]>max) max=currentSizes[i];
        for(int i=0;i<MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;i++)
            currentSizes[i]=max;
        currentShift=0;
        sizeChanged = false;
    }
}
