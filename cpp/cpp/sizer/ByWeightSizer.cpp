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

ByWeightSizer::ByWeightSizer(int minSize, int maxSize){
    this->minSize = minSize;
    this->maxSize = maxSize;
    reset();
}
inline double ByWeightSizer::sizeFor(EngineShape* shape, int rank, int count){
    
    //TODO: revise logic
    return maxSize	- pow(sqrt((maxSize-minSize))*rank/count,2);
 
}
inline bool ByWeightSizer::switchToNextSize(){
    if(currentSize>minSize){
        currentSize-= decr;
        if(currentSize<minSize)
            currentSize = minSize;
        return true;
    }
    else
        return false;
    
}
inline double ByWeightSizer::getCurrentSize(){
    return currentSize;
}
inline void ByWeightSizer::reset(){
    currentSize = maxSize;
    decr = (maxSize-minSize)/NUMBER_OF_SIZE_REDUCTION_STEPS;
}
inline bool ByWeightSizer::hasNextSize(){
    return currentSize > minSize;

}