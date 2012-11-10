#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>


PixelImageShape::PixelImageShape(unsigned char * pixels, int width, int height) {
	this->width = width;
	this->height = height;
    int size = sizeof(unsigned int)*width*height;
	this->pixels = (unsigned int *)malloc(size);
    memcpy(this->pixels, pixels, size);
}

PixelImageShape::~PixelImageShape() {
	free(pixels);
}

bool PixelImageShape::containsPoint(int x, int y) {
//    std::cout << (pixels[x * height + y] & 0x00FFFFFF) << ",";
//    std::cout << sizeof(unsigned char) << ",";
	return (pixels[x * height + y] & 0x00FFFFFF) < 0xFFFFFF;
}

bool PixelImageShape::intersects(int x, int y, int width, int height) {
	int cmp = pixels[y * width + x];
    for (int yy = y; yy < y+height; yy++) {
        for (int xx = x; xx < x+width; xx++) {
//            if(pixels[yy * width + xx] >0)
//                std::cout << (unsigned int)pixels[yy * width + xx] << ",";
			if (pixels[yy * width + xx] != cmp)
				return true;
		}
//        std::cout << "\n";
    }
	return false;
}

int PixelImageShape::getWidth() {
	return width;
}

int PixelImageShape::getHeight() {
	return height;
}