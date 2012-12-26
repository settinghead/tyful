//
//  ImageShape.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/8/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ImageShape.h"
#include "../tree/PolarRootTree.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "Flip.h"
#include "../tree/PolarTreeBuilder.h"

ImageShape::ImageShape(){
}

ImageShape::~ImageShape(){
}

#if NUM_THREADS > 1
inline void ImageShape::setFinalSeq(int seq){
    getTree()->setFinalSeq(seq);
}
#endif