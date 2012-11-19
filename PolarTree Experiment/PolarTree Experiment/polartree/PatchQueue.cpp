//
//  PatchQueue.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PatchQueue.h"
#include <queue>
#include <cstdlib>
#include <cstring>
#include <unordered_map>
#include <vector>
#include "PolarLayer.h"
#include "Patch.h"
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"

using namespace std;

PatchQueue::PatchQueue(int myLevel, LeveledPatchMap* map):priority_queue<Patch*>(){
    this->myLevel = myLevel;
//    this->lookupMap = new LookupMap;
    this->map  = map;
    if(myLevel==0){
        for (vector<PolarLayer*>::iterator it = map->getIndex()->getCanvas()->getLayers()->begin();
             it != map->getIndex()->getCanvas()->getLayers()->end(); ++it) {
            PolarLayer* layer = *it;
            if(layer->type==WORD_LAYER){
                this->tryPush(new Patch(0,0,layer->getWidth(),layer->getHeight(),0,NULL,this,(WordLayer*)layer));
            }
        }
    }
}

Patch* PatchQueue::popBestPatch(){
    Patch* result = this->top();
    pop();
    return result;
}

PatchQueue* PatchQueue::descend(int level){
    PatchQueue* queue = new PatchQueue(level, this->map);
    std::vector<Patch*> *queue_vector = reinterpret_cast<vector<Patch*>*>(this);

    for (vector<Patch*>::iterator it = queue_vector->begin();
         it != queue_vector->end(); ++it){
        Patch* patch = (*it);
        vector<Patch*>* children = patch->divideIntoNineOrMore(queue);
        queue->tryPushAll(children);
    }
    return queue;
}

void PatchQueue::tryPushAll(vector<Patch*>* patches){
    for (vector<Patch*>::iterator it = patches->begin();
         it != patches->end(); ++it){
        Patch* p = (*it);
        tryPush(p);
    }
}

unsigned long PatchQueue::size(){
    return reinterpret_cast<vector<Patch*>*>(this)->size();

}

int PatchQueue::getLevel(){
    return myLevel;
}

void PatchQueue::tryPush(Patch* patch){
    if (patch->getAlphaSum() > QUEUE_ALPHA_THRESHOLD){
        (*this).priority_queue<Patch*>::push(patch);
    }
}

LeveledPatchMap* PatchQueue::getMap(){
    return map;
}
