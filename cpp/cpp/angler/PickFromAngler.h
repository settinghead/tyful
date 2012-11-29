//
//  PicFromAngler.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_PicFromAngler_h
#define PolarTree_Experiment_PicFromAngler_h
#include "Angler.h"
#include <vector>

using namespace std;
class EngineShape;

class PickFromAngler:public Angler{
protected:
    vector<double>* angles;
    
public:
    PickFromAngler(vector<double>* angles);
    double angleFor(EngineShape* shape);
};

#endif
