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

class PixelImageShape : public ImageShape{
public:
    PixelImageShape(unsigned int * pixels, int width, int height);
	~PixelImageShape();
	bool containsPoint(int x, int y);
	bool intersects(int x, int y, int width, int height);
	int getWidth();
	int getHeight();

private:
	int width, height;
	unsigned int * pixels;
};

#endif
