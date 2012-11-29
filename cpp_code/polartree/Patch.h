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
#include "WordLayer.h"
using namespace std;

class PatchQueue;
class PolarCanvas;
class EngineShape;

class Patch{
private:
    double x,y, width, height;
    double averageAlpha, area, alphaSum;
    Patch* parent;
    PatchQueue* queue;
    vector<Patch*>* children;
    vector<EngineShape*>* shapes;
    int rank;
    int numberOfFailures;
    int lastAttempt;
    WordLayer* layer;
    double getArea();
public:
    Patch(double x, double y, double width, double height, int rank, Patch* parent, PatchQueue* queue, WordLayer* layer);
    inline PolarCanvas* getCanvas();
    inline double getAverageAlpha();
    inline vector<Patch*>* divideIntoNineOrMore(PatchQueue* newQueue){
        vector<Patch*>* result = new vector<Patch*>();
        int min = width < height ? width:height;
        int squareLength = min / NUMBER_OF_DIVISIONS;
        //    int centerCount = (NUMBER_OF_DIVISIONS + 1) / 2;
        
        bool breakI = false;
        for (int i= 0; i < width; i += squareLength) {
            int squareWidth;
            if (i + squareLength * 2> width) {
                squareWidth = width - i;
                // i = getWidth();
                breakI = true;
            } else
                squareWidth = squareLength;
            bool breakJ = false;
            
            for (int j= 0; j < height; j += squareLength) {
                int squareHeight;
                if (j + squareLength * 2> height) {
                    squareHeight = height - j;
                    // j = height;
                    breakJ = true;
                } else
                    squareHeight = squareLength;
                
                // the closer to the center, the higher the rank
                Patch* p = new Patch(x + i, y + j,
                                     squareWidth, squareHeight, 0, this, newQueue, this->layer);
                result->push_back(p);
                if (breakJ)
                    break;
            }
            if (breakI)
                break;
        }
        
        this->children = result;
        return result;
    }
    inline double getX(){
        return x;
    }
    inline double getY(){
        return y;
    }
    inline double getWidth(){
        return width;
    }
    inline double getHeight(){
        return height;
    }
    inline WordLayer* getLayer(){
        return layer;
    }
    inline vector<EngineShape*>* getShapes(){
        return shapes;
    }
    inline double getAlphaSum(){
        if(isnan(alphaSum)){
            alphaSum = 0;
            getArea();
            
            if (this->children == NULL
                || children->size() == 0) {
                for (int i= 0; i < width; i++)
                    for (int j= 0; j < height; j++) {
                        double brightness = layer->getBrightness(
                                                                 x + i, y + j);
                        if(isnan(brightness)){
                            brightness = 0;
                        }
                        else
                            brightness = brightness;
                        alphaSum += brightness;
                        if(brightness==0)
                            area -= 1;
                    }
            } else
                for(int i=0;i<children->size();i++)
                    alphaSum += children->at(i)->getAlphaSum();
            //        alphaSum = 1;
        }
        if(alphaSum==0){
            alphaSum = NAN;
        }
        return alphaSum;
    }
    inline void mark(int smearedArea, bool spreadSmearToChildren){
        //			this.resetWorthCalculations();
        //			this.getAlphaSum();
        this->alphaSum -= smearedArea * MARK_FILL_FACTOR;
        if(spreadSmearToChildren)
            for (vector<Patch*>::iterator it = children->begin();
                 it != children->end(); ++it){
                Patch* child = (*it);
                child->mark(smearedArea * MARK_FILL_FACTOR/children->size(), true);
                //				child._alphaSum -= smearedArea * DensityPatchIndex.MARK_FILL_FACTOR/this.getChildren().length;
                //				child._queue.remove(child);
                //				child._queue.tryAdd(child);
            }
        //			if (getParent() != null)
        //				getParent().markChild(this);
        if (parent != NULL){
            parent->mark(smearedArea, false);
            //				parent._queue.remove(parent);
            //				parent._queue.tryAdd(parent);
        }
    }
    inline void setLastAttempt(int attempt){
        lastAttempt = attempt;
    }
    inline int getLastAttempt(){
        return lastAttempt;
    }
    inline void fail(){
        numberOfFailures++;
    }
    int getLevel();
    inline const int getNumberOfFailures(){
        return numberOfFailures;
    }
};

struct ComparePatch
{
    inline bool operator()(Patch* lhs, Patch* rhs) const
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
