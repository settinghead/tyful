//
//  WordLayer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__WordLayer__
#define __PolarTree_Experiment__WordLayer__
#include "PolarLayer.h"

class Angler;

class WordLayer: public PolarLayer{
public:
    class ColorSheet: public PixelImageShape{};
    WordLayer(unsigned int * pixels, int width, int height);
    const LAYER_TYPE type = WORD_LAYER;
    bool contains(double x, double y, double width, double height, double rotation);
    bool containsPoint(double x, double y, double refX, double refY);
    double getBrightness(int x, int y);
    double getHue(int x, int y);
    void setTolerance(double v);
    ColorSheet* getColorSheet();
    void setColorSheet(ColorSheet* colorSheet);
    Angler* getAngler();
    
private:
    double getHSB(int x, int y);
    double tolerance = 1.0;
    ColorSheet* colorSheet = NULL;
    Angler* _angler = NULL;

};

#endif /* defined(__PolarTree_Experiment__WordLayer__) */
