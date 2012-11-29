#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "Flip.h"

PixelImageShape::PixelImageShape(unsigned int const * pixels, int width, int height, bool revert):
ImageShape::ImageShape(), width(width),height(height),total(width*height),pixels((unsigned int *) pixels){
//	this->width = width;
//	this->height = height;
//    this->total = width*height;
//    int size = sizeof(unsigned int)*width*height;
//    this->pixels = (unsigned int *)pixels;
//	this->pixels = (unsigned int *)malloc(size);
    //memcpy(this->pixels, pixels, size);
//    this->img = img;
//    printStats();
    if(revert){
        int size = sizeof(unsigned int)*width*height;
        this->pixels = (unsigned int *)malloc(size);
        for (int xx=0; xx<width; xx++) {
            for(int yy=0;yy<height;yy++){
                int i = yy*width+xx;
                this->pixels[i] = (pixels[i] & 0x000000FFU) << 24 | (pixels[i] & 0x0000FF00U) << 8 |
                (pixels[i] & 0x00FF0000U) >> 8 | (pixels[i] & 0xFF000000U) >> 24;;
                //                cout << pixels[xx*((int)textImage.size.width)+yy] << " ";
            }
        }

    }
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
    printf("Text image special pixel (1,1): %u, empty: %x\n", getPixel(1, 1), isEmpty(getPixel(1, 1)));

};
