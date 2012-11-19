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

using namespace std;

struct Placement;
class ImageShape;
class PolarLayer;
struct PolarPoint;

class EngineShape{
public:
    EngineShape(ImageShape* shape);
    bool wasSkipped();
    void skipBecause(int reason);
    bool hasNextDesiredPlacement();
    Placement* nextDesiredPlacement();
    ImageShape* getShape();
    void nudgeTo(Placement* place);
    void finalizePlacement();
    Placement* getFinalPlacement();
    bool trespassed(PolarLayer* layer);
    Placement* getCurrentPlacement();
    vector<Placement*>* getDesiredPlacements();
    void setDesiredPlacements(vector<Placement*>*);

private:
    int skipReason = 0;
    ImageShape* shape;
    Placement* currentPlacement = NULL;
    Placement* renderedPlacement = NULL;
    vector<PolarPoint>* samplePoints;
    vector<Placement*>* desiredPlacements = NULL;
    int desiredPlacementIndex = 0;
    void drawSamples();
};

#endif
