//
//  Colorer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_Colorer_h
#define PolarTree_Experiment_Colorer_h

struct Placement;

class Colorer{
public:
    virtual unsigned int colorFor(Placement* place) = 0;
};

#endif
