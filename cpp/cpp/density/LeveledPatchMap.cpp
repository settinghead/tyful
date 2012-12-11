//
//  LeveledPatchMap.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"
#include "Patch.h"
#include "PatchQueue.h"
#include "vector"

using namespace std;
LeveledPatchMap::~LeveledPatchMap()
{
    for(int i=0;i<map->size();i++)
        delete map->at(i);
        delete map;
}

Patch* LeveledPatchMap::getBestPatchAtLevel(int level){
    PatchQueue* queue = getQueue(level);
    if(queue->size()>0)
        return queue->popBestPatch();
    else
        return NULL;
}

PatchQueue* LeveledPatchMap::getQueue(int level){
    if(level>=map->size())
        generateLevelQueue(level);
    return map->at(level);
}

void LeveledPatchMap::generateLevelQueue(int level){
    if(level==0){
        PatchQueue* topLevelQueue = new PatchQueue(0, this);
        this->map->push_back(topLevelQueue);
    }
    else{
        if(level>map->size())
            //generate prior levels first
            generateLevelQueue(level-1);
        //descend and push
        map->push_back(map->at(map->size()-1)->descend(level));
    }
}

void LeveledPatchMap::add(Patch* p){
    getQueue(p->getLevel())->tryPush(p);
}

DensityPatchIndex* LeveledPatchMap::getIndex(){
    return index;
}

