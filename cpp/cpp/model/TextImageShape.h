//
//  TextImageShape.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/24/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__TextImageShape__
#define __PolarTree_Experiment__TextImageShape__
#include "../tree/PolarRootTree.h"

class TextImageShape:public PolarRootTree{
public:
    TextImageShape( unsigned int const * pixels, int width, int height, bool revert, bool rgbaToArgb):PolarRootTree(pixels,width,height, revert,rgbaToArgb){
//        printStats();
    }
    TextImageShape(unsigned char * png, size_t size):PolarRootTree(png,size){
        
    }
    virtual ~TextImageShape(){}
  
};

#endif /* defined(__PolarTree_Experiment__TextImageShape__) */
