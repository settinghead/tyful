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

#define RENDERING 1
#define PAUSED 0
#define MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE 2
#define MAX_ATTEMPTS_TO_PLACE -1
#define SKIP_REASON_NO_SPACE 1

using namespace std;

class EngineShape;
class PolarLayer;
class Sizer;
class Placer;
class Angler;
class Patch;
class Nudger;

struct Point{
    double x;
    double y;
    inline Point operator + (const Point &o) const{
        Point p;
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
    Point location;
    double scale;
    double rotation;
    Patch* patch;
    inline Placement operator + (const Placement &o) const{
        Placement p;
        p.location = o.location + location;
        p.scale = scale;
        p.rotation = rotation;
        p.patch = patch;
        return p;
    }
};

class PolarCanvas{
public:
    PolarCanvas();
    Placement* slapShape(EngineShape* shape);
    void setPerseverance(int v);
    int getPerseverance();
    void setSizer(Sizer* sizer);
    void setPlacer(Placer* placer);
    void setAngler(Angler* placer);
    void setNudger(Nudger* placer);
    int getWidth();
    int getHeight();
    vector<PolarLayer*>* getLayers();
    typedef int SKIP_REASON;
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
    typedef int STATUS;
    STATUS status = PAUSED;
    Sizer* sizer;
    Angler* angler;
    Nudger* nudger;
    Placer* placer;
    bool placeShape(EngineShape * shape);
    void computeDesiredPlacements(EngineShape* shape);
    Placement* tryCurrentSize(EngineShape* shape);
    void skipShape(EngineShape* shape, SKIP_REASON reason);
    int calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p);

};

#endif
