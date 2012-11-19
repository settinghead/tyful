#ifndef PolarTree_H
#define PolarTree_H

#include <vector>
#include "constants.h"
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

	PolarTree(double r1, double r2, double d1, double d2, int minBoxSize);
	virtual ~PolarTree();
	void addKids(vector<PolarChildTree*>* kidList);
	inline virtual int getRootX() = 0;
	inline virtual int getRootY() = 0;
	bool overlaps(PolarTree* otherTree);
	vector<PolarChildTree*>* getKids();
	vector<PolarChildTree*>* getKidsNoGrowth();
	inline virtual PolarRootTree* getRoot() = 0;
	virtual int getMinBoxSize() = 0;
	virtual ImageShape* getShape() = 0;
	virtual bool overlapsCoord(double x, double y, double right, double bottom);
	virtual bool contains(double x, double y, double right, double bottom);
    CartisianPoint getTopLeftLocation();
	inline virtual double getR1(bool rotate);
	inline virtual double getR2(bool rotate);
	inline virtual double px();
	inline virtual double py();
	inline virtual double pright();
	inline virtual double pbottom();
	inline virtual bool isLeaf();
	int swelling;
	virtual void swell(int extra);
	inline virtual double getWidth(bool rotate);
	inline virtual double getHeight(bool rotate);
	inline virtual double getX(bool rotate);
	inline virtual double getY(bool rotate);
	inline virtual double getRight(bool rotate);
	inline virtual double getBottom(bool rotate);
	inline virtual double getRotation() = 0;
	inline virtual double getScale() = 0;
	inline virtual int getCurrentStamp() = 0;
	inline virtual void setLeaf(bool b);
    inline double getD1(bool scale);
    inline double getD2(bool scale);
    
private:
    double _x, _y, _right, _bottom, _r1, _d1, _r2, _d2;
    double pointsStamp;
	double _px, _py, _pright, _pbottom;
	double xStamp, yStamp, rightStamp, bottomStamp;
	bool _leaf;
	double _relativeX, _relativeY, _relativeRight, _relativeBottom;
    int rStamp;
	vector<PolarChildTree*>* _kids;
	double _computedR1, _computedR2, _computedD1, _computedD2;
    inline virtual void computeR1();
	inline virtual void computeR2();
    inline virtual void computeD1();
	inline virtual void computeD2();
    inline virtual double computeX(bool rotate) = 0;
	inline virtual double computeY(bool rotate) = 0;
	inline virtual double computeRight(bool rotate) = 0;
	inline virtual double computeBottom(bool rotate) = 0;
    inline virtual void checkRecompute();
	inline virtual void checkUpdatePoints();
    inline virtual double getRelativeX();
	inline virtual double getRelativeY();
	inline virtual double getRelativeRight();
	inline virtual double getRelativeBottom();
    inline virtual void checkComputeX();
	inline virtual void checkComputeY();
	inline virtual void checkComputeRight();
	inline virtual void checkComputeBottom();
    inline bool collide(PolarTree* bTree);
	inline bool rectCollide(PolarTree* bTree);
	inline bool rectContain(double x, double y, double right, double bottom);
	inline bool rectCollideCoord(double x, double y, double right,
                                  double bottom);
    
};
#endif
