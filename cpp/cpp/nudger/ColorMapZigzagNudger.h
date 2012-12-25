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
    inline void nudgeFor(EngineShape* shape, Placement* origin,Placement& placement, int attempt, int totalPlannedAttempts){
        attempt = ( attempt + origin->patch->getLastAttempt() + totalPlannedAttempts / 2) % totalPlannedAttempts;
        Patch* p= origin->patch;
        double unitDistance = sqrt(p->getWidth() * p->getHeight()/totalPlannedAttempts);
//        double x = ((attempt / (p->getHeight() / unitDistance)) * unitDistance - p->getWidth() / 2);
//        double y = ((attempt % (int)(p->getHeight() / unitDistance)) * unitDistance - p->getHeight() / 2);
        double x = ((attempt / (p->getHeight() / unitDistance)) * unitDistance);
        double y = ((attempt % (int)(p->getHeight() / unitDistance)) * unitDistance);
        x *= 0.75;
        y *= .75;

//        x *= 1.7;
//        y *= 1.7;
        if(attempt % 2==0)
        {
            y = - y;
//            y = p->getHeight() - y;

        }
        if(attempt/2%2==0){
            x = - x;
//            x = p->getWidth() - x;
        }
        
        placement.location.x = x;
        placement.location.y = y;
        placement.patch = origin->patch;
    }
};

#endif /* defined(__PolarTree_Experiment__ColorMapNudger__) */
