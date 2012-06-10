#include "BBPolarRootTreeVO.h"
#include "BBPolarTreeVO.h"
#include "IImageShape.h"
#include <math.h>
namespace polartree {

BBPolarRootTreeVO::BBPolarRootTreeVO(IImageShape* shape, int centerX,
		int centerY, double d, int minBoxSize) :
		BBPolarTreeVO((int) 0, BBPolarTreeVO::TWO_PI, (int) 0, d, minBoxSize) {
	this->_rotation = (int) 0;
	this->rootStamp = (int) 0;
	this->rootX = centerX;
	this->rootY = centerY;
	this->shape = shape;
	this->_minBoxSize = minBoxSize;
	(this->rootStamp)++;

}

BBPolarRootTreeVO::~BBPolarRootTreeVO() {
}

void BBPolarRootTreeVO::setLocation(int centerX, int centerY) {
	this->rootX = centerX;
	this->rootY = centerY;
	(this->rootStamp)++;
}

int BBPolarRootTreeVO::getRootX() {
	return this->rootX;
}

int BBPolarRootTreeVO::getRootY() {
	return this->rootY;
}

double BBPolarRootTreeVO::computeX(bool rotate) {
	return -(this->d2);
}

double BBPolarRootTreeVO::computeY(bool rotate) {
	return -(this->d2);
}

double BBPolarRootTreeVO::computeRight(bool rotate) {
	return this->d2;
}

double BBPolarRootTreeVO::computeBottom(bool rotate) {
	return this->d2;
}

void BBPolarRootTreeVO::setRotation(double rotation) {
	this->_rotation = fmod(rotation, BBPolarTreeVO::TWO_PI);
	if (this->_rotation < 0) {
		this->_rotation = (BBPolarTreeVO::TWO_PI + this->_rotation);
	}
	(this->rootStamp)++;
}

double BBPolarRootTreeVO::getRotation() {
	return this->_rotation;
}

int BBPolarRootTreeVO::getCurrentStamp() {
	return this->rootStamp;
}

BBPolarRootTreeVO* BBPolarRootTreeVO::getRoot() {
	return this;
}

int BBPolarRootTreeVO::getMinBoxSize() {
	return this->_minBoxSize;
}

IImageShape* BBPolarRootTreeVO::getShape() {
	return this->shape;
}

} // end namespace polartree
