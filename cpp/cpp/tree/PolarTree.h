#ifndef PolarTree_H
#define PolarTree_H

#include <vector>
#include <cmath>
#include "../constants.h"
#include "../model/structs.h"
#include "../constants.h"
#include <pthread.h>
#include <assert.h>
using namespace std;



class PolarRootTree;
class ImageShape;
struct CartisianPoint;


enum SplitType {
	_3RAYS, _2RAYS1CUT, _1RAY1CUT, _1RAY2CUTS, _3CUTS
};
class PolarTree {
private:
    double _d1,_d2;
    double _computedR1[NUM_THREADS];
	double _computedR2[NUM_THREADS];
    double _computedD1, _computedD2;

    bool dStamp;
    inline void computeR1(int seq){
        this->_computedR1[seq] = (this->_r1 + this->getRotation(seq));
		if (((this->_computedR1[seq] > TWO_PI ))) {
			this->_computedR1[seq] -= TWO_PI;
		}
        else if(this->_computedR1<0)
            this->_computedR1[seq] += TWO_PI;
    }
	inline void computeR2(int seq){
        this->_computedR2[seq] = (this->_r2 + this->getRotation(seq));
		if (((this->_computedR2[seq] > TWO_PI)))
			this->_computedR2[seq] -= TWO_PI;
        else if(this->_computedR2<0)
            this->_computedR2[seq] += TWO_PI;
    }
    inline void computeD1(){
        this->_computedD1 = (this->_d1 * getScale());
    }
    inline void computeD2(){
        this->_computedD2 = (this->_d2 * getScale());
    }
    inline void makeChildren() {
        {
            SplitType type = determineType();
            vector<PolarTree*>* children = splitTree(type);
            addKids(children);
        }
    }
    
    inline SplitType determineType() {
        double d = (getD2(false) - getD1(false));
        double midLength = (((getD2(false) + getD1(false)))
                            * ((getR2(-1,false) - getR1(-1,false)))) / 2.0;
        double factor = d / midLength;
        if (factor < 0.7) {
            return _3RAYS;
        } else {
            if (factor > 1.3) {
                return _3CUTS;
            } else {
                return _1RAY1CUT;
            }
        }
    }
    
    inline PolarTree* makeChildTree(double r1, double r2, double d1, double d2);
    inline vector<PolarTree*>* splitTree(SplitType type);

    
public:
	PolarTree(double r1, double r2, double d1, double d2);
	~PolarTree();
	inline void addKids(vector<PolarTree*>* kidList);
    virtual inline PolarRootTree* getRoot() = 0;

	inline virtual bool overlaps(int seq,PolarTree* otherTree, int otherSeq, const double rootCenterDist){
//        bool r = getFinalSeq()<0?this->collide(seq, otherTree):otherTree->collide(seq, this);
        bool r = this->collide(seq, otherTree, otherSeq,rootCenterDist);
        if (r) {
            if (this->isLeaf() && otherTree->isLeaf()) {
                return true;
            } else {
                if ((this->isLeaf())) {
                    vector<PolarTree*>* oKids = otherTree->getKids();
                    for (int i=0;i<oKids->size();i++) {
                        PolarTree* okid = oKids->at((i+otherSeq)%oKids->size());
                        if (this->overlaps(seq,okid,otherSeq,rootCenterDist))
                            return true;
                    }
                } else {
                    vector<PolarTree*>* tKids = this->getKids();
                    
                    for (int i=0; i<tKids->size();i++) {
                        if (otherTree->overlaps(otherSeq,tKids->at((i+seq)%tKids->size()),seq,rootCenterDist))
                            return true;
                    }
                    
                }
            }
        }
        return false;
    }
	vector<PolarTree*>* getKids();
	inline vector<PolarTree*>* getKidsNoGrowth(){
        return this->_kids;
    }
	virtual double getScale() = 0;
	inline bool overlapsCoord(int seq,double x, double y, double right, double bottom){
        if ((this->rectCollideCoord(seq,x, y, right, bottom))) {
            if ((this->isLeaf())) {
                return true;
            } else {
                vector<PolarTree*>* tKids = this->getKids();
                for (vector<PolarTree*>::iterator myKid = tKids->begin();
                     myKid != tKids->end(); ++myKid) {
                    if (((*myKid)->overlapsCoord(seq,x, y, right, bottom))) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
	virtual inline bool contains(int seq,double x, double y, double right, double bottom);
//    inline CartisianPoint getTopLeftLocation(int seq){
//        return CartisianPoint(getRootX(seq)-getWidth()/2,getRootY(seq)-getHeight()/2);
//    }
	virtual double computeX(int seq,bool rotate) = 0;
	virtual double computeY(int seq,bool rotate) = 0;
	virtual double computeRight(int seq,bool rotate) = 0;
	virtual double computeBottom(int seq,bool rotate) = 0;
    virtual void updateFourPointsWithRotationScale(int seq) = 0;
	inline double getR1(int seq,bool rotate){
        if ((rotate)) {
            this->checkRecomputeRs(seq);
            return this->_computedR1[seq];
        } else {
            assert(seq<0);
            return this->_r1;
        }
    }
	inline double getR2(int seq,bool rotate){
        if ((rotate)) {
            this->checkRecomputeRs(seq);
            return this->_computedR2[seq];
        } else {
            assert(seq<0);
            return this->_r2;
        }
    }
    inline double getD1(bool scale){
        if(scale){
            this->checkRecomputeDs();
            return this->_computedD1;
        }
        else{
            return this->_d1;
        }
    }
    inline double getD2(bool scale){
        if(scale){
            this->checkRecomputeDs();
            return this->_computedD2;
        }
        else{
            return this->_d2;
        }
        
    }
	inline void checkRecomputeRs(int seq){
        if (this->rStamp[seq] != this->getCurrentStamp(seq)) {
            
//            this->_computedR1[seq] = (this->_r1 + this->getRotation(seq));
//            this->_computedR2[seq] = (this->_r2 + this->getRotation(seq));
//            if (((this->_computedR2[seq] > TWO_PI ))) {
//                this->_computedR1[seq] -= TWO_PI;
//                this->_computedR2[seq] -= TWO_PI;
//            }
//            else if(this->_computedR1<0){
//                this->_computedR1[seq] += TWO_PI;
//                this->_computedR2[seq] += TWO_PI;
//            }
//            assert(!isnan(_computedR1[seq]));
            computeR1(seq);
            computeR2(seq);
            
			this->rStamp[seq] = this->getCurrentStamp(seq);
		}
    }
    
    inline void checkRecomputeDs(){
//        pthread_mutex_lock(&d_lock);
        if (this->dStamp != this->getCurrentDStamp()) {
            this->computeD1();
            this->computeD2();
            this->dStamp = this->getCurrentDStamp();
        }
//        pthread_mutex_unlock(&d_lock);

    }

	inline void checkUpdatePoints(int seq);
//    inline void checkUpdatePoints(int seq){
//        if (((this->pointsStamp[seq] != this->getCurrentStamp(seq)))) {
//			this->updateFourPointsWithRotationScale(seq);
//            _px[seq] = getRootX(seq)+_x[seq];
//            _py[seq] = getRootY(seq)+_y[seq];
//            _pright[seq] = getRootX(seq)+_right[seq];
//            _pbottom[seq] = getRootY(seq)+_bottom[seq];
//			this->pointsStamp[seq] = this->getCurrentStamp(seq);
//		}
//    }
    
	inline double px(int seq){
        this->checkUpdatePoints(seq);
        return this->_px[seq];
    }
	inline double py(int seq){
        this->checkUpdatePoints(seq);
        return this->_py[seq];
    }
	inline double pright(int seq){
        this->checkUpdatePoints(seq);
        return this->_pright[seq];
    }
	inline double pbottom(int seq){
        this->checkUpdatePoints(seq);
        return this->_pbottom[seq];
    }
	inline bool isLeaf(){
        return this->_leaf;
    }
	int swelling;
	inline void swell(int extra);
	inline double getTreeWidth();
	inline double getTreeHeight();
	inline void checkComputeX(int seq){
        if (((this->xStamp[seq] != this->getCurrentStamp(seq)))) {
			this->_x[seq] = this->computeX(seq,true);
			this->xStamp[seq] = this->getCurrentStamp(seq);
		}
    }
	inline void checkComputeY(int seq){
        if (((this->yStamp[seq] != this->getCurrentStamp(seq)))) {
			this->_y[seq] = this->computeY(seq,true);
			this->yStamp[seq] = this->getCurrentStamp(seq);
		}
    }
	inline void checkComputeRight(int seq){
        if (((this->rightStamp[seq] != this->getCurrentStamp(seq)))) {
			this->_right[seq] = this->computeRight(seq,true);
			this->rightStamp[seq] = this->getCurrentStamp(seq);
		}
    }
	inline void checkComputeBottom(int seq){
        if (((this->bottomStamp[seq] != this->getCurrentStamp(seq)))) {
			this->_bottom[seq] = this->computeBottom(seq,true);
			this->bottomStamp[seq] = this->getCurrentStamp(seq);
		}
    }
	inline double getRelativeX(){
        if ((isnan(this->_relativeX))) {
            this->_relativeX = this->computeX(-1,false);
        }
        return this->_relativeX;
    }
	inline double getRelativeY(){
        if ((isnan(this->_relativeY))) {
            this->_relativeY = this->computeY(-1,false);
        }
        return this->_relativeY;
    }
	inline double getRelativeRight(){
        if ((isnan(this->_relativeRight))) {
            this->_relativeRight = this->computeRight(-1,false);
        }
        return this->_relativeRight;
    }
	inline double getRelativeBottom(){
        if ((isnan(this->_relativeBottom))) {
            this->_relativeBottom = this->computeBottom(-1,false);
        }
        return this->_relativeBottom;
        
    }
	inline double getX(int seq,bool rotate){
        if ((rotate)) {
            this->checkComputeX(seq);
            return (this->_x[seq] MINUS_MARGIN);
        } else {
            return this->getRelativeX();
        }
    }
	inline double getY(int seq,bool rotate){
        if ((rotate)) {
            this->checkComputeY(seq);
            return (this->_y[seq] MINUS_MARGIN);
        } else {
            return this->getRelativeY();
        }
    }
	inline double getRight(int seq,bool rotate){
        if ((rotate)) {
            this->checkComputeRight(seq);
            return (this->_right[seq] PLUS_MARGIN);
        } else {
            return this->getRelativeRight();
        }
    }
	inline double getBottom(int seq,bool rotate){
        if ((rotate)) {
            this->checkComputeBottom(seq);
            return (this->_bottom[seq] PLUS_MARGIN);
        }
        return this->getRelativeBottom();
    }
	virtual double getRotation(int seq) = 0;
	virtual int getCurrentStamp(int seq) = 0;
	virtual bool getCurrentDStamp() = 0;
	inline void setLeaf(bool b);
protected:
    pthread_mutex_t lock;
    pthread_mutex_t d_lock;
    int rStamp[NUM_THREADS];
	double _x[NUM_THREADS], _y[NUM_THREADS], _right[NUM_THREADS], _bottom[NUM_THREADS];
	vector<PolarTree*>* _kids;
	double pointsStamp[NUM_THREADS];
	double _px[NUM_THREADS], _py[NUM_THREADS], _pright[NUM_THREADS], _pbottom[NUM_THREADS];
	double xStamp[NUM_THREADS], yStamp[NUM_THREADS], rightStamp[NUM_THREADS], bottomStamp[NUM_THREADS];
	bool _leaf;
	double _relativeX, _relativeY, _relativeRight, _relativeBottom,_r1, _r2;
    inline bool collide(int seq,PolarTree* bTree, int otherSeq, const double rootCenterDist){
        if (((rootCenterDist > (this->getD2(true) + bTree->getD2(true))))) {
            return false;
        } else {
            return this->rectCollide(seq,bTree, otherSeq);
        }
    }
	inline bool rectCollide(int seq,PolarTree* bTree, int otherSeq){
        bTree->checkUpdatePoints(otherSeq);
        return this->rectCollideCoord(seq,bTree->px(otherSeq), bTree->py(otherSeq), bTree->pright(otherSeq),
                                      bTree->pbottom(otherSeq));
    }
	inline bool rectContain(int seq,double x, double y, double right, double bottom);
	inline bool rectCollideCoord(int seq,double x, double y, double right,
                                 double bottom){
        //#ifdef FLIP
        checkUpdatePoints(seq);
        return this->pbottom(seq) > y
        && this->py(seq) < bottom
        && this->pright(seq) > x
        && this->px(seq) < right;
        //#else
        //    return this->pbottom() < y
        //    && this->py() > bottom
        //    && this->pright() > x
        //    && this->px() < right;
        //#endif
    }
};
#endif
