//
//  EngineShape.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_EngineShape_h
#define PolarTree_Experiment_EngineShape_h

#include <vector>
#include "../constants.h"
#include "../model/structs.h"
#include "../model/TextImageShape.h"
using namespace std;

class PolarLayer;
class Angler;

class EngineShape: public TextImageShape{
public:
    EngineShape( int sid, unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb);
    EngineShape(int sid, unsigned char * png, size_t size);
    ~EngineShape();
    bool wasSkipped();
    void skipBecause(int reason);
    inline bool hasNextDesiredPlacement(){
        return desiredPlacementIndex < desiredPlacements->size();
    }
    inline Placement* nextDesiredPlacement(){
        return desiredPlacements->at(desiredPlacementIndex++);
    }
    void nudgeTo(int seq,Placement* place,Angler* angler);
//    Placement* getOrCreateFinalPlacement();
    bool trespassed(int seq,PolarLayer* layer);
    vector<Placement*>* getDesiredPlacements();
    void setDesiredPlacements(vector<Placement*>*);
    inline unsigned int getUid(){
        return uid;
    }
    bool _found;
    int referenceCounter;
    void finalizePlacement(int final_seq, int canvasId, int failureCount);
private:
    void init();
    int skipReason;
    int uid;
    vector<PolarPoint>* samplePoints;
    vector<Placement*>* desiredPlacements;
    int desiredPlacementIndex;
    void drawSamples();
};

#endif
