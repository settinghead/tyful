//
//  DensityPatchIndex.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__DensityPatchIndex__
#define __PolarTree_Experiment__DensityPatchIndex__
#define NUMBER_OF_ATTEMPTED_PATCHES 5
#include <vector>

using namespace std;

class PolarCanvas;
class LeveledPatchMap;
class Patch;

class DensityPatchIndex{
public:
    DensityPatchIndex(PolarCanvas* canvas);
    PolarCanvas* getCanvas();
    vector<Patch*>* findPatchFor(int width, int height);
private:
    PolarCanvas* canvas;
    LeveledPatchMap* map;
    Patch* getBestPatchAtLevel(int level);
    int findGranularityLevel(int width, int height);

};

#endif /* defined(__PolarTree_Experiment__DensityPatchIndex__) */
