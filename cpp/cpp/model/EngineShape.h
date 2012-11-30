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
using namespace std;

struct Placement;
class ImageShape;
class PolarLayer;
struct PolarPoint;
class Angler;

class EngineShape{
public:
    EngineShape(ImageShape* shape);
    bool wasSkipped();
    void skipBecause(int reason);
    inline bool hasNextDesiredPlacement(){
        return desiredPlacementIndex < desiredPlacements->size();
    }
    inline Placement* nextDesiredPlacement(){
        return desiredPlacements->at(desiredPlacementIndex++);
    }
    inline ImageShape* getShape(){
        return shape;
    }
    void nudgeTo(int seq,Placement* place,Angler* angler);
    void finalizePlacement(int finalSeq);
    Placement* getFinalPlacement();
    bool trespassed(int seq,PolarLayer* layer);
    Placement* getCurrentPlacement(int seq);
    vector<Placement*>* getDesiredPlacements();
    void setDesiredPlacements(vector<Placement*>*);

private:
    int skipReason;
    ImageShape* shape;
    Placement* currentPlacement[NUM_THREADS];
    Placement* renderedPlacement;
    vector<PolarPoint>* samplePoints;
    vector<Placement*>* desiredPlacements;
    int desiredPlacementIndex;
    void drawSamples();
};

#endif
