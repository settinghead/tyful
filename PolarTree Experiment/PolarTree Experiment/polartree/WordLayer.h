//
//  WordLayer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__WordLayer__
#define __PolarTree_Experiment__WordLayer__
#include "PolarLayer.h"

#define SAMPLE_DISTANCE 20

class WordLayer: public PolarLayer{
    const LAYER_TYPE type = WORD_LAYER;
    bool contains(double x, double y, double width, double height, double rotation);
    bool containsPoint(double x, double y, double refX, double refY) = 0;
    double getBrightness(int x, int y);
};

#endif /* defined(__PolarTree_Experiment__WordLayer__) */
