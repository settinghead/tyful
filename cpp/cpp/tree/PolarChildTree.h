#ifndef PolarCHILDTree_H
#define PolarCHILDTree_H

#include "PolarTree.h"

class PolarRootTree;
class PolarChildTree: public PolarTree {
public:
	PolarChildTree(double r1, double r2, double d1,
                          double d2, PolarRootTree* root)
    :PolarTree::PolarTree(r1, r2, d1, d2),root(root) {
    }
	~PolarChildTree();
	PolarRootTree* root; 
	inline int getRootX(int seq);
	inline int getRootY(int seq);
    inline int getFinalSeq();
    inline void setFinalSeq(int seq);
	inline double computeX(int seq,bool rotate);
	inline double computeY(int seq,bool rotate);
	inline double computeRight(int seq,bool rotate);
	inline double computeBottom(int seq,bool rotate);
	inline double getRotation(int seq);
    inline double getScale();
	inline int getCurrentStamp(int seq);
	inline bool getCurrentDStamp();
	inline PolarRootTree* getRoot();
	inline ImageShape* getShape();
};


#endif
