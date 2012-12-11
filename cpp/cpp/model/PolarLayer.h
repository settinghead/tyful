//
//  PolarLayer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_PolarLayer_h
#define PolarTree_Experiment_PolarLayer_h
#include "PolarCanvas.h"
#include "PixelImageShape.h"
#include <vector>
#define WORD_LAYER 1

class PolarLayer : public PixelImageShape{
public:
    typedef int LAYER_TYPE;
    const LAYER_TYPE type;
    int lid;
    PolarLayer(unsigned int const * pixels, int width, int height, int lid, bool revert,bool rgbaToArgb);
    PolarLayer(unsigned char * png, size_t png_size,int lid);
    virtual ~PolarLayer(){}
    virtual bool contains(double x, double y, double width, double height, double rotation) = 0;
    virtual bool containsPoint(double x, double y, double refX, double refY) = 0;
    bool containsAllPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX,double refY);
    bool containsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX, double refY);
    bool aboveContains(double x, double y, double width, double height,double rotation);
    bool aboveContainsPoint(double x, double y, double refX, double refY);
    bool aboveContainsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation, double refX,double refY);
    virtual bool isEmpty(unsigned int pixelValue) = 0;
    static void connect(PolarLayer* above, PolarLayer* below);
    
    PolarLayer* above;
    PolarLayer* below;
};



#endif
