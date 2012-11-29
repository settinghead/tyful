#ifndef PolarROOTTree_H
#define PolarROOTTree_H
#include "PolarTree.h"
#include "ImageShape.h"
#include "math.h"

class PolarRootTree: public PolarTree {
public:
	PolarRootTree(ImageShape* shape, int centerX, int centerY, double d,
			int minBoxSize);
	~PolarRootTree();
	inline void setLocation(int centerX, int centerY){
        this->rootX = centerX;
        this->rootY = centerY;
        (this->rootStamp)++;
    }
	inline void setTopLeftLocation(double top, double left){
        this->rootX = this->shape->getWidth()/2 + top;
        this->rootY = this->shape->getHeight()/2 + left;
        (this->rootStamp)++;
    }
	inline int getRootX();
	inline int getRootY();
	inline double computeX(bool rotate);
	inline double computeY(bool rotate);
	inline double computeRight(bool rotate);
	inline double computeBottom(bool rotate);
	inline void setRotation(double rotation){
        if(rotation!=this->_rotation){
            this->_rotation = fmod(rotation, TWO_PI);
            if (this->_rotation < 0) {
                this->_rotation = (TWO_PI + this->_rotation);
            }
            (this->rootStamp)++;
        }
    }
	inline double getRotation();
	inline int getCurrentStamp();
	inline PolarRootTree* getRoot();
	inline int getMinBoxSize();
	inline ImageShape* getShape();
private:
    double rootX; /* REM */
	double rootY; /* REM */
	double _rotation; /* REM */
	int rootStamp; /* REM */
	ImageShape* shape; /* REM */
	int _minBoxSize; /* REM */
};

#endif
