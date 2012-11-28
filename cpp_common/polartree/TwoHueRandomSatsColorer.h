//
//  TwoHueRandomSatsColorer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__TwoHueRandomSatsColorer__
#define __PolarTree_Experiment__TwoHueRandomSatsColorer__

#include "Colorer.h"
struct Placement;

class TwoHueRandomSatsColorer:public Colorer{
public:
    TwoHueRandomSatsColorer();
    unsigned int colorFor(Placement* place);
private:
    double hues[2];
};

#endif /* defined(__PolarTree_Experiment__TwoHueRandomSatsColorer__) */
