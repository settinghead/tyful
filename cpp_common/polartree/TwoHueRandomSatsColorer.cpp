//
//  TwoHueRandomSatsColorer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "TwoHueRandomSatsColorer.h"
#include "structs.h"
#include "ColorMath.h"
#include <cmath>
#include <limits>
#include <cstdlib>
#include <ctime>

TwoHueRandomSatsColorer::TwoHueRandomSatsColorer(){
    srand((unsigned)time(NULL));
    this->hues[0]= 256 * ((double) rand() / (RAND_MAX+1));
    this->hues[1]= 256 * ((double) rand() / (RAND_MAX+1));
}

unsigned int TwoHueRandomSatsColorer::colorFor(Placement* place){
    srand((unsigned)time(NULL));
    double hue= hues[rand() % (sizeof(hues) / sizeof(hues[0]))];
    double sat= 200+rand()%(256-200);
    double val = 50+rand()%(200-50);
    
    
    return ColorMath::HSLtoRGB(hue/256, sat/256, val/256,1.0);
}