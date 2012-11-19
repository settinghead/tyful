//
//  PolarCanvas.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_PolarCanvas_h
#define PolarTree_Experiment_PolarCanvas_h
#include <vector>
#include <math.h>
#include "constants.h"

using namespace std;

class EngineShape;
class ImageShape;
class PolarLayer;
class Sizer;
class Placer;
class Angler;
class Patch;
class Nudger;
class DensityPatchIndex;

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

typedef int STATUS;
typedef int SKIP_REASON;

class PolarCanvas{
public:
    PolarCanvas();
    Placement* slapShape(ImageShape* shape);
    void setPerseverance(int v);
    int getPerseverance();
    void setSizer(Sizer* sizer);
    void setPlacer(Placer* placer);
    void setAngler(Angler* placer);
    void setNudger(Nudger* placer);
    int getWidth();
    int getHeight();
    vector<PolarLayer*>* getLayers();

    Placer* getPlacer();
    void setStatus(STATUS status);
    STATUS getStatus();
private:
    vector<PolarLayer*>* layers;
    vector<EngineShape*>* shapes;
    vector<EngineShape*>* displayShapes;
    vector<EngineShape*>* retryShapes;
    int failureCount = 0;
    int numRetries = 0;
    int totalAttempted = 0;
    int perseverance = 10, diligence = 8;
    double width = NAN, height= NAN;
    STATUS status = PAUSED;
    Sizer* _sizer = NULL;
    Nudger* _nudger = NULL;
    Placer* _placer = NULL;
    Sizer* getSizer();
    Nudger* getNudger();
    EngineShape* generateEngineWord(ImageShape* shape);
    bool placeShape(EngineShape * shape);
    void computeDesiredPlacements(EngineShape* shape);
    Placement* tryCurrentSize(EngineShape* shape);
    void skipShape(EngineShape* shape, SKIP_REASON reason);
    int calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p);
    DensityPatchIndex* _patchIndex = NULL;
    DensityPatchIndex* getPatchIndex();
};



#endif
