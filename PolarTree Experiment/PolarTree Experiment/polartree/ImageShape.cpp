//
//  ImageShape.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/8/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ImageShape.h"
#include "PolarRootTree.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "Flip.h"
#include "PolarTreeBuilder.h"

ImageShape::ImageShape(){
    this->tree = NULL;
}

PolarRootTree* ImageShape::getTree(){
    if(this->tree==NULL)
        this->tree = makeTree(this,0);
    return this->tree;
}

