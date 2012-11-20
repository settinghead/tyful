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
#include "ColorMath.h"
class Angler;

class WordLayer: public PolarLayer{
public:
    class ColorSheet: public PixelImageShape{};
    WordLayer(unsigned int * pixels, int width, int height);
    const LAYER_TYPE type;
    bool contains(double x, double y, double width, double height, double rotation);
    bool containsPoint(double x, double y, double refX, double refY);
    inline double getBrightness(int x, int y){
        unsigned int rgbPixel = getPixel(x, y);
        unsigned int alpha = rgbPixel>> 24 & 0xFF;
        if(alpha == 0) {
            return NAN;
        }
        return ColorMath::getBrightness(rgbPixel);
    }
    double getHue(int x, int y);
    void setTolerance(double v);
    ColorSheet* getColorSheet();
    void setColorSheet(ColorSheet* colorSheet);
    Angler* getAngler();
private:
    double getHSB(int x, int y);
    double tolerance;
    ColorSheet* colorSheet;
    Angler* _angler;

};

#endif /* defined(__PolarTree_Experiment__WordLayer__) */
