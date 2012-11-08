

#ifndef IIMAGESHAPE_H
#define IIMAGESHAPE_H

class ImageShape {
public:
	bool contains(int x, int y, int width, int height);
	virtual bool containsPoint(int x, int y) = 0;
	virtual bool intersects(int x, int y, int width, int height) = 0;
	virtual int getWidth() = 0;
	virtual int getHeight() = 0;
};
#endif

