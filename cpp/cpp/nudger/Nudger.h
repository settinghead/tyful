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
    virtual ~Nudger(){}
    inline virtual Placement* nudgeFor(EngineShape* shape, Placement* placement, int attemptNumber, int totalPlannedAttempts) = 0;
protected:
    inline static double lerp(double start, double stop, double amt){
        return start + (stop - start) * amt;
    }
    
    static double norm(double value, double start, double stop){
        return (value - start) / (stop - start);
    }
    
    static double map(double value, double istart, double istop, double ostart, double ostop) {
        return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
    }
};

#endif
