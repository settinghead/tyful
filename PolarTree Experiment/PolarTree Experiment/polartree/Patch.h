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
#define NUMBER_OF_DIVISIONS 2

using namespace std;

class PatchQueue;
class PolarLayer;
class PolarCanvas;

class Patch{
public:
    Patch(int x, int y, int width, int height, int rank, Patch* parent, PatchQueue* queue, PolarLayer* layer);
    PolarCanvas* getCanvas();
    double getAverageAlpha();
    vector<Patch*>* divideIntoNineOrMore(PatchQueue* newQueue);

private:
    int x,y, width, height;
    double averageAlpha= NAN, area=NAN, alphaSum=NAN;
    Patch* parent;
    PatchQueue* queue;
    vector<Patch*>* children;
    int rank;
    int numberOfFailures;
    int lastAttempt = 0;
    PolarLayer* layer;
    double getAlphaSum();
    double getArea();


};

#endif
