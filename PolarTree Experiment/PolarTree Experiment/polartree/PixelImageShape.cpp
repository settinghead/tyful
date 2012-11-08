#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>


PixelImageShape::PixelImageShape(unsigned char * pixels, int width, int height) {
	this->width = width;
	this->height = height;
    int size = sizeof(unsigned char)*width*height;
	this->pixels = (unsigned char *)malloc(size);
    memcpy(this->pixels, pixels, size);
}

PixelImageShape::~PixelImageShape() {
	free(pixels);
}

bool PixelImageShape::containsPoint(int x, int y) {
	return (pixels[x * height + y] & 0xFF) > 0;
}

bool PixelImageShape::intersects(int x, int y, int width, int height) {
	int cmp = pixels[y * width + x];
	for (int xx = x; xx < x+width; xx++) {
		for (int yy = y; yy < y+height; yy++) {
//            if(pixels[yy * width + xx] >0)
//                std::cout << (unsigned int)pixels[yy * width + xx] << "\n";
			if (pixels[yy * width + xx] != cmp)
				return true;
		}
	}
	return false;
}

int PixelImageShape::getWidth() {
	return width;
}

int PixelImageShape::getHeight() {
	return height;
}