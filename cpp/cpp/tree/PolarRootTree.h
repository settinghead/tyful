#ifndef PolarROOTTree_H
#define PolarROOTTree_H

#include <math.h>
#include "../constants.h"
#include "PolarTree.h"
#include "../model/PixelImageShape.h"

class PolarRootTree: public PolarTree, public PixelImageShape{
private:
#if NUM_THREADS > 1
    int finalSeq;
#else
#define finalSeq 0
#endif

	int rootStamp[NUM_THREADS]; /* REM */
	bool rootDStamp; /* REM */
    double scale;
    void init();
protected:
    SlapInfo* renderedPlacement;

public:
    explicit PolarRootTree( unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb);
    explicit PolarRootTree(unsigned char * png, size_t size);
    Placement currentPlacement[NUM_THREADS];
    int winningSeq;
    virtual void finalizePlacement(int final_seq, int canvasId, int failureCount) = 0;
    SlapInfo* getFinalPlacement();
    
	~PolarRootTree();
	inline void setLocation(int seq,CartisianPoint location){
        this->currentPlacement[seq].location = location;
        (this->rootStamp[seq])++;
    }

	inline void setTopLeftLocation(int seq,CartisianPoint l){
        this->currentPlacement[seq].location.x = getWidth()/2 + l.y;
        this->currentPlacement[seq].location.y = getHeight()/2 + l.x;
        (this->rootStamp[seq])++;
    }
    
    inline PolarRootTree* getRoot(){
        return this;
    }

    void updateFourPointsWithRotationScale(int seq);

    static void inline adjust(double &angleStart, double &angleEnd){
        if(angleStart>=TWO_PI){
            angleStart-=TWO_PI;
            angleEnd-=TWO_PI;
        }
        else if(angleEnd<0){
            angleStart+=TWO_PI;
            angleEnd+=TWO_PI;
        }
    }
    
    static void inline swap(double &val1, double &val2){
        double v = val1;
        val1 = val2;
        val2 = v;
    }
    
    inline bool overlaps(int seq,PolarRootTree* otherTree, int otherSeq){
        CartisianPoint thisLoc = this->getRoot()->currentPlacement[seq].location;
        CartisianPoint otherLoc = otherTree->getRoot()->currentPlacement[otherSeq].location;
        double effectiveAngleSStart = NAN,effectiveAngleSEnd = NAN,effectiveAngleOStart = NAN, effectiveAngleOEnd = NAN;
        const double dist = sqrt(pow(thisLoc.x - otherLoc.x, 2.0)
                                                   + pow(thisLoc.y - otherLoc.y, 2.0));
        double halfD = dist /2, d2S = getD2(true), d2O = otherTree->getD2(true);
        if(d2S+d2O>dist&&abs(d2S-d2O)<dist){
            double effectiveAngleS = acos((d2S*d2S+halfD*halfD-d2O*d2O)/2/d2S/halfD);
            double effectiveAngleO = acos((d2O*d2O+halfD*halfD-d2S*d2S)/2/d2O/halfD);
            if((d2S>d2O && effectiveAngleS > effectiveAngleO)||(d2S<d2O && effectiveAngleS < effectiveAngleO))
                swap(effectiveAngleS,effectiveAngleO);
            double baseAngleO = atan2((getRoot()->currentPlacement[seq].location.y-otherTree->getRoot()->currentPlacement[otherSeq].location.y),(otherTree->getRoot()->currentPlacement[otherSeq].location.x-getRoot()->currentPlacement[seq].location.x));
            double baseAngleS = baseAngleO + PI;
            effectiveAngleSStart = baseAngleS - effectiveAngleS;
            effectiveAngleSEnd = baseAngleS + effectiveAngleS;
        
            effectiveAngleOStart = baseAngleO - effectiveAngleO;
            effectiveAngleOEnd = baseAngleO + effectiveAngleO;
        
            adjust(effectiveAngleSStart, effectiveAngleSEnd);
            adjust(effectiveAngleOStart, effectiveAngleOEnd);
            if(!isnan(effectiveAngleOStart))
                assert(effectiveAngleOStart<effectiveAngleOEnd && effectiveAngleSStart<effectiveAngleSEnd);

        }

        return PolarTree::overlaps(seq,(PolarTree*)otherTree, otherSeq, dist,effectiveAngleSStart,effectiveAngleSEnd,effectiveAngleOStart, effectiveAngleOEnd);
    }
    
    inline virtual bool overlaps(int seq,PolarRootTree* otherTree){
        return overlaps(seq, otherTree, otherTree->getFinalSeq());
    }
    
    inline virtual bool overlaps(PolarRootTree* otherTree){
        return overlaps(getFinalSeq(), otherTree, otherTree->getFinalSeq());
    }
    
    inline int getFinalSeq(){
        return finalSeq;
    }
#if NUM_THREADS > 1
    inline void setFinalSeq(int seq){
        finalSeq = seq;
    }
#endif
    inline bool contains(int seq,double x, double y, double right, double bottom) {
        return PolarTree::contains(seq,x,y,right,bottom);
    }
    
    inline bool contains(double x, double y, double right, double bottom) {
        return PixelImageShape::contains(x,y,right,bottom);
    }

	inline double computeX(int seq,bool rotate);
	inline double computeY(int seq,bool rotate);
	inline double computeRight(int seq,bool rotate);
	inline double computeBottom(int seq,bool rotate);
	inline void setRotation(int seq,double rotation){
        if(rotation!=this->currentPlacement[seq].rotation){
            this->currentPlacement[seq].rotation = fmod(rotation, TWO_PI);
            if (this->currentPlacement[seq].rotation < 0) {
                this->currentPlacement[seq].rotation = (TWO_PI + this->currentPlacement[seq].rotation);
            }
            (this->rootStamp[seq])++;
            assert(this->rootStamp[seq]!=this->rStamp[seq]);
        }
    }
    inline void setRotation(double rotation){
        setRotation(getFinalSeq(), rotation);
    }
    inline void setScale(double scale){
        if(scale!=this->scale){
            this->scale = scale;
            this->rootDStamp=!this->rootDStamp;
        }
    }
	inline double getRotation(int seq){
        return this->currentPlacement[seq].rotation;
    }

	inline int getCurrentStamp(int seq);

	inline ImageShape* getShape();
    inline double getScale(){
        return scale;
    }
    inline bool getCurrentDStamp(){
        return rootDStamp;
    }
};

#endif
