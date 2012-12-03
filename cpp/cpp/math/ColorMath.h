//
//  ColorMath.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PolarTree_Experiment_ColorMath_h
#define PolarTree_Experiment_ColorMath_h

#include <cmath>
#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))
#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))
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
    
    inline static unsigned int RGBtoHSB(unsigned int rgbPixel) {
        int r = (rgbPixel) >> 16 & 0xFF;
        int g = (rgbPixel) >> 8 & 0xFF;
        int b = rgbPixel & 0xFF;
        float hue, saturation, brightness;
        
        float cmax = (r > g) ? r : g;
        if (b > cmax) cmax = b;
        float cmin = (r < g) ? r : g;
        if (b < cmin) cmin = b;
        
        brightness = cmax / 255;
        if (cmax != 0)
            saturation = (cmax - cmin) / cmax;
        else
            saturation = 0;
        if (saturation == 0)
            hue = 0;
        else {
            float redc = ( (cmax - r)) / ((cmax - cmin));
            float greenc = ( (cmax - g)) / ((cmax - cmin));
            float bluec  = ((cmax - b)) / ((cmax - cmin));
            if (r == cmax)
                hue = bluec - greenc;
            else if (g == cmax)
                hue = 2 + redc - bluec;
            else
				hue = 4 + greenc - redc;
            hue = hue / 6;
            if (hue < 0)
                hue = hue + 1;
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
        double rd = r1-r2;
        double gd = g1-g2;
        double bd = b1-b2;
        return abs(rd)/256/3 + abs(gd)/256/3 + abs(bd)/256/3;
    }
    
    inline static double distHue(unsigned int c1, unsigned int c2){
        double h1 = getHue(c1);
        double h2 = getHue(c2);
        double diff= abs(h1-h2);
        if(diff>0.5) diff = 1-diff;
        return diff;
    }
    
    inline static unsigned int HSLtoRGB(double hue, double saturation, double lightness, double a){
        hue = hue * 360;
        a = MIN(1,a); a = MAX(0,a);
        saturation = MIN(1,saturation); saturation = MAX(0,saturation);
        lightness = MIN(1,lightness); lightness = MAX(0,lightness);
        hue = fmod(hue,360);
        if(hue<0)hue+=360;
        hue/=60;
        double C = (1-abs(2*lightness-1))*saturation;
        double X = C*(1-abs(fmod(hue,2)-1));
        double m = lightness-0.5*C;
        C=(C+m)*255;
        X=(X+m)*255;
        m*=255;
        if(hue<1) return ((int)(a*255)<<24)+((int)C<<16)+((int)X<<8)+m;
        if(hue<2) return ((int)(a*255)<<24)+((int)X<<16)+((int)C<<8)+m;
        if(hue<3) return ((int)(a*255)<<24)+((int)m<<16)+((int)C<<8)+X;
        if(hue<4) return ((int)(a*255)<<24)+((int)m<<16)+((int)X<<8)+C;
        if(hue<5) return ((int)(a*255)<<24)+((int)X<<16)+((int)m<<8)+C;
        return ((int)round(a*255)<<24)+((int)C<<16)+((int)m<<8)+X;
    }
};

#endif
