//
//  Nudger.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_Nudger_h
#define PolarTree_Experiment_Nudger_h

class EngineShape;
struct Placement;

class Nudger{
public:
    inline virtual Placement* nudgeFor(EngineShape* shape, Placement* placement, int attemptNumber, int totalPlannedAttempts) = 0;
};

#endif
