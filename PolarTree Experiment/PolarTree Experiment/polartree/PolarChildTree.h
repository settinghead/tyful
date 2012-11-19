#ifndef PolarCHILDTree_H
#define PolarCHILDTree_H

#include "PolarTree.h"

class PolarRootTree;
class PolarChildTree: public PolarTree {
public:
	PolarChildTree(double r1, double r2, double d1,
			double d2, PolarRootTree* root, int minBoxSize);
	~PolarChildTree();
	PolarRootTree* root; /* REM */
	inline int getRootX();
	inline int getRootY();
	inline double computeX(bool rotate);
	inline double computeY(bool rotate);
	inline double computeRight(bool rotate);
	inline double computeBottom(bool rotate);
	inline double getRotation();
	inline double getScale();
	inline int getCurrentStamp();
	inline PolarRootTree* getRoot();
	inline ImageShape* getShape();
	inline int getMinBoxSize();
};


#endif
