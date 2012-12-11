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
#if NUM_THREADS > 1
#include "../threads/threadpool.h"
#endif
#include <vector>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <semaphore.h>
#include <tr1/unordered_map>
#include <queue>
#include "../ThreadControllers.h"

using namespace std;

class EngineShape;
class ImageShape;
class PolarLayer;
class Placer;
class Angler;
class Patch;
class Nudger;
class DensityPatchIndex;
class ThreadControllers;


typedef int STATUS;
typedef int SKIP_REASON;


class PolarCanvas:public vector<PolarLayer*>{
public:
    PolarCanvas();
    ~PolarCanvas();
    
    inline unsigned int getId(){
        return _id;
    }
    
    static PolarCanvas* current;
    static PolarCanvas* pending;
    static ThreadControllers threadControllers;
    vector<EngineShape*>* _shapes;

    
    void feedShape(ImageShape* shape,unsigned int sid);
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
    float getWidth();
    float getHeight();
    inline int getFailureCount(){
        return this->failureCount;
    }
    inline double getShrinkage(){
        return getSizer()->getCurrentSize();
    }
    inline Placer* getPlacer();
    void setStatus(STATUS status);
    STATUS getStatus();
    
    void addLayer (PolarLayer* val);

    queue<SlapInfo*>* slaps;
    queue<EngineShape*>* pendingShapes;
    vector<EngineShape*>* displayShapes;
    vector<EngineShape*>* retryShapes;
    vector<EngineShape*>* fixedShapes;
    void tryNextEngineShape();
    void resetFixedShapes();
    void fixShape(int sid, int x, int y, double rotation);
    double getSuccessRate();
    void registerShape(EngineShape* shape);

private:
    
 
    int failureCount;
    int numRetries;
    int totalAttempted;
    int perseverance, diligence;
    float width, height;
    tr1::unordered_map<int, EngineShape*> _shapeMap;

    STATUS _status;
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
    inline EngineShape* generateEngineWord(ImageShape* shape, unsigned int sid);
    inline bool placeShape(EngineShape* shape);
    inline void computeDesiredPlacements(EngineShape* shape);
    inline void skipShape(EngineShape* shape, SKIP_REASON reason);
    inline int calculateMaxAttemptsFromShapeSize(EngineShape* shape, Patch* p, double shrinkage);
    DensityPatchIndex* _patchIndex;
    inline DensityPatchIndex* getPatchIndex();
    Placement* _candidatePlacement;
    EngineShape* _shapeToWorkOn;
    EngineShape* _lastCollidedWith;
    int _attempt;
    int _maxAttemptsToPlace;
    pthread_mutex_t shape_mutex;
    pthread_mutex_t attempt_mutex;
    pthread_mutex_t numActiveThreads_mutex;
    pthread_cond_t count_threshold_cv;
    pthread_mutex_t count_threshold_mutex;
    pthread_cond_t status_cv;
    pthread_mutex_t status_mutex;
    

    pthread_attr_t attr;
//    pthread_t threads[NUM_THREADS];

    static void attempt_nudge(void *arg);
    bool _signoffSheet[NUM_THREADS];
    void connectLayers();
    
    unsigned int _id;
#if NUM_THREADS > 1
	struct threadpool *pool;
#endif
};



#endif
