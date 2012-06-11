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
		int rX = rand() % width;
		int rY = rand() % height;
		return containsPoint(rX, rY);
	}
}

bool ImageShape::containsPoint(int x, int y) {
	return pixels[y * width + x] & 0x000000FF > 0;
}

bool ImageShape::intersects(int x, int y, int width, int height) {
	int cmp = pixels[y * width + x];
	for (int xx = 0; xx < x; xx++) {
		for (int yy = 0; yy < y; yy++) {
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
