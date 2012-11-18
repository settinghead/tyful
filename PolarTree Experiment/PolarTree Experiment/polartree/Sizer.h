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
    virtual double sizeFor(EngineShape* shape) = 0;
    virtual double switchToNextSize() = 0;
    virtual double currentSize() = 0;
    virtual void reset() = 0;
    virtual bool hasNextSize() = 0;
};

#endif
