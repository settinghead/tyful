//
//  ColorMapPlacer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ColorMapPlacer__
#define __PolarTree_Experiment__ColorMapPlacer__
#include "Placer.h"
#include "../density/DensityPatchIndex.h"
#include "../model/EngineShape.h"
#include "../density/Patch.h"
#include <vector>

using namespace std;
class PolarCanvas;


class ColorMapPlacer:public Placer{
public:
    inline ColorMapPlacer(PolarCanvas* canvas, DensityPatchIndex* index){
        this->canvas = canvas;
        this->index = index;
    }
    vector<Placement*>* place(EngineShape* shape, unsigned long totalCount){
        vector<Patch*>* patches = index->findPatchFor(shape->getWidth(), shape->getHeight());
        vector<Placement*>* placements = new vector<Placement*>();
        
        for(int i=0;i<patches->size();i++){
            Placement* p = (Placement*)malloc(sizeof(Placement));
            Patch* patch = patches->at(i);
            p->location.x = patch->getX()+ patch->getWidth()/2;
            p->location.y = patch->getY()+patch->getHeight()/2;
            p->patch = patch;
            placements->push_back(p);
            if(placements->size()==NUMBER_OF_ATTEMPTED_PATCHES) break;
        }
        return placements;
    }
    inline void success(){
        
    }
    inline void fail(){
        
    }
    inline void success(vector<Placement*>* returnedObj){
        for(int i=0;i<returnedObj->size();i++){
            index->add(returnedObj->at(i)->patch);
        }
        success();
    }
    inline void fail(vector<Placement*>* returnedObj){
        for(int i=0;i<returnedObj->size();i++){
            index->add(returnedObj->at(i)->patch);
        }
        fail();
    }
private:
    PolarCanvas* canvas;
    DensityPatchIndex* index;
};

#endif /* defined(__PolarTree_Experiment__ColorMapPlacer__) */
