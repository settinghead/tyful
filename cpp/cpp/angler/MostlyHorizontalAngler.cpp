//
//  MostlyHorizontalAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "MostlyHorizontalAngler.h"
#include "PickFromAngler.h"
#include <set>
#include "../constants.h"

using namespace std;

MostlyHorizontalAngler::MostlyHorizontalAngler():
PickFromAngler::PickFromAngler(){
    addAngle(0);
    addAngle(0);
    addAngle(0);
    addAngle(HALF_PI);
    addAngle(HALF_PI);
//    addAngle(HALF_PI*3);
}