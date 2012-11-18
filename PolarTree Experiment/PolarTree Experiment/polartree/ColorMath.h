//
//  ColorMath.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_ColorMath_h
#define PolarTree_Experiment_ColorMath_h

class ColorMath{
public:
    static double getBrightness(unsigned int rgb){
        int r = (rgb) >> 16 & 0xFF;
        int g = (rgb) >> 8 & 0xFF;
        int b = rgb & 0xFF;
        double cmax = (r > g) ? r : g;
        if (b > cmax) cmax = b;
        
        return cmax/255;
    }
};

#endif
