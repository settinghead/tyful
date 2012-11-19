//
//  ColorMapPlacer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ColorMapPlacer.h"
#include "PolarCanvas.h"
#include "DensityPatchIndex.h"
#include "EngineShape.h"
#include "ImageShape.h"
#include "PolarCanvas.h"
#include "Patch.h"

using namespace std;

ColorMapPlacer::ColorMapPlacer(PolarCanvas* canvas, DensityPatchIndex* index){
    this->canvas = canvas;
    this->index = index;
}

vector<Placement*>* ColorMapPlacer::place(EngineShape* shape, unsigned long totalCount){
    vector<Patch*>* patches = index->findPatchFor(shape->getShape()->getWidth(), shape->getShape()->getHeight());
    vector<Placement*>* placements = new vector<Placement*>();
    
    for(int i=0;i<patches->size();i++){
        Placement* p = (Placement*)malloc(sizeof(Placement));
        Patch* patch = patches->at(i);
        p->location.x = patch->getX()+ patch->getWidth()/2;
        p->location.y = patch->getY()+patch->getHeight()/2;
        p->patch = patch;
        placements->push_back(p);
    }
    return placements;
}
void ColorMapPlacer::success(){
    
}
void ColorMapPlacer::fail(){
    
}
void ColorMapPlacer::success(vector<Placement*>* returnedObj){
    for(int i=0;i<returnedObj->size();i++){
        index->add(returnedObj->at(i)->patch);
    }
    success();
}
void ColorMapPlacer::fail(vector<Placement*>* returnedObj){
    for(int i=0;i<returnedObj->size();i++){
        index->add(returnedObj->at(i)->patch);
    }
    fail();
}