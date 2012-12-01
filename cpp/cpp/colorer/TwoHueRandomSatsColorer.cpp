//
//  TwoHueRandomSatsColorer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "TwoHueRandomSatsColorer.h"
#include "../model/structs.h"
#include "../math/ColorMath.h"
#include <time.h>


TwoHueRandomSatsColorer::TwoHueRandomSatsColorer(){
    srand((unsigned)time(NULL));
    this->hues[0]= 256 * (rand() / double(RAND_MAX));
    this->hues[1]= 256-this->hues[0];
}

unsigned int TwoHueRandomSatsColorer::colorFor(Placement* place){
    srand((unsigned)time(NULL));
    int index = rand() % (sizeof(hues) / sizeof(hues[0]));
    double hue= hues[index];
    double sat= 200+rand()%(256-200);
    double val = 50+rand()%(200-50);
    
    
    return ColorMath::HSLtoRGB(hue/256, sat/256, val/256,1.0);
}