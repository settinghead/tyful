//
//  Patch.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_Patch_h
#define PolarTree_Experiment_Patch_h
#include <vector>
#include <math.h>
#include <float.h>
#define NUMBER_OF_DIVISIONS 3
#define MARK_FILL_FACTOR 1

using namespace std;

class PatchQueue;
class WordLayer;
class PolarCanvas;
class EngineShape;

class Patch{
public:
    Patch(double x, double y, double width, double height, int rank, Patch* parent, PatchQueue* queue, WordLayer* layer);
    PolarCanvas* getCanvas();
    double getAverageAlpha();
    vector<Patch*>* divideIntoNineOrMore(PatchQueue* newQueue);
    double getX();
    double getY();
    double getWidth();
    double getHeight();
    WordLayer* getLayer();
    vector<EngineShape*>* getShapes();
    double getAlphaSum();
    void mark(int smearedArea, bool spreadSmearToChildren);
    void setLastAttempt(int attempt);
    int getLastAttempt();
    void fail();
    int getLevel();
    const int getNumberOfFailures();
private:
    double x,y, width, height;
    double averageAlpha= NAN, area=NAN, alphaSum=NAN;
    Patch* parent;
    PatchQueue* queue;
    vector<Patch*>* children;
    vector<EngineShape*>* shapes;
    int rank;
    int numberOfFailures = 0;
    int lastAttempt = 0;
    WordLayer* layer;
    double getArea();
};

struct ComparePatch : public std::binary_function<Patch*, Patch*, bool>
{
    bool operator()(Patch* lhs, Patch* rhs) const
    {
        //			var r:int= -_numComparator.compare(p1.getAverageAlpha(),p2.getAverageAlpha());
        int f1 = lhs->getNumberOfFailures(), f2 = rhs->getNumberOfFailures();
        return (f1==f2) ? (lhs->getAlphaSum()<rhs->getAlphaSum()) : (f1>f2);
        
        //                if(r==0){
        //                    r = _numComparator.compare(p1.getAlphaSum(), p2.getAlphaSum());
        //                    if (r == 0)
        //                        return p1.getRank() - p2.getRank();
        //                        else
        //                            return r;
        //                }
        //        else return r;
    }
};

#endif
