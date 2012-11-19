//
//  Header.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/8/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PIXELIMAGESHAPE_H
#define PIXELIMAGESHAPE_H
#include "ImageShape.h"
#include "EngineShape.h"

class PixelImageShape : public ImageShape{
public:
    PixelImageShape( unsigned int * pixels, int width, int height);
	~PixelImageShape();
	int getWidth();
	int getHeight();
    bool isEmpty(unsigned int pixelValue);
	unsigned int getPixel(int x, int y);

protected:
	unsigned int width, height;
    unsigned int total;
	unsigned int * pixels;
//    unsigned char * pixels;
};

#endif
