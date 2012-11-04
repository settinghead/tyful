#ifndef BBPOLARTREEVO_H
#define BBPOLARTREEVO_H

#include <vector>
#include "ImageShape.h"

using namespace std;

#define PI 3.14159265359
#define HALF_PI 1.57079633
#define TWO_PI 6.2831853
#define ONE_AND_HALF_PI 4.712388980
#define MARGIN 0

class BBPolarRootTreeVO;
class BBPolarChildTreeVO;
enum SplitType {
	_3RAYS, _2RAYS1CUT, _1RAY1CUT, _1RAY2CUTS, _3CUTS
};
class BBPolarTreeVO {
public:

	BBPolarTreeVO(double r1, double r2, double d1, double d2, int minBoxSize);
	virtual ~BBPolarTreeVO();
	int rStamp;
	double _x, _y, _right, _bottom, _r1, d1, _r2, d2;
	vector<BBPolarChildTreeVO*>* _kids;
	double _computedR1;
	double _computedR2;
	double pointsStamp;
	double _px, _py, _pright, _pbottom;
	double xStamp, yStamp, rightStamp, bottomStamp;
	bool _leaf;
	double _relativeX, _relativeY, _relativeRight, _relativeBottom;
	void addKids(vector<BBPolarChildTreeVO*>* kidList);
	virtual int getRootX() = 0;
	virtual int getRootY() = 0;
	bool overlaps(BBPolarTreeVO* otherTree);
	vector<BBPolarChildTreeVO*>* getKids();
	vector<BBPolarChildTreeVO*>* getKidsNoGrowth();
	virtual BBPolarRootTreeVO* getRoot() = 0;
	virtual int getMinBoxSize() = 0;
	virtual ImageShape* getShape() = 0;
	virtual bool overlapsCoord(double x, double y, double right, double bottom);
	virtual bool contains(double x, double y, double right, double bottom);
	virtual double computeX(bool rotate) = 0;
	virtual double computeY(bool rotate) = 0;
	virtual double computeRight(bool rotate) = 0;
	virtual double computeBottom(bool rotate) = 0;
	virtual double getR1(bool rotate);
	virtual double getR2(bool rotate);
	virtual void checkRecompute();
	virtual void computeR1();
	virtual void computeR2();
	virtual void checkUpdatePoints();
	virtual double px();
	virtual double py();
	virtual double pright();
	virtual double pbottom();
	virtual bool collide(BBPolarTreeVO* bTree);
	virtual bool rectCollide(BBPolarTreeVO* bTree);
	virtual bool rectContain(double x, double y, double right, double bottom);
	virtual bool rectCollideCoord(double x, double y, double right,
			double bottom);
	virtual bool isLeaf();
	int swelling;
	virtual void swell(int extra);
	virtual double getWidth(bool rotate);
	virtual double getHeight(bool rotate);
	virtual void checkComputeX();
	virtual void checkComputeY();
	virtual void checkComputeRight();
	virtual void checkComputeBottom();
	virtual double getRelativeX();
	virtual double getRelativeY();
	virtual double getRelativeRight();
	virtual double getRelativeBottom();
	virtual double getX(bool rotate);
	virtual double getY(bool rotate);
	virtual double getRight(bool rotate);
	virtual double getBottom(bool rotate);
	virtual double getRotation() = 0;
	virtual int getCurrentStamp() = 0;
	virtual void setLeaf(bool b);
};
#endif
