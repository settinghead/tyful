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
#include "../model/structs.h"
#include "../density/Patch.h"
struct Placement;
class EngineShape;

class ColorMapZigzagNudger:public Nudger{
private:
public:
    inline Placement* nudgeFor(EngineShape* shape, Placement* placement, int attempt, int totalPlannedAttempts){
        attempt = ( attempt + placement->patch->getLastAttempt() + totalPlannedAttempts / 2) % totalPlannedAttempts;
        Patch* p= placement->patch;
        double unitDistance = sqrt(p->getWidth() * p->getHeight()/totalPlannedAttempts);
        double x = ((attempt / ((p->getHeight()) / unitDistance)) * unitDistance)/2;
        double y = ((attempt % (int)((p->getHeight()) / unitDistance)) * unitDistance)/2;
        x *= 1.7;
        y *= 1.7;
        if(attempt % 2==0)
        {
            y = - y;
        }
        if(attempt/2%2==0){
            x = - x;
        }
        
        Placement* retPoint = (Placement*)malloc(sizeof(Placement));
        retPoint->location.x = placement->location.x+x;
        retPoint->location.y = placement->location.y+y;
        retPoint->patch = placement->patch;
        return retPoint;
    }
};

#endif /* defined(__PolarTree_Experiment__ColorMapNudger__) */
