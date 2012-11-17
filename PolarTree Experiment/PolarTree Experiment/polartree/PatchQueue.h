//
//  PatchQueue.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_PatchQueue_h
#define PolarTree_Experiment_PatchQueue_h
#include <queue>
#include <cstdlib>
#include <cstring>
#include <unordered_map>

using namespace std;

class Patch;
class LeveledPatchMap;

class PatchQueue:priority_queue<Patch*>{
public:
    PatchQueue(int myLevel, LeveledPatchMap* map);
    void push(const value_type &__v);
    Patch* popBestPatch();
    PatchQueue* descend(int level);
    LeveledPatchMap* getMap();
    unsigned long size();
private:
    int myLevel;
    LeveledPatchMap* map;
    unordered_map<string, Patch*>* lookupMap;
    void tryPush(Patch* patch);
};

#endif
