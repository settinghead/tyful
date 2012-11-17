//
//  PatchQueue.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PatchQueue.h"
#include <queue>
#include <vector>
#include "PolarLayer.h"
#include "Patch.h"
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"

PatchQueue::PatchQueue(int myLevel, LeveledPatchMap* map):priority_queue<Patch*>(){
    this->myLevel = myLevel;
    this->lookupMap = new unordered_map<string, Patch*>();
    this->map  = map;
    if(myLevel==0){
        for (vector<PolarLayer*>::iterator it = map->getIndex()->getCanvas()->getLayers()->begin();
             it != map->getIndex()->getCanvas()->layers->end(); ++it) {
            PolarLayer* layer = *it;
            if(layer->type==WORD_LAYER){
                this->tryPush(new Patch(0,0,layer->getWidth(),layer->getHeight(),0,NULL,this,layer));
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
        queue->tryAddAll(children);
    }
    return queue;
}

unsigned long PatchQueue::size(){
    return reinterpret_cast<vector<Patch*>*>(this)->size();

}

void PatchQueue::tryPush(Patch* patch){
    if (patch->getAlphaSum() > QUEUE_ALPHA_THRESHOLD){
        this->push(patch);
    }
}

LeveledPatchMap* PatchQueue::getMap(){
    return map;
}
