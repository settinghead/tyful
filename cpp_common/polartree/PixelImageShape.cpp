#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "Flip.h"

PixelImageShape::PixelImageShape(unsigned int const * pixels, int width, int height):
ImageShape::ImageShape(){
	this->width = width;
	this->height = height;
    this->total = width*height;
//    int size = sizeof(unsigned int)*width*height;
    this->pixels = (unsigned int *)pixels;
//	this->pixels = (unsigned int *)malloc(size);
    //memcpy(this->pixels, pixels, size);
//    this->img = img;
//    printStats();
};

PixelImageShape::~PixelImageShape() {
    //	free(pixels);
};

void PixelImageShape::printStats() {
    double sum = 0;
    for(int x=0;x<width;x++)
        for(int y=0;y<height;y++){
            sum+=containsPoint(x, y)?1:0;
        }
    sum/=width*height;
    printf("Width: %d, height: %d, Fill rate: %f, pixel addr: %p\n", width, height, sum, pixels);
    printf("Text image special pixel (1,1): %u, empty: %d\n", getPixel(1, 1), isEmpty(getPixel(1, 1)));

};
