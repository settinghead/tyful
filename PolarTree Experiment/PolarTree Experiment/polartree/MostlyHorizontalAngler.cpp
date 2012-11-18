//
//  MostlyHorizontalAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "MostlyHorizontalAngler.h"
#include "PickFromAngler.h"
#include <vector>
#include "constants.h"

using namespace std;

MostlyHorizontalAngler::MostlyHorizontalAngler():
PickFromAngler::PickFromAngler(new vector<double>({ 0,0,0,HALF_PI,HALF_PI*3 })){
    
}