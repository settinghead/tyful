#include "PolarTree.h"
#include "PolarRootTree.h"
#include "../model/PixelImageShape.h"
#include <math.h>
#include "../model/Flip.h"

PolarRootTree::PolarRootTree( unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb) :
PixelImageShape(pixels,width,height,revert,rgbaToArgb),
PolarTree(0, TWO_PI, 0, sqrt(
                             (pow((double(getWidth()) / 2.0), 2.0)
                              + pow((double(getHeight()) / 2.0), 2.0)))),rootDStamp(false),scale(1)
#if NUM_THREADS>1
,finalSeq(-1)
#endif
{
    init();
}

PolarRootTree::PolarRootTree(unsigned char * png, size_t size):
PixelImageShape(png,size),
PolarTree(0, TWO_PI, 0, sqrt(
                             (pow((double(getWidth()) / 2.0), 2.0)
                              + pow((double(getHeight()) / 2.0), 2.0)))),rootDStamp(false),scale(1)
#if NUM_THREADS>1
,finalSeq(-1)
#endif
{
    init();
}

void PolarRootTree::init(){
    for(int i=0;i<NUM_THREADS;i++){
        this->rootStamp[i] = 1;
        this->currentPlacement[i].location = CartisianPoint(NAN,NAN);
        this->currentPlacement[i].rotation = NAN;
    }
}

PolarRootTree::~PolarRootTree() {
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




