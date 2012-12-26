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
#include "../proto/template.pb.h"
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
    bool containsAllPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation);
    virtual bool suitableForPlacement(double centerX, double centerY, vector<PolarPoint>* points, double rotation) = 0;
    bool containsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation);
    bool aboveContains(double x, double y, double width, double height,double rotation);
    bool aboveContainsPoint(double x, double y);
    bool aboveContainsAnyPolarPoints(double centerX, double centerY, vector<PolarPoint>* points, double rotation);
    virtual bool isEmpty(unsigned int pixelValue) = 0;
    static void connect(PolarLayer* above, PolarLayer* below);
    virtual void serialize(tyful::Layer* layer) = 0;
    
    PolarLayer* above;
    PolarLayer* below;

};



#endif
