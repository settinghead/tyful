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

#define QUEUE_ALPHA_THRESHOLD -DBL_MAX

using namespace std;

class Patch;
class LeveledPatchMap;
typedef std::unordered_map<string, Patch*> LookupMap;

class PatchQueue:priority_queue<Patch*>{
public:
    PatchQueue(int myLevel, LeveledPatchMap* map);
    void push(const value_type &__v);
    Patch* popBestPatch();
    PatchQueue* descend(int level);
    LeveledPatchMap* getMap();
    unsigned long size();
    void tryPushAll(vector<Patch*>* patches);
    
private:
    int myLevel;
    LeveledPatchMap* map;
//    LookupMap* lookupMap;
    void tryPush(Patch* patch);
};

#endif
