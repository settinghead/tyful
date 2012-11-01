#include <time.h>

#include <stdlib.h>
#include <stdio.h>

#include "ImageShape.h"

ImageShape::ImageShape(unsigned int * pixels, int width, int height) {
	this->width = width;
	this->height = height;
	this->pixels = pixels;
}

ImageShape::~ImageShape() {
	delete pixels;
}

bool ImageShape::contains(int x, int y, int width, int height) {
	if (intersects(x, y, width, height)) {
		return false;
	} else {
		int rX = rand() % width+x;
		int rY = rand() % height+y;
		return containsPoint(rX, rY);
	}
}

bool ImageShape::containsPoint(int x, int y) {
	return pixels[x * height + y] & 0xFF > 0;
}

bool ImageShape::intersects(int x, int y, int width, int height) {
	int cmp = pixels[y * width + x];
	for (int xx = x; xx < x+width; xx++) {
		for (int yy = y; yy < y+height; yy++) {
			if (pixels[yy * width + xx] != cmp)
				return true;
		}
	}
	return false;
}

int ImageShape::getWidth() {
	return width;
}

int ImageShape::getHeight() {
	return height;
}
