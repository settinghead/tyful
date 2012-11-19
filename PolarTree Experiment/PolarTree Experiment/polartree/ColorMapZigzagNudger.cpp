//
//  ColorMapNudger.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ColorMapZigzagNudger.h"
#include "PolarCanvas.h"
#include "EngineShape.h"
#include "Patch.h"

Placement* ColorMapZigzagNudger::nudgeFor(EngineShape* shape, Placement* placement, int attempt, int totalPlannedAttempt){
    attempt = ( attempt + placement->patch->getLastAttempt() + totalPlannedAttempt / 2) % totalPlannedAttempt;
    Patch* p= placement->patch;
    double unitDistance = sqrt(p->getWidth() * p->getHeight()/totalPlannedAttempt);
    double x = ((attempt / (p->getHeight() / unitDistance)) * unitDistance - p->getWidth() / 2);
    double y = ((attempt % (int)(p->getHeight() / unitDistance)) * unitDistance - p->getHeight() / 2);
    x *= 1.5;
    y *= 1.5;
    if(attempt % 2==0)
    {
        y = p->getHeight() - y;
    }
    if(attempt/2%2==0){
        x = p->getWidth() - x;
    }
    
    Placement* retPoint = (Placement*)malloc(sizeof(Placement));
    retPoint->location.x = x;
    retPoint->location.y = y;
    retPoint->patch = placement->patch;
    return retPoint;
}
