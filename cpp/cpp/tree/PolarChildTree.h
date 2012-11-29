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
	inline int getRootX(int seq);
	inline int getRootY(int seq);
	inline double computeX(int seq,bool rotate);
	inline double computeY(int seq,bool rotate);
	inline double computeRight(int seq,bool rotate);
	inline double computeBottom(int seq,bool rotate);
	inline double getRotation(int seq);
	inline int getCurrentStamp(int seq);
	inline PolarRootTree* getRoot();
	inline ImageShape* getShape();
	inline int getMinBoxSize();
};


#endif
