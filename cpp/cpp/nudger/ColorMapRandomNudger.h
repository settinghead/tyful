//
//  ColorMapRandomNudger.h
//  cpp
//
//  Created by Xiyang Chen on 12/25/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef cpp_ColorMapRandomNudger_h
#define cpp_ColorMapRandomNudger_h

//
//  ColorMapNudger.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ColorMapRandomNudger__
#define __PolarTree_Experiment__ColorMapRandomNudger__
#include "Nudger.h"
#include "../model/structs.h"
#include "../density/Patch.h"
struct Placement;
class EngineShape;

class ColorMapRandomNudger:public Nudger{
private:
public:
    inline void nudgeFor(EngineShape* shape,Placement* origin, Placement& placement, int attempt, int totalPlannedAttempts){
        attempt = ( attempt + origin->patch->getLastAttempt() + totalPlannedAttempts / 2) % totalPlannedAttempts;
        Patch* p= origin->patch;
        double x = ((double) rand() / double(RAND_MAX) * p->getWidth() - p->getWidth()/2)*1.5;
        double y = ((double) rand() / double(RAND_MAX) * p->getHeight() - p->getHeight()/2)*1.5;
        
        placement.location.x = x;
        placement.location.y = y;
        placement.patch = origin->patch;
    }
};

#endif /* defined(__PolarTree_Experiment__ColorMapRandomNudger__) */


#endif
