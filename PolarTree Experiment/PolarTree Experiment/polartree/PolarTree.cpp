#include <math.h>
#include <vector>
#include "PolarChildTree.h"
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "ImageShape.h"

PolarTree::PolarTree(double r1, double r2, double d1, double d2,
		int minBoxSize) {

	this->_computedR1 = NAN;
	this->_computedR2 = NAN;
	this->swelling = (int) 0;
	this->_leaf = false;
	this->_r1 = r1;
	this->_r2 = r2;
	this->d1 = d1;
	this->d2 = d2;
	this->_relativeX = NAN;
	this->_relativeY = NAN;
	this->_relativeRight = NAN;
	this->_relativeBottom = NAN;
	double r = (r2 - r1);
	double d = (double(((PI * ((d1 + d2))) * r))
			/ double(TWO_PI));
	bool tooSmallToContinue = (bool((d <= minBoxSize))
			|| bool(((d2 - d1) <= minBoxSize)));
	if ((tooSmallToContinue)) {
		this->setLeaf(true);
	}
}

PolarTree::~PolarTree() {
	delete _kids;
}

void PolarTree::addKids(vector<PolarChildTree*>* kidList) {
	{
		this->_kids = kidList;
	}
}

bool PolarTree::overlaps(PolarTree* otherTree) {
	if ((this->collide(otherTree))) {
		if (((bool(this->isLeaf()) && bool(otherTree->isLeaf())))) {
			return true;
		} else {
			if ((this->isLeaf())) {
				vector<PolarChildTree*>* oKids = otherTree->getKids();
				for (vector<PolarChildTree*>::iterator it = oKids->begin();
						it != oKids->end(); ++it) {
					if ((this->overlaps(*it)))
						return true;
				}
			} else {
				vector<PolarChildTree*>* tKids = this->getKids();

				for (vector<PolarChildTree*>::iterator it = tKids->begin();
						it != tKids->end(); ++it) {
					if ((otherTree->overlaps(*it)))
						return true;
				}

			}
		}
	}
	return false;
}

vector<PolarChildTree*>* PolarTree::getKids() {
	if (!this->isLeaf() && this->_kids == NULL) {
		makeChildren(this, this->getShape(), this->getMinBoxSize(),
				this->getRoot());
	}
	return this->_kids;
}

vector<PolarChildTree*>* PolarTree::getKidsNoGrowth() {
	return this->_kids;
}

bool PolarTree::overlapsCoord(double x, double y, double right,
		double bottom) {
	if ((this->rectCollideCoord(x, y, right, bottom))) {
		if ((this->isLeaf())) {
			return true;
		} else {
			vector<PolarChildTree*>* tKids = this->getKids();
			for (vector<PolarChildTree*>::iterator myKid = tKids->begin();
					myKid != tKids->end(); ++myKid) {
				if (((*myKid)->overlapsCoord(x, y, right, bottom))) {
					return true;
				}
			}
		}
	}
	return false;
}

bool PolarTree::contains(double x, double y, double right, double bottom) {
	if ((this->rectContain(x, y, right, bottom))) {
		if ((this->isLeaf())) {
			return true;
		} else {
			{
				vector<PolarChildTree*>* tKids = this->getKids();
				for (vector<PolarChildTree*>::iterator myKid =
						tKids->begin(); myKid != tKids->end(); ++myKid) {
					if (((*myKid)->contains(x, y, right, bottom))) {
						return true;
					}
				}
			}
			return false;
		}
	} else {
		return false;
	}
	return false;
}

double PolarTree::getR1(bool rotate) {
	if ((rotate)) {
		this->checkRecompute();
		return this->_computedR1;
	} else {
		return this->_r1;
	}
	return 0.;
}

double PolarTree::getR2(bool rotate) {
	if ((rotate)) {
		this->checkRecompute();
		return this->_computedR2;
	} else {
		return this->_r2;
	}
	return 0.;
}

void PolarTree::checkRecompute() {
	{
		if (((this->rStamp != this->getCurrentStamp()))) {
			this->computeR1();
			this->computeR2();
			this->rStamp = this->getCurrentStamp();
		}
	}
}

void PolarTree::computeR1() {
	{
		this->_computedR1 = (this->_r1 + this->getRotation());
		if (((this->_computedR1 > TWO_PI))) {
			this->_computedR1 = fmod(this->_computedR1, TWO_PI);
		}
	}
}

void PolarTree::computeR2() {
	{
		this->_computedR2 = (this->_r2 + this->getRotation());
		if (((this->_computedR2 > TWO_PI))) {
			this->_computedR2 = fmod(this->_computedR2, TWO_PI);
		}
	}
}

void PolarTree::checkUpdatePoints() {
	{
		if (((this->pointsStamp != this->getCurrentStamp()))) {
			this->_px =
					((this->getRootX() - this->swelling) + this->getX(true));
			this->_py =
					((this->getRootY() - this->swelling) + this->getY(true));
			this->_pright = ((this->getRootX() + this->swelling)
					+ this->getRight(true));
			this->_pbottom = ((this->getRootY() + this->swelling)
					+ this->getBottom(true));
			this->pointsStamp = this->getCurrentStamp();
		}
	}
}

double PolarTree::px() {
	this->checkUpdatePoints();
	return this->_px;
}

double PolarTree::py() {
	this->checkUpdatePoints();
	return this->_py;
}

double PolarTree::pright() {
	this->checkUpdatePoints();
	return this->_pright;
}

double PolarTree::pbottom() {
	this->checkUpdatePoints();
	return this->_pbottom;
}

bool PolarTree::collide(PolarTree* bTree) {
	double dist = sqrt(
			(pow((this->getRootX() - bTree->getRootX()), (int) 2)
					+ pow((this->getRootY() - bTree->getRootY()), (int) 2)));
	if (((dist > (this->d2 + bTree->d2)))) {
		return false;
	} else {
		return this->rectCollide(bTree);
	}
	return false;
}

bool PolarTree::rectCollide(PolarTree* bTree) {
	return this->rectCollideCoord(bTree->px(), bTree->py(), bTree->pright(),
			bTree->pbottom());
}

bool PolarTree::rectContain(double x, double y, double right,
		double bottom) {
	return (bool(
			(bool((bool((this->px() <= x)) && bool((this->py() <= y))))
					&& bool((this->pright() >= right))))
			&& bool((this->pbottom() >= bottom)));
}

bool PolarTree::rectCollideCoord(double x, double y, double right,
		double bottom) {
	return this->pbottom() > y
        && this->py() < bottom
        && this->pright() > x
        && this->px() < right;
}

bool PolarTree::isLeaf() {
	return this->_leaf;
}

void PolarTree::swell(int extra) {
	{
		this->swelling += extra;
		if (!this->isLeaf()) {

			vector<PolarChildTree*>* tKids = this->getKids();
			for (vector<PolarChildTree*>::iterator myKid = tKids->begin();
					myKid != tKids->end(); ++myKid) {
				(*myKid)->swell(extra);
			}

		}
	}
}

double PolarTree::getWidth(bool rotate) {
	return (this->getRight(rotate) - this->getX(rotate));
}

double PolarTree::getHeight(bool rotate) {
	return (this->getBottom(rotate) - this->getY(rotate));
}

void PolarTree::checkComputeX() {
	{
		if (((this->xStamp != this->getCurrentStamp()))) {
			this->_x = this->computeX(true);
			this->xStamp = this->getCurrentStamp();
		}
	}
}

void PolarTree::checkComputeY() {
	{
		if (((this->yStamp != this->getCurrentStamp()))) {
			this->_y = this->computeY(true);
			this->yStamp = this->getCurrentStamp();
		}
	}
}

void PolarTree::checkComputeRight() {
	{
		if (((this->rightStamp != this->getCurrentStamp()))) {
			this->_right = this->computeRight(true);
			this->rightStamp = this->getCurrentStamp();
		}
	}
}

void PolarTree::checkComputeBottom() {
	{
		if (((this->bottomStamp != this->getCurrentStamp()))) {
			this->_bottom = this->computeBottom(true);
			this->bottomStamp = this->getCurrentStamp();
		}
	}
}

double PolarTree::getRelativeX() {
	if ((isnan(this->_relativeX))) {
		this->_relativeX = this->computeX(false);
	}
	return this->_relativeX;
}

double PolarTree::getRelativeY() {
	if ((isnan(this->_relativeY))) {
		this->_relativeY = this->computeY(false);
	}
	return this->_relativeY;
}

double PolarTree::getRelativeRight() {
	if ((isnan(this->_relativeRight))) {
		this->_relativeRight = this->computeRight(false);
	}
	return this->_relativeRight;
}

double PolarTree::getRelativeBottom() {
	if ((isnan(this->_relativeBottom))) {
		this->_relativeBottom = this->computeBottom(false);
	}
	return this->_relativeBottom;
}

double PolarTree::getX(bool rotate) {
	if ((rotate)) {
		this->checkComputeX();
		return (this->_x - MARGIN);
	} else {
		return this->getRelativeX();
	}
	return 0.;
}

double PolarTree::getY(bool rotate) {
	if ((rotate)) {
		this->checkComputeY();
		return (this->_y - MARGIN);
	} else {
		return this->getRelativeY();
	}
	return 0.;
}

double PolarTree::getRight(bool rotate) {
	if ((rotate)) {
		this->checkComputeRight();
		return (this->_right + MARGIN);
	} else {
		return this->getRelativeRight();
	}
	return 0.;
}

double PolarTree::getBottom(bool rotate) {
	if ((rotate)) {
		this->checkComputeBottom();
		return (this->_bottom + MARGIN);
	}
	return this->getRelativeBottom();
}

void PolarTree::setLeaf(bool b) {
	this->_leaf = b;
}

//char* PolarTree::toString() {
//	int indent = 0;
//	{
//		::String indentStr = HX_CSTRING("");
//		int i = (int) 0;
//		while (((i < indent))) {
//			hx::AddEq(indentStr, HX_CSTRING(" "));
//			(i)++;
//		}
//		::String childrenStr = HX_CSTRING("");
//		vector < PolarChildTree > kids = this->getKids();
//		if (((kids != null()))) {
//			int _g = (int) 0;
//			while (((_g < kids->length))) {
//				PolarChildTree k = kids->__get(_g);
//				++(_g);
//				if (((k != null()))) {
//					hx::AddEq(childrenStr, k->toString((indent + (int) 1)));
//				}
//			}
//		}
//		return ((((((((((indentStr + HX_CSTRING("R1: ")) + this->getR1(false))
//				+ HX_CSTRING(", R2: ")) + this->getR2(false))
//				+ HX_CSTRING(", D1: ")) + this->d1) + HX_CSTRING(", D2: "))
//				+ this->d2) + HX_CSTRING("\r\n")) + childrenStr);
//	}
//}
