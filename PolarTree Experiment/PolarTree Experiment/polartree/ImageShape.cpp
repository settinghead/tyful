//
//  ImageShape.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/8/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>

bool ImageShape::contains(int x, int y, int width, int height) {
	if (intersects(x, y, width, height)) {
		return false;
	} else {
		int rX = ((width==0)?0:rand() % width)+x;
		int rY = ((height==0)?0:rand() % height)+y;
		return containsPoint(rX, rY);
	}
}