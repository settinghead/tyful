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
    double x;
    double y;
    inline CartisianPoint operator + (const CartisianPoint &o) const{
        CartisianPoint p;
        p.x = o.x + x;
        p.y = o.y + y;
        return p;
    }
};

struct PolarPoint{
    double d;
    double r;
};

struct Placement{
    CartisianPoint location;
    double scale;
    double rotation;
    unsigned int color;
    Patch* patch;
    inline Placement operator + (const Placement &o) const{
        Placement p;
        p.location = o.location + location;
        p.scale = scale;
        p.rotation = rotation;
        p.patch = patch;
        p.color = color;
        return p;
    }
};

#endif
