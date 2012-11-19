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
    inline static double getBrightness(unsigned int rgb){
        int r = (rgb) >> 16 & 0xFF;
        int g = (rgb) >> 8 & 0xFF;
        int b = rgb & 0xFF;
        double cmax = (r > g) ? r : g;
        if (b > cmax) cmax = b;
        
        return cmax/255;
    }
    
    inline static int RGBtoHSB(unsigned int rgbPixel) {
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
    
    inline static double getHue(unsigned int rgbPixel) {
        int r = (rgbPixel) >> 16 & 0xFF;
        int g = (rgbPixel) >> 8 & 0xFF;
        int b = rgbPixel & 0xFF;
        double hue, saturation;
        
        double cmax = (r > g) ? r : g;
        if (b > cmax) cmax = b;
        double cmin = (r < g) ? r : g;
        if (b < cmin) cmin = b;
        
        if (cmax != 0)
            saturation = (cmax - cmin) / cmax;
        else
            saturation = 0;
        if (saturation == 0)
            hue = 0;
        else {
            double redc = ( (cmax - r)) / ((cmax - cmin));
            double greenc = ( (cmax - g)) / ((cmax - cmin));
            double bluec = ((cmax - b)) / ((cmax - cmin));
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
        
        return hue;
    }
    
    inline static double distRGB(unsigned int c1, unsigned int c2){
        double r1 = (c1) >> 16 & 0xFF;
        double g1 = (c1) >> 8 & 0xFF;
        double b1 = c1 & 0xFF;
        double r2 = (c2) >> 16 & 0xFF;
        double g2 = (c2) >> 8 & 0xFF;
        double b2 = c2 & 0xFF;
        return fabs(r1-r2)/256/3 + fabs(g1-g2)/256/3 + fabs(b1-b2)/256/3;
    }
    
    inline static double distHue(unsigned int c1, unsigned int c2){
        double h1 = getHue(c1);
        double h2 = getHue(c2);
        double diff= fabs(h1-h2);
        if(diff>0.5) diff = 1-diff;
        return diff;
    }
};

#endif
