//
//  LeveledPatchMap.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__LeveledPatchMap__
#define __PolarTree_Experiment__LeveledPatchMap__
#include <vector>
using namespace std;

class PatchQueue;
class DensityPatchIndex;
class Patch;

class LeveledPatchMap{
public:
    LeveledPatchMap(DensityPatchIndex* index);
    Patch* getBestPatchAtLevel(int level);
    DensityPatchIndex* getIndex();
    void add(Patch* p);
private:
    vector<PatchQueue*>* map;
    DensityPatchIndex* index;
    PatchQueue* getQueue(int level);
    void generateLevelQueue(int level);

};

#endif /* defined(__PolarTree_Experiment__LeveledPatchMap__) */
