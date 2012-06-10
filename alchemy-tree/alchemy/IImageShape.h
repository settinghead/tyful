namespace polartree {

#ifndef IIMAGESHAPE_H
#define IIMAGESHAPE_H

class IImageShape {
public:

	virtual ~IImageShape();
	virtual bool contains(double x, double y, double width, double height);
	virtual bool containsPoint(double x, double y);
	virtual bool intersects(double x, double y, double width, double height);
	virtual double getWidth();
	virtual double getHeight();
};
#endif

}
