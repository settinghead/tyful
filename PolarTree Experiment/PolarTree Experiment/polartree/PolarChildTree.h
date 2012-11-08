#ifndef PolarCHILDTree_H
#define PolarCHILDTree_H

#include "PolarTree.h"
#include "ImageShape.h"

class PolarRootTree;
class PolarChildTree: public PolarTree {
public:
	PolarChildTree(double r1, double r2, double d1,
			double d2, PolarRootTree* root, int minBoxSize);
	~PolarChildTree();
	PolarRootTree* root; /* REM */
	int getRootX();
	int getRootY();
	double computeX(bool rotate);
	double computeY(bool rotate);
	double computeRight(bool rotate);
	double computeBottom(bool rotate);
	double getRotation();
	int getCurrentStamp();
	PolarRootTree* getRoot();
	ImageShape* getShape();
	int getMinBoxSize();
};


#endif
