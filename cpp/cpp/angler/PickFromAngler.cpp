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
#include <algorithm>


PickFromAngler::PickFromAngler(){
    srand ( (unsigned int)time(NULL) );
}

PickFromAngler::~PickFromAngler(){
}

double PickFromAngler::angleFor(int seq,EngineShape* shape,double prevAngle){
    int i = (int)(rand() % angles.size());
    return angles[i];
}