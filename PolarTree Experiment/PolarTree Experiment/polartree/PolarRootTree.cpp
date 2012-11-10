#include "PolarTree.h"
#include "PolarRootTree.h"
#include "ImageShape.h"
#include <math.h>

PolarRootTree::PolarRootTree(ImageShape* shape, int centerX,
		int centerY, double d, int minBoxSize) :
		PolarTree((int) 0, TWO_PI, (int) 0, d, minBoxSize) {
	this->_rotation = (int) 0;
	this->rootStamp = (int) 0;
	this->rootX = centerX;
	this->rootY = centerY;
	this->shape = shape;
	this->_minBoxSize = minBoxSize;
	(this->rootStamp)++;
            this->getKids();

}

PolarRootTree::~PolarRootTree() {
}

void PolarRootTree::setLocation(int centerX, int centerY) {
	this->rootX = centerX;
	this->rootY = centerY;
	(this->rootStamp)++;
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
	return -(this->d2);
}

double PolarRootTree::computeRight(bool rotate) {
	return this->d2;
}

double PolarRootTree::computeBottom(bool rotate) {
	return this->d2;
}

void PolarRootTree::setRotation(double rotation) {
	this->_rotation = fmod(rotation, TWO_PI);
	if (this->_rotation < 0) {
		this->_rotation = (TWO_PI + this->_rotation);
	}
	(this->rootStamp)++;
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

