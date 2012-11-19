#include "PolarTree.h"
#include "PolarRootTree.h"
#include "ImageShape.h"
#include <math.h>
#include "Flip.h"

PolarRootTree::PolarRootTree(ImageShape* shape, int centerX,
		int centerY, double d, int minBoxSize) :
		PolarTree(0, TWO_PI, 0, d, minBoxSize) {
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

void PolarRootTree::setLocation(int centerX, int centerY) {
	this->rootX = centerX;
	this->rootY = centerY;
	(this->rootStamp)++;
}

void PolarRootTree::setTopLeftLocation(int top, int left, bool scale) {
	this->rootX = this->shape->getWidth()/2 * (scale?_scale:1) + top;
	this->rootY = this->shape->getHeight()/2 * (scale?_scale:1) + left;
	(this->rootStamp)++;
}

int PolarRootTree::getRootX() {
	return this->rootX;
}

int PolarRootTree::getRootY() {
	return this->rootY;
}

double PolarRootTree::computeX(bool rotate) {
    return -this->getD2(rotate);
}

double PolarRootTree::computeY(bool rotate) {
    return -this->getD2(rotate);

}

double PolarRootTree::computeRight(bool rotate) {
    return this->getD2(rotate);

}

double PolarRootTree::computeBottom(bool rotate) {
    return this->getD2(rotate);
}

void PolarRootTree::setRotation(double rotation) {
	this->_rotation = fmod(rotation, TWO_PI);
	if (this->_rotation < 0) {
		this->_rotation = (TWO_PI + this->_rotation);
	}
	(this->rootStamp)++;
}

void PolarRootTree::setScale(double scale) {
	this->_scale = scale;
	(this->rootStamp)++;
}

inline double PolarRootTree::getRotation() {
	return this->_rotation;
}

inline double PolarRootTree::getScale() {
	return this->_scale;
}

inline int PolarRootTree::getCurrentStamp() {
	return this->rootStamp;
}

inline PolarRootTree* PolarRootTree::getRoot() {
	return this;
}

int PolarRootTree::getMinBoxSize() {
	return this->_minBoxSize;
}

ImageShape* PolarRootTree::getShape() {
	return this->shape;
}

