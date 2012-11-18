//
//  PickFromAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PickFromAngler.h"
#include "EngineShape.h"
#include <stdlib.h>
#include <time.h>


PickFromAngler::PickFromAngler(vector<double>* angles){
    this->angles = angles;
    srand ( (unsigned int)time(NULL) );

}

double PickFromAngler::angleFor(EngineShape* shape){
    return angles->at(rand() * angles->size());
}