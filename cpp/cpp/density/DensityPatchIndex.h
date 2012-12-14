//
//  DensityPatchIndex.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__DensityPatchIndex__
#define __PolarTree_Experiment__DensityPatchIndex__
#include <vector>
#include <assert.h>
#include "../constants.h"
#include "LeveledPatchMap.h"
#include "../model/PolarCanvas.h"
using namespace std;

class Patch;

class DensityPatchIndex{
private:
    PolarCanvas* canvas;
    LeveledPatchMap* map;
    inline Patch* getBestPatchAtLevel(int level){
        Patch* result= map->getBestPatchAtLevel(level);
//			if (result == NULL)
//				return getBestPatchAtLevel(level - 1);
//			else
        return result;
    }
    inline int findGranularityLevel(int width, int height){
        int max = width > height ? width : height;
        max *= 2;
        int minContainerLength = canvas->getWidth() > canvas->getHeight() ? canvas->getWidth(): canvas->getHeight();
        int squareWidth = minContainerLength;
        int level = 0;
        
        while (squareWidth > max) {
            squareWidth /= NUMBER_OF_DIVISIONS;
            level++;
        }
        
        level -= 1;
        if(level<0) level = 0;
        return level;
    }

public:
    inline DensityPatchIndex(PolarCanvas* canvas){
        this -> canvas = canvas;
        this -> map = new LeveledPatchMap(this);
    }
    ~DensityPatchIndex(){
        delete map;
    }
    inline PolarCanvas* getCanvas(){
        return canvas;
    }
    inline vector<Patch*>* findPatchFor(int width, int height){
        vector<Patch*>* result = new vector<Patch*>();
        int level = findGranularityLevel(width,height);
        //    double area = width*height;
        
        for(int i=0;i<NUMBER_OF_ATTEMPTED_PATCHES; i++){
            Patch* p = getBestPatchAtLevel(level);
//            Patch* p = getBestPatchAtLevel(0);
            if(p!=NULL) result->push_back(p);
        }
//        assert(result->size()>0);
        return result;
    }
    inline void add(Patch* p){
        map->add(p);
    }

};

#endif /* defined(__PolarTree_Experiment__DensityPatchIndex__) */
