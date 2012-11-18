//
//  ColorMapNudger.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ColorMapNudger__
#define __PolarTree_Experiment__ColorMapNudger__
#include "Nudger.h"
struct Placement;
class EngineShape;

class ColorMapZigzagNudger:public Nudger{
private:
public:
    Placement nudgeFor(EngineShape* shape, Placement* placement, int attemptNumber, int totalPlannedAttempts);
};

#endif /* defined(__PolarTree_Experiment__ColorMapNudger__) */
