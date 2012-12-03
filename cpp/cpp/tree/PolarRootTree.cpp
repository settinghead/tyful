#include "PolarTree.h"
#include "PolarRootTree.h"
#include "../model/ImageShape.h"
#include <math.h>
#include "../model/Flip.h"

PolarRootTree::PolarRootTree(ImageShape* shape, double d, int minBoxSize) :
		PolarTree(0, TWO_PI, 0, d, minBoxSize)
#if NUM_THREADS>1
,finalSeq(-1)
#endif
{
            for(int i=0;i<NUM_THREADS;i++){
                this->rootStamp[i] = 1;
                this->rootX[i] = this->rootY[i] = NAN;
            }
	this->shape = shape;
	this->_minBoxSize = minBoxSize;
//    this->getKids();

}

PolarRootTree::~PolarRootTree() {
}



inline int PolarRootTree::getRootX(int seq) {
    assert(!isnan(this->rootX[seq]));
	return this->rootX[seq];
}

inline int PolarRootTree::getRootY(int seq) {
    assert(!isnan(this->rootY[seq]));
	return this->rootY[seq];
}


inline double PolarRootTree::computeX(int seq,bool rotate) {
	return -(this->d2);
}

inline double PolarRootTree::computeY(int seq,bool rotate) {
//#ifdef FLIP
	return -(this->d2);
//#else
//    return this->d2;
//#endif
}

inline double PolarRootTree::computeRight(int seq,bool rotate) {
	return this->d2;
}

inline double PolarRootTree::computeBottom(int seq,bool rotate) {
//#ifdef FLIP
	return this->d2;
//#else
//    return -(this->d2);
//#endif
}

inline double PolarRootTree::getRotation(int seq) {
	return this->_rotation[seq];
}

inline int PolarRootTree::getCurrentStamp(int seq) {
	return this->rootStamp[seq];
}

inline PolarRootTree* PolarRootTree::getRoot() {
	return this;
}

inline int PolarRootTree::getMinBoxSize() {
	return this->_minBoxSize;
}

inline ImageShape* PolarRootTree::getShape() {
	return this->shape;
}

