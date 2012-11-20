#include <math.h>
#include <vector>
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "ImageShape.h"
#include "Flip.h"
#include "PolarCanvas.h"

PolarTree::PolarTree(double r1, double r2, double d1, double d2,
		int minBoxSize) {

	this->_computedR1 = NAN;
	this->_computedR2 = NAN;
	this->swelling = (int) 0;
	this->_kids = NULL;
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

void PolarTree::addKids(vector<PolarTree*>* kidList) {
	{
		this->_kids = kidList;
	}
}

inline bool PolarTree::overlaps(PolarTree* otherTree) {
	if ((this->collide(otherTree))) {
		if (this->isLeaf() && otherTree->isLeaf()) {
			return true;
		} else {
			if ((this->isLeaf())) {
				vector<PolarTree*>* oKids = otherTree->getKids();
				for (vector<PolarTree*>::iterator it = oKids->begin();
						it != oKids->end(); ++it) {
					if ((this->overlaps(*it)))
						return true;
				}
			} else {
				vector<PolarTree*>* tKids = this->getKids();

				for (vector<PolarTree*>::iterator it = tKids->begin();
						it != tKids->end(); ++it) {
					if ((otherTree->overlaps(*it)))
						return true;
				}

			}
		}
	}
	return false;
}

inline vector<PolarTree*>* PolarTree::getKids() {
	if (!this->isLeaf() && this->_kids == NULL) {
		makeChildren(this, this->getShape(), this->getMinBoxSize(),
				this->getRoot());
//        vector<PolarChildTree*>* tKids = this->getKids();
//        for (vector<PolarChildTree*>::iterator myKid = tKids->begin();
//             myKid != tKids->end(); ++myKid) {
//            (*myKid)->getKids();
//        }
	}
	return this->_kids;
}


bool PolarTree::contains(double x, double y, double right, double bottom) {
	if ((this->rectContain(x, y, right, bottom))) {
		if ((this->isLeaf())) {
			return true;
		} else {
			{
				vector<PolarTree*>* tKids = this->getKids();
				for (vector<PolarTree*>::iterator myKid =
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


inline void PolarTree::checkUpdatePoints() {
	{
		if (((this->pointsStamp != this->getCurrentStamp()))) {
			this->_px =
					((this->getRootX() - this->swelling) + this->getX(true));
			this->_pright = ((this->getRootX() + this->swelling)
					+ this->getRight(true));
			this->_py = ((this->getRootY() - this->swelling) + this->getY(true));
			this->_pbottom = ((this->getRootY() + this->swelling)
					+ this->getBottom(true));
			this->pointsStamp = this->getCurrentStamp();
		}
	}
}


inline bool PolarTree::collide(PolarTree* bTree) {
	double dist = sqrt(
			(pow((this->getRootX() - bTree->getRootX()), 2)
					+ pow((this->getRootY() - bTree->getRootY()), 2)));
	if (((dist > (this->d2 + bTree->d2)))) {
		return false;
	} else {
		return this->rectCollide(bTree);
	}
}


bool PolarTree::rectContain(double x, double y, double right,
		double bottom) {
	return (bool(
			(bool((bool((this->px() <= x)) && bool((this->py() <= y))))
					&& bool((this->pright() >= right))))
			&& bool((this->pbottom() >= bottom)));
}

void PolarTree::swell(int extra) {
	{
		this->swelling += extra;
		if (!this->isLeaf()) {

			vector<PolarTree*>* tKids = this->getKids();
			for (vector<PolarTree*>::iterator myKid = tKids->begin();
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

inline void PolarTree::checkComputeX() {
	{
		if (((this->xStamp != this->getCurrentStamp()))) {
			this->_x = this->computeX(true);
			this->xStamp = this->getCurrentStamp();
		}
	}
}

inline void PolarTree::checkComputeY() {
	{
		if (((this->yStamp != this->getCurrentStamp()))) {
			this->_y = this->computeY(true);
			this->yStamp = this->getCurrentStamp();
		}
	}
}

inline void PolarTree::checkComputeRight() {
	{
		if (((this->rightStamp != this->getCurrentStamp()))) {
			this->_right = this->computeRight(true);
			this->rightStamp = this->getCurrentStamp();
		}
	}
}

inline void PolarTree::checkComputeBottom() {
	{
		if (((this->bottomStamp != this->getCurrentStamp()))) {
			this->_bottom = this->computeBottom(true);
			this->bottomStamp = this->getCurrentStamp();
		}
	}
}

inline double PolarTree::getRelativeX() {
	if ((isnan(this->_relativeX))) {
		this->_relativeX = this->computeX(false);
	}
	return this->_relativeX;
}

inline double PolarTree::getRelativeY() {
	if ((isnan(this->_relativeY))) {
		this->_relativeY = this->computeY(false);
	}
	return this->_relativeY;
}

inline double PolarTree::getRelativeRight() {
	if ((isnan(this->_relativeRight))) {
		this->_relativeRight = this->computeRight(false);
	}
	return this->_relativeRight;
}

inline double PolarTree::getRelativeBottom() {
	if ((isnan(this->_relativeBottom))) {
		this->_relativeBottom = this->computeBottom(false);
	}
	return this->_relativeBottom;
}

inline double PolarTree::getX(bool rotate) {
	if ((rotate)) {
		this->checkComputeX();
		return (this->_x - MARGIN);
	} else {
		return this->getRelativeX();
	}
	return 0.;
}

inline double PolarTree::getY(bool rotate) {
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

