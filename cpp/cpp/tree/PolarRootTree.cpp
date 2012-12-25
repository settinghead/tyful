#include "PolarTree.h"
#include "PolarRootTree.h"
#include "../model/ImageShape.h"
#include <math.h>
#include "../model/Flip.h"

PolarRootTree::PolarRootTree(ImageShape* shape, double d) :
		PolarTree(0, TWO_PI, 0, d),rootDStamp(false),scale(1)
#if NUM_THREADS>1
,finalSeq(-1)
#endif
{
    
            for(int i=0;i<NUM_THREADS;i++){
                this->rootStamp[i] = 1;
                this->rootX[i] = this->rootY[i] = NAN;
                this->_rotation[i] = NAN;
            }
	this->shape = shape;
//    this->getKids();

}

PolarRootTree::~PolarRootTree() {
}



inline double PolarRootTree::getRootX(int seq) {
    assert(!isnan(this->rootX[seq]));
	return this->rootX[seq];
}

inline double PolarRootTree::getRootY(int seq) {
    assert(!isnan(this->rootY[seq]));
	return this->rootY[seq];
}



inline double PolarRootTree::computeX(int seq,bool rotate) {
	return -(this->getD2(rotate));
}

inline double PolarRootTree::computeY(int seq,bool rotate) {
//#ifdef FLIP
	return -(this->getD2(rotate));
//#else
//    return this->d2;
//#endif
}

inline double PolarRootTree::computeRight(int seq,bool rotate) {
	return this->getD2(rotate);
}

inline double PolarRootTree::computeBottom(int seq,bool rotate) {
//#ifdef FLIP
	return this->getD2(rotate);
//#else
//    return -(this->d2);
//#endif
}

void PolarRootTree::updateFourPointsWithRotationScale(int seq){
    double d2 = this->getD2(true);
    _x[seq] = _y[seq] = -d2;
    _right[seq] = _bottom[seq] = d2;

}

inline int PolarRootTree::getCurrentStamp(int seq) {
	return this->rootStamp[seq];
}


inline ImageShape* PolarRootTree::getShape() {
	return this->shape;
}

