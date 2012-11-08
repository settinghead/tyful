#include "PixelImageShape.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>


PixelImageShape::PixelImageShape(unsigned int * pixels, int width, int height) {
	this->width = width;
	this->height = height;
	this->pixels = pixels;
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