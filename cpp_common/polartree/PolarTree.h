#ifndef PolarTree_H
#define PolarTree_H

#include <vector>
#include "constants.h"
#include "structs.h"
#include "ImageShape.h"
using namespace std;



class PolarRootTree;
class PolarChildTree;
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
	inline void addKids(vector<PolarChildTree*>* kidList);
	inline virtual int getRootX() = 0;
	inline virtual int getRootY() = 0;
	inline virtual bool overlaps(PolarTree* otherTree);
	inline vector<PolarChildTree*>* getKids();
	inline vector<PolarChildTree*>* getKidsNoGrowth(){
        return this->_kids;
    }
	inline virtual PolarRootTree* getRoot() = 0;
	inline virtual int getMinBoxSize() = 0;
	inline virtual ImageShape* getShape() = 0;
	inline virtual bool overlapsCoord(double x, double y, double right, double bottom);
	inline virtual bool contains(double x, double y, double right, double bottom);
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
	inline virtual double getR1(bool rotate);
	inline virtual double getR2(bool rotate);
	inline virtual void checkRecompute();
	inline virtual void computeR1();
	inline virtual void computeR2();
	inline virtual void checkUpdatePoints();
	inline virtual double px();
	inline virtual double py();
	inline virtual double pright();
	inline virtual double pbottom();
	inline virtual bool isLeaf();
	int swelling;
	virtual void swell(int extra);
	inline virtual double getWidth(bool rotate);
	inline virtual double getHeight(bool rotate);
	inline virtual void checkComputeX();
	inline virtual void checkComputeY();
	inline virtual void checkComputeRight();
	inline virtual void checkComputeBottom();
	inline virtual double getRelativeX();
	inline virtual double getRelativeY();
	inline virtual double getRelativeRight();
	inline virtual double getRelativeBottom();
	inline virtual double getX(bool rotate);
	inline virtual double getY(bool rotate);
	inline virtual double getRight(bool rotate);
	inline virtual double getBottom(bool rotate);
	inline virtual double getRotation() = 0;
	inline virtual int getCurrentStamp() = 0;
	inline virtual void setLeaf(bool b);
protected:
    int rStamp;
	double _x, _y, _right, _bottom, _r1, _r2;
	vector<PolarChildTree*>* _kids;
	double _computedR1;
	double _computedR2;
	double pointsStamp;
	double _px, _py, _pright, _pbottom;
	double xStamp, yStamp, rightStamp, bottomStamp;
	bool _leaf;
	double _relativeX, _relativeY, _relativeRight, _relativeBottom;
    inline bool collide(PolarTree* bTree);
	inline bool rectCollide(PolarTree* bTree);
	inline bool rectContain(double x, double y, double right, double bottom);
	inline bool rectCollideCoord(double x, double y, double right,
                                  double bottom);
};
#endif
