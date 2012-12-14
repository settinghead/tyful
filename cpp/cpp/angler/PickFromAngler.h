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
#include <set>
#include <vector>

using namespace std;
class EngineShape;

class PickFromAngler:public Angler{
private:
    set<double> angles_set;
    vector<double> angles;
    
public:
    PickFromAngler();
    ~PickFromAngler();
    inline void addAngle(double angle){
        angles_set.insert(angle);
        angles.push_back(angle);
    }
    double angleFor(int seq,EngineShape* shape,double prevAngle);
    inline bool alternativeValid(double angle){
        return angles_set.find(angle) != angles_set.end();
    }
};

#endif
