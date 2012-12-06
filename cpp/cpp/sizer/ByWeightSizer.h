//
//  ByWeightSizer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ByWeightSizer__
#define __PolarTree_Experiment__ByWeightSizer__
#include "Sizer.h"
#include "../constants.h"

class EngineShape;
class ByWeightSizer:public Sizer{
private:
    double minSize, maxSize;
    double currentSizes[MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE];
    double decr;
    int currentShift;
    bool sizeChanged;
public:
    ByWeightSizer(int minSize, int maxSize);
    inline double sizeFor(EngineShape* shape, int rank, int count) ;
    inline bool switchToNextSize();
    inline double getCurrentSize();
    inline void reset();
    inline bool hasNextSize();
    inline void shift();
    
};
#endif /* defined(__PolarTree_Experiment__ByWeightSizer__) */
