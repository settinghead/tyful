

#ifndef IIMAGESHAPE_H
#define IIMAGESHAPE_H

class ImageShape {
public:
	bool contains(int x, int y, int width, int height);
	bool containsPoint(int x, int y);
	bool intersects(int x, int y, int width, int height);
	virtual int getWidth() = 0;
	virtual int getHeight() = 0;
	virtual bool isEmpty(unsigned int pixelValue) = 0;
	virtual unsigned int getPixel(int x, int y) = 0;
};
#endif

