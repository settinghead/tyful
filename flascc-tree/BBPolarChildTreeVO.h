#ifndef BBPOLARCHILDTREEVO_H
#define BBPOLARCHILDTREEVO_H

#include "BBPolarTreeVO.h"
#include "ImageShape.h"

class BBPolarRootTreeVO;
class BBPolarChildTreeVO: public BBPolarTreeVO {
public:
	BBPolarChildTreeVO(double r1, double r2, double d1,
			double d2, BBPolarRootTreeVO* root, int minBoxSize);
	~BBPolarChildTreeVO();
	BBPolarRootTreeVO* root; /* REM */
	int getRootX();
	int getRootY();
	double computeX(bool rotate);
	double computeY(bool rotate);
	double computeRight(bool rotate);
	double computeBottom(bool rotate);
	double getRotation();
	int getCurrentStamp();
	BBPolarRootTreeVO* getRoot();
	ImageShape* getShape();
	int getMinBoxSize();
};


#endif
