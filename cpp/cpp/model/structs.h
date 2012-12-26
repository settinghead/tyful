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
    CorePlacement():location(CartisianPoint(NAN,NAN)),rotation(NAN),layer(-1){}
    CorePlacement(CartisianPoint location,double rotation, int layer):
    rotation(rotation),layer(layer),location(location){}
    CartisianPoint location;
    double rotation;
    unsigned int layer;
};

struct Placement:CorePlacement{
    Placement():CorePlacement(),patch(NULL){}
    Placement(CartisianPoint location,double rotation, unsigned int layer, Patch* patch):
    CorePlacement(location,rotation,layer),patch(patch){}
    ~Placement(){
    }
    Patch* patch;
    inline Placement operator + (const Placement &o) const{
        ;
        return Placement(o.location+location,rotation,layer,patch);
    }
};

struct SlapInfo:CorePlacement{
    int failureCount;
    int canvasId;
    int sid;
    SlapInfo():CorePlacement(),sid(-1){};
    SlapInfo(int sid, int canvasId, CartisianPoint location,double rotation, int layer, unsigned int color, unsigned int failureCount):
    CorePlacement(location,rotation,layer),sid(sid),canvasId(canvasId),failureCount(failureCount),color(color){}
    unsigned int color;
    bool isEmpty(){return sid<0;}

};

#endif
