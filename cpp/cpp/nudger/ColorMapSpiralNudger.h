//
//  ColorMapSpiralWordNudger.h
//  cpp
//
//  Created by Xiyang Chen on 12/14/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef cpp_ColorMapSpiralWordNudger_h
#define cpp_ColorMapSpiralWordNudger_h

#include "Nudger.h"
#include "../model/structs.h"
#include "../density/Patch.h"
#include "../fasttrig.h"
struct Placement;
class EngineShape;

class ColorMapSpiralNudger:public Nudger{
private:
    inline static double powerMap(double power, double v, double min1, double max1,
                           double min2, double max2) {
		double val= norm(v, min1, max1);
		val = pow(val, power);
		return lerp(min2, max2, val);
	}
public:
    inline Placement* nudgeFor(EngineShape* shape, Placement* placement, int attempt, int totalPlannedAttempts){
        attempt = ( attempt + placement->patch->getLastAttempt() + totalPlannedAttempts) % totalPlannedAttempts;
        Patch* p= placement->patch;
        
        Placement* retPoint = (Placement*)malloc(sizeof(Placement));
        
        
        
        attempt = ( attempt + p->getLastAttempt() ) % totalPlannedAttempts;
        
        double factor = p->getWidth() < p->getHeight() ? p->getWidth() : p
        ->getHeight();
        factor/=3.6;
        //			if (p.getLevel() == 0)
        //				factor /= 6;
        //			else if (p.getLevel() == 1)
        //				factor /= 2;
        //		} else
        //			factor = 30;
        
        //		factor *= 6;
        
		double rad= powerMap(0.6, attempt, 0, totalPlannedAttempts, 1, factor);
        
        //		var thetaIncrement = powerMap(1, attempt, 0, totalPlannedAttempt, 0.5, 0.3);
        //		var theta:Number= thetaIncrement * attempt;
		double theta = (double) rand() / double(RAND_MAX) * TWO_PI;
        CartisianPoint location(cos(theta) * rad,sin(theta) * rad);
        
        retPoint->location = location;
        retPoint->patch = placement->patch;
        return retPoint;
    }
    

    
    
};


#endif
