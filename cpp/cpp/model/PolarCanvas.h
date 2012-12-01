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
#include "../constants.h"
#include "structs.h"
#include "../sizer/Sizer.h"
#include "../sizer/ByWeightSizer.h"
#include "../threads/threadpool.h"
#include <pthread.h>
#include <semaphore.h>

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
    ~PolarCanvas();
    Placement* slapShape(ImageShape* shape);
    void setPerseverance(int v){
        this->perseverance = v;
    }
    
    int getPerseverance(){
        return this->perseverance;
    }
    void setSizer(Sizer* sizer);
    void setPlacer(Placer* placer);
    void setAngler(Angler* placer);
    void setNudger(Nudger* placer);
    inline int getWidth();
    inline int getHeight();
    inline int getFailureCount(){
        return this->failureCount;
    }
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
    int failureCount;
    int numRetries;
    int totalAttempted;
    int perseverance, diligence;
    double width, height;
    STATUS status;
    Sizer* _sizer;
    Nudger* _nudger;
    Placer* _placer;
    inline Sizer* getSizer(){
        if(this->_sizer==NULL){
            //        int max = width>height?width:height;
            //        int min = max/100;
            //        if(min<7) min = 7;
            _sizer = new ByWeightSizer(0,1);
            
        }
        return _sizer;
    }
    inline Nudger* getNudger();
    inline EngineShape* generateEngineWord(ImageShape* shape);
    inline bool placeShape(EngineShape* shape);
    inline void computeDesiredPlacements(EngineShape* shape);
    inline Placement* tryCurrentSize(EngineShape* shape);
    inline void skipShape(EngineShape* shape, SKIP_REASON reason);
    inline int calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p);
    DensityPatchIndex* _patchIndex;
    inline DensityPatchIndex* getPatchIndex();
    Placement* _candidatePlacement;
    EngineShape* _shapeToWorkOn;
    EngineShape* _lastCollidedWith;
    bool _found;
    int _winningSeq;
    int _attempt;
    int _maxAttemptsToPlace;
    pthread_mutex_t shape_mutex;
    pthread_mutex_t attempt_mutex;
    pthread_mutex_t numActiveThreads_mutex;
    pthread_attr_t attr;
//    pthread_t threads[NUM_THREADS];

    static void attempt_nudge(void *arg);
    int _numActiveThreads;
    void connectLayers();

    
	struct threadpool *pool;
    pthread_cond_t count_threshold_cv;
};



#endif
