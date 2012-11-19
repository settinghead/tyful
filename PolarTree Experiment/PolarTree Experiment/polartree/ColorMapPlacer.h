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
#include <vector>

using namespace std;
class PolarCanvas;
class EngineShape;
class DensityPatchIndex;


class ColorMapPlacer:public Placer{
public:
    ColorMapPlacer(PolarCanvas* canvas, DensityPatchIndex* index);
    vector<Placement*>* place(EngineShape* shape, unsigned long totalCount);
    void success();
    void fail();
    void success(vector<Placement*>*);
    void fail(vector<Placement*>*);
private:
    PolarCanvas* canvas;
    DensityPatchIndex* index;
};

#endif /* defined(__PolarTree_Experiment__ColorMapPlacer__) */
