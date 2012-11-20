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
#include "structs.h"
#include "Patch.h"
struct Placement;
class EngineShape;

class ColorMapZigzagNudger:public Nudger{
private:
public:
    inline Placement* nudgeFor(EngineShape* shape, Placement* placement, int attempt, int totalPlannedAttempts){
        attempt = ( attempt + placement->patch->getLastAttempt() + totalPlannedAttempts / 2) % totalPlannedAttempts;
        Patch* p= placement->patch;
        double unitDistance = sqrt(p->getWidth() * p->getHeight()/totalPlannedAttempts);
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
};

#endif /* defined(__PolarTree_Experiment__ColorMapNudger__) */
