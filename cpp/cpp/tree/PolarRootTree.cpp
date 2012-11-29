#include "PolarTree.h"
#include "PolarRootTree.h"
#include "../model/ImageShape.h"
#include <math.h>
#include "../model/Flip.h"

PolarRootTree::PolarRootTree(ImageShape* shape, int centerX,
		int centerY, double d, int minBoxSize) :
		PolarTree(0, TWO_PI, 0, d, minBoxSize),_rotation(0) {
	this->_rotation = 0;
	this->rootStamp = 0;
	this->rootX = centerX;
	this->rootY = centerY;
	this->shape = shape;
	this->_minBoxSize = minBoxSize;
	this->rootStamp++;
//    this->getKids();

}

PolarRootTree::~PolarRootTree() {
}



inline int PolarRootTree::getRootX() {
	return this->rootX;
}

inline int PolarRootTree::getRootY() {
	return this->rootY;
}

inline double PolarRootTree::computeX(bool rotate) {
	return -(this->d2);
}

inline double PolarRootTree::computeY(bool rotate) {
//#ifdef FLIP
	return -(this->d2);
//#else
//    return this->d2;
//#endif
}

inline double PolarRootTree::computeRight(bool rotate) {
	return this->d2;
}

inline double PolarRootTree::computeBottom(bool rotate) {
//#ifdef FLIP
	return this->d2;
//#else
//    return -(this->d2);
//#endif
}

inline double PolarRootTree::getRotation() {
	return this->_rotation;
}

inline int PolarRootTree::getCurrentStamp() {
	return this->rootStamp;
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

