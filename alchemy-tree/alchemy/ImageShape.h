#include "AS3.h"

namespace polartree {

#ifndef IIMAGESHAPE_H
#define IIMAGESHAPE_H

class ImageShape {
public:
	ImageShape(AS3_Val &src, int width, int height);
	~ImageShape();
	bool contains(int x, int y, int width, int height);
	bool containsPoint(int x, int y);
	bool intersects(int x, int y, int width, int height);
	int getWidth();
	int getHeight();

private:
	int width, height;
	unsigned int * pixels;
};
#endif

}
