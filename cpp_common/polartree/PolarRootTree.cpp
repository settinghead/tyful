#include "PolarTree.h"
#include "PolarRootTree.h"
#include "ImageShape.h"
#include <math.h>
#include "Flip.h"

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
    this->getKids();

}

PolarRootTree::~PolarRootTree() {
}



int PolarRootTree::getRootX() {
	return this->rootX;
}

int PolarRootTree::getRootY() {
	return this->rootY;
}

double PolarRootTree::computeX(bool rotate) {
	return -(this->d2);
}

double PolarRootTree::computeY(bool rotate) {
//#ifdef FLIP
	return -(this->d2);
//#else
//    return this->d2;
//#endif
}

double PolarRootTree::computeRight(bool rotate) {
	return this->d2;
}

double PolarRootTree::computeBottom(bool rotate) {
//#ifdef FLIP
	return this->d2;
//#else
//    return -(this->d2);
//#endif
}

double PolarRootTree::getRotation() {
	return this->_rotation;
}

int PolarRootTree::getCurrentStamp() {
	return this->rootStamp;
}

PolarRootTree* PolarRootTree::getRoot() {
	return this;
}

int PolarRootTree::getMinBoxSize() {
	return this->_minBoxSize;
}

ImageShape* PolarRootTree::getShape() {
	return this->shape;
}

