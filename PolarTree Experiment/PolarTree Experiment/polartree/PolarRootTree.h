#ifndef PolarROOTTree_H
#define PolarROOTTree_H
#include "PolarTree.h"

class ImageShape;

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
	inline int getRootX();
	inline int getRootY();
	inline double computeX(bool rotate);
	inline double computeY(bool rotate);
	inline double computeRight(bool rotate);
	inline double computeBottom(bool rotate);
	void setRotation(double rotation);
	inline double getRotation();
	inline int getCurrentStamp();
	inline PolarRootTree* getRoot();
	inline int getMinBoxSize();
	inline ImageShape* getShape();
};

#endif
