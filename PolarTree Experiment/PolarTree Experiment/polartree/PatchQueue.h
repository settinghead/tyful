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
#include <unordered_map>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <functional>
#include "Patch.h"

#define QUEUE_ALPHA_THRESHOLD -DBL_MAX

using namespace std;

class LeveledPatchMap;
typedef std::unordered_map<string, Patch*> LookupMap;
struct ComparePatch;

class PatchQueue:priority_queue<Patch*, vector<Patch*>, ComparePatch>{
public:
    PatchQueue(int myLevel, LeveledPatchMap* map);
    void push(const value_type &__v);
    Patch* popBestPatch();
    PatchQueue* descend(int level);
    LeveledPatchMap* getMap();
    unsigned long size();
    int getLevel();
    void tryPush(Patch* patch);
    void tryPushAll(vector<Patch*>* patches);
    
private:
    int myLevel;
    LeveledPatchMap* map;
//    LookupMap* lookupMap;
};

#endif
