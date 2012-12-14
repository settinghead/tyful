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
    ~Angler(){}
    virtual double angleFor(int seq,EngineShape* shape, double prevAngle) = 0;
    virtual inline bool alternativeValid(double angle){
        return false;
    }
};

#endif /* defined(__PolarTree_Experiment__Angler__) */
