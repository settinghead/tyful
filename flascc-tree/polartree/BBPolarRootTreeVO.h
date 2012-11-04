#ifndef BBPOLARROOTTREEVO_H
#define BBPOLARROOTTREEVO_H
#include "ImageShape.h"
#include "BBPolarTreeVO.h"


class BBPolarRootTreeVO: public BBPolarTreeVO {
public:
	BBPolarRootTreeVO(ImageShape* shape, int centerX, int centerY, double d,
			int minBoxSize);
	~BBPolarRootTreeVO();
	int rootX; /* REM */
	int rootY; /* REM */
	double _rotation; /* REM */
	int rootStamp; /* REM */
	ImageShape* shape; /* REM */
	int _minBoxSize; /* REM */
	void setLocation(int centerX, int centerY);
	int getRootX();
	int getRootY();
	double computeX(bool rotate);
	double computeY(bool rotate);
	double computeRight(bool rotate);
	double computeBottom(bool rotate);
	void setRotation(double rotation);
	double getRotation();
	int getCurrentStamp();
	BBPolarRootTreeVO* getRoot();
	int getMinBoxSize();
	ImageShape* getShape();
};

#endif
