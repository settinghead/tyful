#ifndef BBPOLARROOTTREEVO_H
#define BBPOLARROOTTREEVO_H
#include "IImageShape.h"
#include "BBPolarTreeVO.h"

namespace polartree {

class BBPolarRootTreeVO: public BBPolarTreeVO {
public:
	BBPolarRootTreeVO(IImageShape* shape, int centerX, int centerY, double d,
			int minBoxSize);
	~BBPolarRootTreeVO();
	int rootX; /* REM */
	int rootY; /* REM */
	double _rotation; /* REM */
	int rootStamp; /* REM */
	IImageShape* shape; /* REM */
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
	IImageShape* getShape();
};

} // end namespace polartree
#endif
