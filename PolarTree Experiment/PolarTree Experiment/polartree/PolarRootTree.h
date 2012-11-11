#ifndef PolarROOTTree_H
#define PolarROOTTree_H
#include "ImageShape.h"
#include "PolarTree.h"


class PolarRootTree: public PolarTree {
public:
	PolarRootTree(ImageShape* shape, int centerX, int centerY, double d,
			int minBoxSize);
	~PolarRootTree();
	int rootX; /* REM */
	int rootY; /* REM */
	double _rotation; /* REM */
	int rootStamp; /* REM */
	ImageShape* shape; /* REM */
	int _minBoxSize; /* REM */
	void setLocation(int centerX, int centerY);
	void setTopLeftLocation(int centerX, int centerY);
	int getRootX();
	int getRootY();
	double computeX(bool rotate);
	double computeY(bool rotate);
	double computeRight(bool rotate);
	double computeBottom(bool rotate);
	void setRotation(double rotation);
	double getRotation();
	int getCurrentStamp();
	PolarRootTree* getRoot();
	int getMinBoxSize();
	ImageShape* getShape();
};

#endif
