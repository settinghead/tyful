//
//  WordLayer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "WordLayer.h"
#include "PolarCanvas.h"
#include "PixelImageShape.h"
#include "PolarRootTree.h"
#include "ColorMath.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>

bool WordLayer::contains(double x, double y, double width, double height, double rotation){
    if (this->tree == NULL) {
        // sampling approach
        int numSamples = width * height / SAMPLE_DISTANCE;
        //				var numSamples = 10;
        // TODO: devise better lower bound
        if (numSamples < 20)
            numSamples = 20;
        int threshold = 1;
        int darkCount = 0;
        int i= 0;
        srand ( (unsigned int)time(NULL) );

        while (i < numSamples) {
            int relativeX = rand() % (int)width;
            int relativeY= rand() % (int)height;
            
            //rotation
            rotation = - rotation;
            
            if(rotation!=0){
                
                if(relativeX==0) relativeX = 0.001;
                relativeX = (relativeX - width/2);
                relativeY = (relativeY - height/2);
                
                double r = sqrt(pow(relativeX, 2)+pow(relativeY, 2));
                double theta = atan2(relativeY, relativeX);
                theta += rotation;
                
                relativeX = r * cos(theta);
                relativeY = r * sin(theta);
                
                //					relativeX = (relativeX * Math.cos(rotation))
                //						- (relativeY * Math.sin(rotation));
                //					relativeY = Math.sin(rotation) * relativeX
                //						+ Math.cos(rotation ) * relativeY;
                
                relativeX = (relativeX + width/2);
                relativeY = (relativeY + height/2);
            }
            int sampleX = relativeX + x;
            int sampleY = relativeY + y;
            
            double brightness = getBrightness(sampleX, sampleY);
            if ((isnan(brightness) || brightness < 0.01) && ++darkCount >= threshold)
                //											if ((!containsPoint(sampleX, sampleY, false)) && ++darkCount >= threshold)
                return false;
            i++;
        }
        
        return true;
    }
    else {
        return tree->overlapsCoord(x, y, x + width, y + height);
    }
}

double WordLayer::getBrightness(int x, int y) {
    
    unsigned int rgbPixel = getPixel(x, y);
    unsigned int alpha = rgbPixel>> 24 & 0xFF;
    if(alpha == 0) {
        return NAN;
    }
    return ColorMath::getBrightness(rgbPixel);
}

double WordLayer::getHue(int x, int y) {
    int colour = getHSB(x,y);
    //			Assert.isTrue(!isNaN(colour.hue));
    double h = ( (colour & 0x00FF0000) >> 16);
    h/=255;
    return h;
}

double WordLayer::getHSB(int x, int y){
    //			if(this.hsbArray[x]==null)
    //				this.hsbArray[x] = new Array(this._img.height);
    //			if(this.hsbArray[x][y]==null){
    //				var rgbPixel : uint = _img.bitmapData.getPixel32( x, y );
    //				var alpha:uint = rgbPixel>> 24 & 0xFF;
    //				if(alpha == 0) {
    //					hsbArray[x][y]  = NaN;
    //					return NaN;
    //				}
    //				else {
    //					var colour:int =  ColorMath.RGBtoHSB(rgbPixel);
    //					hsbArray[x][y] = colour;
    //					return colour;
    //				}
    //			}
    //			return this.hsbArray[x][y];
    
    unsigned int rgbPixel  = getPixel( x, y );
    unsigned int alpha  = rgbPixel>> 24 & 0xFF;
    if(alpha == 0) {
        return NAN;
    }
    else {
        int colour =  ColorMath::RGBtoHSB(rgbPixel);
        return colour;
    }
}
    
