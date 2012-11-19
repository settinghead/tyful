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
#include "structs.h"
#include "Sizer.h"

using namespace std;

class EngineShape;
class ImageShape;
class PolarLayer;
class Placer;
class Angler;
class Patch;
class Nudger;
class DensityPatchIndex;



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
    inline int getWidth();
    inline int getHeight();
    vector<PolarLayer*>* getLayers();
    inline double getShrinkage(){
        return getSizer()->getCurrentSize();
    }
    inline Placer* getPlacer();
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
    inline Sizer* getSizer();
    inline Nudger* getNudger();
    inline EngineShape* generateEngineWord(ImageShape* shape);
    inline bool placeShape(EngineShape * shape);
    inline void computeDesiredPlacements(EngineShape* shape);
    inline Placement* tryCurrentSize(EngineShape* shape);
    inline void skipShape(EngineShape* shape, SKIP_REASON reason);
    inline int calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p);
    DensityPatchIndex* _patchIndex = NULL;
    inline DensityPatchIndex* getPatchIndex();
};



#endif
