#ifndef PolarROOTTree_H
#define PolarROOTTree_H
#include "PolarTree.h"
#include "../model/ImageShape.h"
#include "math.h"
#include "../constants.h"

class PolarRootTree: public PolarTree {
private:
#if NUM_THREADS > 1
    int finalSeq;
#else
#define finalSeq 0
#endif
    double rootX[NUM_THREADS]; /* REM */
	double rootY[NUM_THREADS]; /* REM */
	double _rotation[NUM_THREADS]; /* REM */
	int rootStamp[NUM_THREADS]; /* REM */
	ImageShape* shape; /* REM */
	int _minBoxSize; /* REM */

public:
	PolarRootTree(ImageShape* shape, double d,
			int minBoxSize);
	~PolarRootTree();
	inline void setLocation(int seq,int centerX, int centerY){
        this->rootX[seq] = centerX;
        this->rootY[seq] = centerY;
        (this->rootStamp[seq])++;
    }
	inline void setTopLeftLocation(int seq,double top, double left){
        this->rootX[seq] = this->shape->getWidth()/2 + top;
        this->rootY[seq] = this->shape->getHeight()/2 + left;
        (this->rootStamp[seq])++;
    }
	inline int getRootX(int seq);
	inline int getRootY(int seq);
    inline int getFinalSeq(){
        return finalSeq;
    }
#if NUM_THREADS > 1
    inline void setFinalSeq(int seq){
        finalSeq = seq;
    }
#endif

	inline double computeX(int seq,bool rotate);
	inline double computeY(int seq,bool rotate);
	inline double computeRight(int seq,bool rotate);
	inline double computeBottom(int seq,bool rotate);
	inline void setRotation(int seq,double rotation){
        if(rotation!=this->_rotation[seq]){
            this->_rotation[seq] = fmod(rotation, TWO_PI);
            if (this->_rotation[seq] < 0) {
                this->_rotation[seq] = (TWO_PI + this->_rotation[seq]);
            }
            (this->rootStamp[seq])++;
        }
    }
	inline double getRotation(int seq);
	inline int getCurrentStamp(int seq);
	inline PolarRootTree* getRoot();
	inline int getMinBoxSize();
	inline ImageShape* getShape();
};

#endif
