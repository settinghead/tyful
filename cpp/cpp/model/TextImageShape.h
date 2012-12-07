//
//  TextImageShape.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/24/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__TextImageShape__
#define __PolarTree_Experiment__TextImageShape__
#include "PixelImageShape.h"

class TextImageShape:public PixelImageShape{
public:
    TextImageShape( unsigned int const * pixels, int width, int height, bool revert, bool rgbaToArgb):PixelImageShape(pixels,width,height, revert,rgbaToArgb){
        printStats();
    }
    
    virtual inline bool isEmpty(unsigned int pixelValue){
//        return (pixelValue & 0x00FFFFFF) == 0xFFFFFF;
        return pixelValue >> 24 == 0;
    }
};

#endif /* defined(__PolarTree_Experiment__TextImageShape__) */
