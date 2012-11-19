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
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"

#define QUEUE_ALPHA_THRESHOLD -DBL_MAX

using namespace std;

typedef std::unordered_map<string, Patch*> LookupMap;
struct ComparePatch;

class PatchQueue:priority_queue<Patch*, vector<Patch*>, ComparePatch>{
private:
    int myLevel;
    LeveledPatchMap* map;
public:
    inline PatchQueue(int myLevel, LeveledPatchMap* map){
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
    inline void push(const value_type &__v);
    inline Patch* popBestPatch(){
        Patch* result = this->top();
        pop();
        return result;
    }
    inline PatchQueue* descend(int level){
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
    inline LeveledPatchMap* getMap();
    inline unsigned long size(){
        return reinterpret_cast<vector<Patch*>*>(this)->size();
    }
    inline int getLevel(){
        return myLevel;
    }
    inline void tryPush(Patch* patch){
        if (patch->getAlphaSum() > QUEUE_ALPHA_THRESHOLD){
            (*this).priority_queue<Patch*, vector<Patch*>, ComparePatch>::push(patch);
        }
    }
    inline void tryPushAll(vector<Patch*>* patches){
        for (vector<Patch*>::iterator it = patches->begin();
             it != patches->end(); ++it){
            Patch* p = (*it);
            tryPush(p);
        }
    }
    

//    LookupMap* lookupMap;
};

#endif
