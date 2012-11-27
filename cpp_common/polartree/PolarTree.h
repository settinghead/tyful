#ifndef PolarTree_H
#define PolarTree_H

#include <vector>
#include "constants.h"
#include "structs.h"
#include "ImageShape.h"
using namespace std;



class PolarRootTree;
class ImageShape;
struct CartisianPoint;


enum SplitType {
	_3RAYS, _2RAYS1CUT, _1RAY1CUT, _1RAY2CUTS, _3CUTS
};
class PolarTree {
public:
    double d1,d2;
	PolarTree(double r1, double r2, double d1, double d2, int minBoxSize);
	virtual ~PolarTree();
	inline void addKids(vector<PolarTree*>* kidList);
	inline virtual int getRootX() = 0;
	inline virtual int getRootY() = 0;
	inline virtual bool overlaps(PolarTree* otherTree){
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
	inline vector<PolarTree*>* getKids();
	inline vector<PolarTree*>* getKidsNoGrowth(){
        return this->_kids;
    }
	inline virtual PolarRootTree* getRoot() = 0;
	inline virtual int getMinBoxSize() = 0;
	inline virtual ImageShape* getShape() = 0;
	inline bool overlapsCoord(double x, double y, double right, double bottom){
        if ((this->rectCollideCoord(x, y, right, bottom))) {
            if ((this->isLeaf())) {
                return true;
            } else {
                vector<PolarTree*>* tKids = this->getKids();
                for (vector<PolarTree*>::iterator myKid = tKids->begin();
                     myKid != tKids->end(); ++myKid) {
                    if (((*myKid)->overlapsCoord(x, y, right, bottom))) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
	inline bool contains(double x, double y, double right, double bottom);
    inline CartisianPoint getTopLeftLocation(){
        CartisianPoint p;
        p.x = getRootX()-getShape()->getWidth()/2;
        p.y = getRootY()-getShape()->getHeight()/2;
        return p;
    }
	inline virtual double computeX(bool rotate) = 0;
	inline virtual double computeY(bool rotate) = 0;
	inline virtual double computeRight(bool rotate) = 0;
	inline virtual double computeBottom(bool rotate) = 0;
	inline double getR1(bool rotate){
        if ((rotate)) {
            this->checkRecompute();
            return this->_computedR1;
        } else {
            return this->_r1;
        }
    }
	inline double getR2(bool rotate){
        if ((rotate)) {
            this->checkRecompute();
            return this->_computedR2;
        } else {
            return this->_r2;
        }
    }
	inline void checkRecompute(){
        if (((this->rStamp != this->getCurrentStamp()))) {
			this->computeR1();
			this->computeR2();
			this->rStamp = this->getCurrentStamp();
		}
    }
	inline void computeR1(){
        this->_computedR1 = (this->_r1 + this->getRotation());
		if (((this->_computedR1 > TWO_PI ))) {
			this->_computedR1 -= TWO_PI;
		}
        else if(this->_computedR1<0)
            this->_computedR1 += TWO_PI;
    }
	inline void computeR2(){
        this->_computedR2 = (this->_r2 + this->getRotation());
		if (((this->_computedR2 > TWO_PI)))
			this->_computedR2 -= TWO_PI;
        else if(this->_computedR2<0)
            this->_computedR2 += TWO_PI;
    }
	inline void checkUpdatePoints(){
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
	inline double px(){
        this->checkUpdatePoints();
        return this->_px;
    }
	inline double py(){
        this->checkUpdatePoints();
        return this->_py;
    }
	inline double pright(){
        this->checkUpdatePoints();
        return this->_pright;
    }
	inline double pbottom(){
        this->checkUpdatePoints();
        return this->_pbottom;
    }
	inline bool isLeaf(){
        return this->_leaf;
    }
	int swelling;
	inline void swell(int extra);
	inline double getWidth(bool rotate);
	inline double getHeight(bool rotate);
	inline void checkComputeX(){
        if (((this->xStamp != this->getCurrentStamp()))) {
			this->_x = this->computeX(true);
			this->xStamp = this->getCurrentStamp();
		}
    }
	inline void checkComputeY(){
        if (((this->yStamp != this->getCurrentStamp()))) {
			this->_y = this->computeY(true);
			this->yStamp = this->getCurrentStamp();
		}
    }
	inline void checkComputeRight(){
        if (((this->rightStamp != this->getCurrentStamp()))) {
			this->_right = this->computeRight(true);
			this->rightStamp = this->getCurrentStamp();
		}
    }
	inline void checkComputeBottom(){
        if (((this->bottomStamp != this->getCurrentStamp()))) {
			this->_bottom = this->computeBottom(true);
			this->bottomStamp = this->getCurrentStamp();
		}
    }
	inline double getRelativeX(){
        if ((isnan(this->_relativeX))) {
            this->_relativeX = this->computeX(false);
        }
        return this->_relativeX;
    }
	inline double getRelativeY(){
        if ((isnan(this->_relativeY))) {
            this->_relativeY = this->computeY(false);
        }
        return this->_relativeY;
    }
	inline double getRelativeRight(){
        if ((isnan(this->_relativeRight))) {
            this->_relativeRight = this->computeRight(false);
        }
        return this->_relativeRight;
    }
	inline double getRelativeBottom(){
        if ((isnan(this->_relativeBottom))) {
            this->_relativeBottom = this->computeBottom(false);
        }
        return this->_relativeBottom;
        
    }
	inline double getX(bool rotate){
        if ((rotate)) {
            this->checkComputeX();
            return (this->_x - MARGIN);
        } else {
            return this->getRelativeX();
        }
    }
	inline double getY(bool rotate){
        if ((rotate)) {
            this->checkComputeY();
            return (this->_y - MARGIN);
        } else {
            return this->getRelativeY();
        }
    }
	inline double getRight(bool rotate){
        if ((rotate)) {
            this->checkComputeRight();
            return (this->_right + MARGIN);
        } else {
            return this->getRelativeRight();
        }
    }
	inline double getBottom(bool rotate){
        if ((rotate)) {
            this->checkComputeBottom();
            return (this->_bottom + MARGIN);
        }
        return this->getRelativeBottom();
    }
	virtual double getRotation() = 0;
	virtual int getCurrentStamp() = 0;
	inline void setLeaf(bool b);
protected:
    int rStamp;
	double _x, _y, _right, _bottom, _r1, _r2;
	vector<PolarTree*>* _kids;
	double _computedR1;
	double _computedR2;
	double pointsStamp;
	double _px, _py, _pright, _pbottom;
	double xStamp, yStamp, rightStamp, bottomStamp;
	bool _leaf;
	double _relativeX, _relativeY, _relativeRight, _relativeBottom;
    inline bool collide(PolarTree* bTree){
        double dist = sqrt(
                           (pow((this->getRootX() - bTree->getRootX()), 2)
                            + pow((this->getRootY() - bTree->getRootY()), 2)));
        if (((dist > (this->d2 + bTree->d2)))) {
            return false;
        } else {
            return this->rectCollide(bTree);
        }
    }
	inline bool rectCollide(PolarTree* bTree){
        return this->rectCollideCoord(bTree->px(), bTree->py(), bTree->pright(),
                                      bTree->pbottom());
    }
	inline bool rectContain(double x, double y, double right, double bottom);
	inline bool rectCollideCoord(double x, double y, double right,
                                 double bottom){
        //#ifdef FLIP
        return this->pbottom() > y
        && this->py() < bottom
        && this->pright() > x
        && this->px() < right;
        //#else
        //    return this->pbottom() < y
        //    && this->py() > bottom
        //    && this->pright() > x
        //    && this->px() < right;
        //#endif
    }
};
#endif
