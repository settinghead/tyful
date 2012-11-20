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
	inline virtual bool overlaps(PolarTree* otherTree);
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
	inline void checkUpdatePoints();
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
	inline void checkComputeX();
	inline void checkComputeY();
	inline void checkComputeRight();
	inline void checkComputeBottom();
	inline double getRelativeX();
	inline double getRelativeY();
	inline double getRelativeRight();
	inline double getRelativeBottom();
	inline double getX(bool rotate);
	inline double getY(bool rotate);
	inline double getRight(bool rotate);
	inline double getBottom(bool rotate);
	inline virtual double getRotation() = 0;
	inline virtual int getCurrentStamp() = 0;
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
    inline bool collide(PolarTree* bTree);
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
