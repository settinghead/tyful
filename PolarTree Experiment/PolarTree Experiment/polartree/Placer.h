//
//  Placer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_Placer_h
#define PolarTree_Experiment_Placer_h
#include <vector>

struct Placement;
class EngineShape;

class Placer{
public:
    virtual vector<Placement*>* place(EngineShape* shape, unsigned long totalCount);
    virtual void success() = 0;
    virtual void fail() = 0;
    virtual void success(vector<Placement*>*) = 0;
    virtual void fail(vector<Placement*>*) = 0;
};

#endif
