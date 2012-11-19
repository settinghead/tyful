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
	double _rotation = 0; /* REM */
	double _scale = 1; /* REM */
	int rootStamp; /* REM */
	ImageShape* shape; /* REM */
	int _minBoxSize; /* REM */
	void setLocation(int centerX, int centerY);
	void setTopLeftLocation(int centerX, int centerY, bool scale);
	inline int getRootX();
	inline int getRootY();
	inline double computeX(bool rotate);
	inline double computeY(bool rotate);
	inline double computeRight(bool rotate);
	inline double computeBottom(bool rotate);
	void setRotation(double rotation);
	void setScale(double scale);
	inline double getRotation();
	inline double getScale();
	inline int getCurrentStamp();
	inline PolarRootTree* getRoot();
	inline int getMinBoxSize();
	inline ImageShape* getShape();
};

#endif
