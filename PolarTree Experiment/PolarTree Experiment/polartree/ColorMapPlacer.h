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
class EngineShape;
class DensityPatchIndex;


class ColorMapPlacer:public Placer{
public:
    ColorMapPlacer(EngineShape* shape, DensityPatchIndex* index);
    vector<Placement*>* place(EngineShape* shape, unsigned long totalCount);
    void success();
    void fail();
    void success(vector<Placement*>*);
    void fail(vector<Placement*>*);
private:
    EngineShape* shape;
    DensityPatchIndex* index;
};

#endif /* defined(__PolarTree_Experiment__ColorMapPlacer__) */
