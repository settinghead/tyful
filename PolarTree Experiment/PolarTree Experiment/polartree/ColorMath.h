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
    
    static int RGBtoHSB(unsigned int rgbPixel) {
        int r = (rgbPixel) >> 16 & 0xFF;
        int g = (rgbPixel) >> 8 & 0xFF;
        int b = rgbPixel & 0xFF;
        double hue, saturation, brightness;
        
        double cmax = (r > g) ? r : g;
        if (b > cmax) cmax = b;
        double cmin = (r < g) ? r : g;
        if (b < cmin) cmin = b;
        
        brightness = cmax / 255.0;
        if (cmax != 0)
            saturation = (cmax - cmin) / cmax;
        else
            saturation = 0;
        if (saturation == 0)
            hue = 0;
        else {
            double redc = ( (cmax - r)) / ((cmax - cmin));
            double greenc = ( (cmax - g)) / ((cmax - cmin));
            double bluec  = ((cmax - b)) / ((cmax - cmin));
            if (r == cmax)
                hue = bluec - greenc;
            else if (g == cmax)
                hue = 2.0 + redc - bluec;
            else
				hue = 4.0 + greenc - redc;
            hue = hue / 6.0;
            if (hue < 0)
                hue = hue + 1.0;
        }
        
        int h = hue*255;
        int s = saturation*255;
        int bb = brightness*255;
        return 0xff000000 | (h << 16) | (s << 8) | bb;
        
    }
};

#endif
