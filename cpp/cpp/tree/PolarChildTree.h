#ifndef PolarCHILDTree_H
#define PolarCHILDTree_H

#include "PolarTree.h"
#include "PolarRootTree.h"

class PolarChildTree: public PolarTree {
public:
	inline PolarChildTree(double r1, double r2, double d1,
                          double d2, PolarRootTree* root, int minBoxSize)
    :PolarTree::PolarTree(r1, r2, d1, d2, minBoxSize) {
        this->root = root;
    }
	~PolarChildTree();
	PolarRootTree* root; /* REM */
	inline int getRootX();
	inline int getRootY();
	inline double computeX(bool rotate);
	inline double computeY(bool rotate);
	inline double computeRight(bool rotate);
	inline double computeBottom(bool rotate);
	inline double getRotation();
	inline int getCurrentStamp();
	inline PolarRootTree* getRoot();
	inline ImageShape* getShape();
	inline int getMinBoxSize();
};


#endif
