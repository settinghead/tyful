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
#include <math.h>
class Patch;

//WARNING: DO NOT CHANGE ORDER OR TYPE OF THESE STRUCTS

struct Dimension{
    unsigned int width;
    unsigned int height;
};

struct CartisianPoint{
    CartisianPoint(double x, double y):x(x),y(y){}
    double x;
    double y;
    inline CartisianPoint operator + (const CartisianPoint &o) const{
        return CartisianPoint(o.x + x, o.y + y);
    }
};


struct PolarPoint{
    PolarPoint(double d,double r):d(d),r(r){}
    double d;
    double r;
};

struct CorePlacement{
    CorePlacement(int sid):sid(sid),location(CartisianPoint(NAN,NAN)),rotation(NAN),layer(-1),color(0){}
    CorePlacement(int sid, CartisianPoint location,double rotation, int layer, unsigned int color):
    sid(sid),rotation(rotation),layer(layer),color(color),location(location){}
    unsigned int sid;
    CartisianPoint location;
    double rotation;
    unsigned int layer;
    unsigned int color;
};

struct Placement:CorePlacement{
    Placement(int sid):CorePlacement(sid),patch(NULL){}
    Placement(int sid, CartisianPoint location,double rotation, unsigned int layer, unsigned int color, Patch* patch):
    CorePlacement(sid,location,rotation,layer,color),patch(patch){}
    ~Placement(){
    }
    Patch* patch;
    inline Placement operator + (const Placement &o) const{
        ;
        return Placement(sid,o.location+location,rotation,layer,color,patch);
    }
};

struct SlapInfo:CorePlacement{
    int failureCount;
    int canvasId;
    SlapInfo(int sid, int canvasId, CartisianPoint location,double rotation, int layer, unsigned int color, unsigned int failureCount):
    CorePlacement(sid,location,rotation,layer,color),canvasId(canvasId),failureCount(failureCount){}
};

#endif
