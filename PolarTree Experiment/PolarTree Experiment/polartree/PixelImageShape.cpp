#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "Flip.h"

PixelImageShape::PixelImageShape(unsigned char * pixels, int width, int height):
ImageShape::ImageShape(){
	this->width = width;
	this->height = height;
    int size = sizeof(unsigned int)*width*height;
	this->pixels = (unsigned int *)malloc(size);
    memcpy(this->pixels, pixels, size);
//    this->img = img;
};

PixelImageShape::~PixelImageShape() {
//	free(pixels);
};

int PixelImageShape::getWidth() {
	return width;
};

int PixelImageShape::getHeight() {
	return height;
};

bool PixelImageShape::isEmpty(unsigned int pixelValue){
    return (pixelValue & 0x00FFFFFF) < 0xFFFFFF;
};

unsigned int PixelImageShape::getPixel(int x, int y){
//    return    this->img->getPixel(x,y);
//    return pixels[x * height + y];
        return pixels[y * width + x];
};