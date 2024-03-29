//
//  Sizer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_Sizer_h
#define PolarTree_Experiment_Sizer_h

class EngineShape;

class Sizer{
public:
    inline virtual double sizeFor(EngineShape* shape, int rank, int count) = 0;
    virtual bool switchToNextSize() = 0;
    virtual double getCurrentSize() = 0;
    inline virtual void reset() = 0;
    virtual bool hasNextSize() = 0;
    virtual void shift() = 0;
};

#endif
