#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "Flip.h"

PixelImageShape::PixelImageShape(unsigned int * pixels, int width, int height):
ImageShape::ImageShape(){
	this->width = width;
	this->height = height;
    this->total = width*height;
    int size = sizeof(unsigned int)*width*height;
	this->pixels = (unsigned int *)malloc(size);
    memcpy(this->pixels, pixels, size);
//    this->img = img;
};

PixelImageShape::~PixelImageShape() {
//	free(pixels);
};
