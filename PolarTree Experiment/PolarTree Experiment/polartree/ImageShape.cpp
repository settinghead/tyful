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

bool ImageShape::contains(int x, int y, int width, int height) {
	if (intersects(x, y, width, height)) {
		return false;
	} else {
		int rX = ((width==0)?0:rand() % width)+x;
		int rY = ((height==0)?0:rand() % height)+y;
        if(rX>=getWidth()) rX=getWidth()-1;
        else if (rX<0) rX=0;
        if(rY>=getHeight()) rY=getHeight()-1;
        else if (rY<0) rY=0;
		return containsPoint(rX, rY);
	}
}

bool ImageShape::containsPoint(int x, int y) {
    //    std::cout << (pixels[x * height + y] & 0x00FFFFFF) << ",";
    //    std::cout << sizeof(unsigned char) << ",";
//	return (pixels[x * height + y] & 0x00FFFFFF) < 0xFFFFFF;
    return isEmpty(getPixel(x, y));
}

bool ImageShape::intersects(int x, int y, int width, int height) {
    if(x>=getWidth()) x=getWidth()-1;
    else if (x<0) x=0;
    if(y>=getHeight()) y=getHeight()-1;
    else if (y<0) y=0;

	int cmp = getPixel(x, y);
    for (int yy = y; yy < y+height && yy <getHeight(); yy++) {
        for (int xx = x; xx < x+width && xx < getWidth(); xx++) {
            //            if(pixels[yy * width + xx] >0)
            //                std::cout << (unsigned int)pixels[yy * width + xx] << ",";
			if (getPixel(xx,yy) != cmp)
				return true;
		}
        //        std::cout << "\n";
    }
	return false;
}

PolarRootTree* ImageShape::getTree(){
    if(this->tree==NULL)
        this->tree = makeTree(this,0);
    return this->tree;
}

