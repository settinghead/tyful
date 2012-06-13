#include <time.h>

#include <stdlib.h>
#include <stdio.h>
#include "AS3.h"

#include "ImageShape.h"
namespace polartree {

ImageShape::ImageShape(AS3_Val &src, int width, int height) {
	this->width = width;
	this->height = height;
	this->pixels = pixels;

	AS3_Val lengthOfArgs = AS3_GetS(src, "length");
	int len = AS3_IntValue(lengthOfArgs);

	//	unsigned int len = width * height;
	pixels = (unsigned int *) malloc(sizeof(unsigned char) * (len + 1));
	;
	AS3_ByteArray_seek(src, 0, SEEK_SET);

	//warning: small endian-big endian conversion may needed
	//see discussion here:
	//http://forums.adobe.com/message/3597977#3597977

	AS3_ByteArray_readBytes(pixels, src, len);

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
} // end namespace polartree
