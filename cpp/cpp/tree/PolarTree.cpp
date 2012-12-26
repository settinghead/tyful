#include <math.h>
#include <vector>
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "../model/ImageShape.h"
#include "../model/Flip.h"
#include "../model/PolarCanvas.h"

PolarTree::PolarTree(double r1, double r2, double d1, double d2
                     ):swelling(0),
_kids(NULL),_leaf(false),_r1(r1),_r2(r2),_d1(d1),_d2(d2),_computedD1(d1),_computedD2(d2),
_relativeX(NAN),_relativeY(NAN),_relativeRight(NAN),_relativeBottom(NAN),dStamp(false){
    pthread_mutex_init(&lock, NULL);
    for(int i=0;i<NUM_THREADS;i++){
        _computedR1[i] =_computedR2[i] = NAN;
        xStamp[i] = yStamp[i] = rightStamp[i] = bottomStamp[i] = pointsStamp[i] = rStamp[i] = -1;
    }
	double r = (r2 - r1);
	double d = PI * (d1 + d2) * r
			/ TWO_PI;
	bool tooSmallToContinue = d <= MIN_BOX_SIZE
			|| (d2 - d1) <= MIN_BOX_SIZE;
	if ((tooSmallToContinue)) {
		this->setLeaf(true);
	}
}

PolarTree::~PolarTree() {
    if(_kids!=NULL)
        for(int i=0;i<_kids->size();i++)
            delete(_kids->at(i));
	delete _kids;
    pthread_mutex_destroy(&lock);

}

inline void PolarTree::addKids(vector<PolarTree*>* kidList) {
		this->_kids = kidList;
}


vector<PolarTree*>* PolarTree::getKids() {
    pthread_mutex_lock(&lock);
	if (!this->isLeaf() && this->_kids == NULL) {
		makeChildren();

//        vector<PolarTree*>* tKids = this->getKids();
//        for (vector<PolarTree*>::iterator myKid = tKids->begin();
//             myKid != tKids->end(); ++myKid) {
//            (*myKid)->getKids();
//        }
	}
    pthread_mutex_unlock(&lock);
	return this->_kids;
}
inline void PolarTree::checkUpdatePoints(int seq){
    if (((this->pointsStamp[seq] != this->getCurrentStamp(seq)))) {
        CartisianPoint rootLoc = this->getRoot()->currentPlacement[seq].location;
        this->_px[seq] =
        ((rootLoc.x - this->swelling) + this->getX(seq,true));
        this->_pright[seq] = ((rootLoc.x + this->swelling)
                              + this->getRight(seq,true));
        this->_py[seq] = ((rootLoc.y - this->swelling) + this->getY(seq,true));
        this->_pbottom[seq] = ((rootLoc.y + this->swelling)
                               + this->getBottom(seq,true));
        this->pointsStamp[seq] = this->getCurrentStamp(seq);
    }
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

inline double PolarTree::getTreeWidth() {
	return (this->getRight(-1,false) - this->getX(-1,false));
}

inline double PolarTree::getTreeHeight() {
	return (this->getBottom(-1,false) - this->getY(-1,false));
}

inline void PolarTree::setLeaf(bool b) {
	this->_leaf = b;
}

inline PolarTree* PolarTree::makeChildTree(double r1, double r2, double d1, double d2)
{
    PolarChildTree* tree = new PolarChildTree(r1, r2, d1, d2, getRoot());
    double x = (getX(-1,false)
                + getRoot()->getWidth()/2);
    if (((x > getRoot()->getWidth()))) {
        delete tree;
        return NULL;
    } else {
        double y = (getY(-1,false)
                    + getRoot()->getHeight()/2);
        if (((y > getRoot()->getHeight()))) {
            delete tree;
            return NULL;
        } else {
            double width = (getRight(-1,false) - getX(-1,false));
            if ((((x + width) < 0))) {
                delete tree;
                tree = NULL;
            } else {
                //#ifdef FLIP
                double height = getBottom(-1,false) - getY(-1,false);
                //#else
                //                    double height =  getY(false) - getBottom(false);
                //#endif
                if ((((y + height) < 0))) {
                    delete tree;
                    return NULL;
                } else {
                    assert(width > 0);
                    assert(height > 0);
                    if (((getRoot()->contains(x, y, width, height)))) {
                    } else {
                        if (getRoot()->intersects(x, y, width, height)) {
                        } else {
                            delete tree;
                            return NULL;
                        }
                    }
                }
            }
        }
    }
    return tree;
}

inline vector<PolarTree*>* PolarTree::splitTree(SplitType type) {
    vector<PolarTree*>* result = new vector<PolarTree*>();
    PolarTree* re;
    double r;
    double r1;
    double r2;
    double r3;
    double r4;
    double r5;
    double d;
    double d1;
    double d2;
    double d3;
    double d4;
    double d5;
    switch (type) {
        case _3RAYS: {
            r = (double(((getR2(-1,false) - getR1(-1,false))))
                 / double((int) 4));
            r1 = getR1(-1,false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = (r3 + r);
            r5 = getR2(-1,false);
            assert(
                   ((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4)))
                    && bool((r4 < r5))));
            re = makeChildTree(r1, r2, getD1(false), getD2(false));
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r2, r3, getD1(false), getD2(false));
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r3, r4, getD1(false), getD2(false));
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r4, r5, getD1(false), getD2(false));
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _2RAYS1CUT: {
            r = (double(((getR2(-1,false) - getR1(-1,false))))
                 / double((int) 3));
            r1 = getR1(-1,false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = getR2(-1,false);
            d1 = getD1(false);
            d2 = (getD1(false) + (double(((getD2(false) - getD1(false)))) / double((int) 2)));
            d3 = getD2(false);
            assert((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4))));
            re = makeChildTree(r1, r4, d1, d2);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r2, r3, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r3, r4, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY1CUT: {
            r = (double(((getR2(-1,false) - getR1(-1,false))))
                 / double((int) 2));
            r1 = getR1(-1,false);
            r2 = (r1 + r);
            r3 = getR2(-1,false);
            d = (double(((getD2(false) - getD1(false)))) / double((int) 2));
            d1 = getD1(false);
            d2 = (d1 + d);
            d3 = getD2(false);
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(r1, r2, d1, d2);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r2, r3, d1, d2);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r2, r3, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY2CUTS: {
            r = (double(((getR2(-1,false) - getR1(-1,false))))
                 / double((int) 2));
            r1 = getR1(-1,false);
            r2 = (r1 + r);
            r3 = getR2(-1,false);
            d = (double(((getD2(false) - getD1(false)))) / double((int) 3));
            d1 = getD1(false);
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = getD2(false);
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(r1, r3, d1, d2);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r3, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d3, d4);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r2, r3, d3, d4);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _3CUTS: {
            r1 = getR1(-1,false);
            r2 = getR2(-1,false);
            d = (double(((getD2(false) - getD1(false)))) / double((int) 4));
            d1 = getD1(false);
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = (d3 + d);
            d5 = getD2(false);
            assert(r1 < r2);
            re = makeChildTree(r1, r2, d1, d2);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d2, d3);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d3, d4);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(r1, r2, d4, d5);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
    }
    return result;
}


double PolarTree::getR1(bool rotate){
    return getR1(getRoot()->winningSeq, rotate);
}
double PolarTree::getR2(bool rotate){
    return getR2(getRoot()->winningSeq, rotate);
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

