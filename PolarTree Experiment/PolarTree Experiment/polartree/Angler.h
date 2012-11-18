//
//  Angler.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__Angler__
#define __PolarTree_Experiment__Angler__

class EngineShape;

class Angler{
public:
    virtual double angleFor(EngineShape* shape) = 0;
};

#endif /* defined(__PolarTree_Experiment__Angler__) */
