#include <math.h>
#include <vector>
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "../model/ImageShape.h"
#include "../model/Flip.h"
#include "../model/PolarCanvas.h"

PolarTree::PolarTree(double r1, double r2, double d1, double d2,
                     int minBoxSize):swelling(0),
_kids(NULL),_leaf(false),_r1(r1),_r2(r2),d1(d1),d2(d2),
_relativeX(NAN),_relativeY(NAN),_relativeRight(NAN),_relativeBottom(NAN),finalSeq(-1){
    for(int i=0;i<NUM_THREADS;i++){
        _computedR1[i] =_computedR2[i] = NAN;
    }
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

inline void PolarTree::addKids(vector<PolarTree*>* kidList) {
	{
		this->_kids = kidList;
	}
}


inline vector<PolarTree*>* PolarTree::getKids() {
	if (!this->isLeaf() && this->_kids == NULL) {
		makeChildren(this, this->getShape(), this->getMinBoxSize(),
				this->getRoot());
//        vector<PolarTree*>* tKids = this->getKids();
//        for (vector<PolarTree*>::iterator myKid = tKids->begin();
//             myKid != tKids->end(); ++myKid) {
//            (*myKid)->getKids();
//        }
	}
	return this->_kids;
}


inline bool PolarTree::contains(int seq,double x, double y, double right, double bottom) {
	if ((this->rectContain(seq,x, y, right, bottom))) {
		if ((this->isLeaf())) {
			return true;
		} else {
			{
				vector<PolarTree*>* tKids = this->getKids();
				for (vector<PolarTree*>::iterator myKid =
						tKids->begin(); myKid != tKids->end(); ++myKid) {
					if (((*myKid)->contains(seq,x, y, right, bottom))) {
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




inline bool PolarTree::rectContain(int seq,double x, double y, double right,
		double bottom) {
	return this->px(seq) <= x && this->py(seq) <= y
					&& this->pright(seq) >= right
			&& this->pbottom(seq) >= bottom;
}

inline void PolarTree::swell(int extra) {
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

inline double PolarTree::getWidth() {
	return (this->getRight(-1,false) - this->getX(-1,false));
}

inline double PolarTree::getHeight() {
	return (this->getBottom(-1,false) - this->getY(-1,false));
}

inline void PolarTree::setLeaf(bool b) {
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

