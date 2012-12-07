#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <assert.h>
#include "Flip.h"
#include "lodepng.h"

inline static unsigned int convertARGBtoRGBA(unsigned int argbValue)
{
    return (argbValue << 8) | (argbValue >> (32-8));
}

inline static unsigned int convertRGBAtoARGB(unsigned int rgbaValue)
{
    return (rgbaValue >> 8) | (rgbaValue << (32-8));
}

inline static unsigned int endianFlip(unsigned int p){
    return (p & 0x000000FFU) << 24 | (p & 0x0000FF00U) << 8 |
    (p & 0x00FF0000U) >> 8 | (p & 0xFF000000U) >> 24;
}


PixelImageShape::PixelImageShape(unsigned char * png, size_t png_size):ImageShape::ImageShape(){
    unsigned int width=0,height = 0;
    unsigned int *pixels = 0;
    LodePNG_decode32((unsigned char **)&pixels, &width, &height, png, png_size);
    this->width = width;
    this->height = height;
    size_t size = sizeof(unsigned int)*width*height;
    this->pixels = (unsigned int *)malloc(size);
    for (int xx=0; xx<width; xx++) {
        for(int yy=0;yy<height;yy++){
            int i = yy*width+xx;
            //endian conversion - to big endian
            this->pixels[i] =convertRGBAtoARGB( endianFlip(pixels[i]));
            //                cout << pixels[xx*((int)textImage.size.width)+yy] << " ";
        }
    }
}


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
    size_t size = sizeof(unsigned int)*width*height;
    this->pixels = (unsigned int *)malloc(size);

    if(revert){
        for (int xx=0; xx<width; xx++) {
            for(int yy=0;yy<height;yy++){
                int i = yy*width+xx;
                //endian conversion - to big endian
                this->pixels[i] = endianFlip(pixels[i]);
                //                cout << pixels[xx*((int)textImage.size.width)+yy] << " ";
            }
        }
    }
    else{
        memcpy(this->pixels,pixels,size);
    }
};

unsigned int* PixelImageShape::convertToRGBALittleEndianPixels()
{
    unsigned int size = width*height;
    unsigned int * result = (unsigned int*)malloc(size*sizeof(unsigned int));
    for(unsigned int i=0;i<size;i++){
        result[i] = endianFlip(convertARGBtoRGBA(pixels[i]));
    }
    return result;
}

unsigned char * PixelImageShape::toPng(unsigned int pixelValue){
    unsigned int * rgbaPixels = convertToRGBALittleEndianPixels();
    size_t pngSize = 0;
    unsigned char* png = 0;
    unsigned error = LodePNG_encode32(&png,&pngSize,(unsigned char*)rgbaPixels,(unsigned)width,(unsigned)height);
    assert(!error);
    return png;
}

PixelImageShape::~PixelImageShape() {
    free(pixels);
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
