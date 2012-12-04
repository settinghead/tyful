//
//  PickFromAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PickFromAngler.h"
#include "../model/EngineShape.h"
#include <stdlib.h>
#include <time.h>


PickFromAngler::PickFromAngler(vector<double>* angles){
    this->angles = angles;
    srand ( (unsigned int)time(NULL) );
}

PickFromAngler::~PickFromAngler(){
    delete angles;
}

double PickFromAngler::angleFor(int seq,EngineShape* shape){
    int i = (int)(rand() % angles->size());
    return angles->at(i);
}