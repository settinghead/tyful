//
//  structs.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/19/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_structs_h
#define PolarTree_Experiment_structs_h
#include <stdlib.h>
class Patch;
struct CartisianPoint{
    double x = 0;
    double y = 0;
    inline CartisianPoint operator + (const CartisianPoint &o) const{
        CartisianPoint p;
        p.x = o.x + x;
        p.y = o.y + y;
        return p;
    }
};

struct PolarPoint{
    double d = 0;
    double r = 0;
};

struct Placement{
    CartisianPoint location;
    double scale = 1;
    double rotation = 0;
    Patch* patch = NULL;
    inline Placement operator + (const Placement &o) const{
        Placement p;
        p.location = o.location + location;
        p.scale = scale;
        p.rotation = rotation;
        p.patch = patch;
        return p;
    }
};

#endif
