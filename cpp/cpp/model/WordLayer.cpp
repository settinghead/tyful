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
#include "../tree/PolarRootTree.h"
#include "../math/ColorMath.h"
#include "../angler/Angler.h"
#include "../angler/MostlyHorizontalAngler.h"
#include "../angler/ColorMapAngler.h"
#include "../placer/Placer.h"
#include "../colorer/Colorer.h"
#include "../colorer/TwoHueRandomSatsColorer.h"
#include "../colorer/ColorSheetColorer.h"
#include "../placer/ColorMapPlacer.h"
#include "../fasttrig.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>

WordLayer::WordLayer(unsigned char * png, size_t png_size, int lid):PolarLayer::PolarLayer(png,png_size,lid)
, type(WORD_LAYER), colorSheet(NULL),_angler(NULL),_colorer(NULL),tolerance(DEFAULT_TOLERANCE){
    colorSheet = new ColorSheet(png, png_size);
}

WordLayer::WordLayer(unsigned int const * pixels, int width, int height, int lid, bool revert,bool rgbaToArgb)
:PolarLayer::PolarLayer(pixels,width,height,lid,revert,rgbaToArgb), type(WORD_LAYER), colorSheet(NULL),_angler(NULL),_colorer(NULL),tolerance(DEFAULT_TOLERANCE){
}

WordLayer::~WordLayer(){
    delete colorSheet;
    delete _angler;
    delete _colorer;
}

bool WordLayer::contains(double x, double y, double width, double height, double rotation){
//    if (this->tree == NULL) {
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
                
                double r = sqrt(pow(relativeX, 2.0)+pow(relativeY, 2.0));
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
//    }
//    else {
//        return tree->overlapsCoord(tree->getFinalSeq(),x, y, x + width, y + height);
//    }
}


double WordLayer::getHue(int x, int y) {
    double colour = getHSB(x,y);
    if(isnan(colour) || ((unsigned int)colour >> 8 & 0xFF)==0)
        return NAN;
    else{
        //			Assert.isTrue(!isNaN(colour.hue));
        double h = ( ((unsigned int)colour & 0x00FF0000) >> 16);
        h/=255;
        return h;
    }
}

inline static double calculateConformity(vector<PolarPoint>* points, PixelImageShape* shape, double centerX, double centerY){
    map<unsigned,unsigned> stats;
//    double meanR = 0, meanG = 0, meanB = 0;
//    double M2 = 0;
    int validPoints = 0;
    for(int i=1;i<=points->size();i++){
        PolarPoint point = points->at(i-1);
        double x = centerX + cos(point.r) * point.d;
        double y = centerY + sin(point.r) * point.d;
        unsigned v = shape->getPixel((int)x, (int)y);
//        double r = v >> 16 & 0xFF;
//        double g = v >> 8 & 0xFF;
//        double b = v & 0xFF;
        int alpha = v >> 24 & 0xFF;
        if(alpha>0){
            validPoints++;
            stats[v]++;
        }
        if(stats.size()>8) return 1;

//        double deltaR = r - meanR, deltaG = g - meanG, deltaB = b - meanB;
//        meanR += deltaR/(double)i; meanG += deltaG/(double)i; meanB += deltaB/(double)i;
//        M2 += deltaR*(r - meanR)+deltaG*(g - meanG)+deltaB*(b - meanB);
    }
    int maxCount = 0;
    for(map<unsigned,unsigned>::iterator it = stats.begin();it!=stats.end();it++)
        if(maxCount<it->second)
            maxCount = it->second;
    return maxCount/(double)validPoints;
    
}



bool WordLayer::suitableForPlacement(double centerX, double centerY, vector<PolarPoint>* points, double rotation){
    bool contains = containsAllPolarPoints(centerX,centerY,points,rotation);
    if(!contains) return false;
    else{
        double colorConformity = calculateConformity(points, this->colorSheet, centerX, centerY);
//        double directionDiversity = calculateDiversity(points, this, centerX, centerY);
        return colorConformity >0.9;
//        printf("colorDiversity: %f, directionDiversity: %f\n", colorDiversity, directionDiversity);
        return true;
    }
}

void WordLayer::setTolerance(double v){
    tolerance = v;
}

WordLayer::ColorSheet* WordLayer::getColorSheet(){
    return colorSheet;
}

void WordLayer::setColorSheet(WordLayer::ColorSheet* colorSheet){
    this->colorSheet = colorSheet;
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
        unsigned int colour =  ColorMath::RGBtoHSB(rgbPixel);
        return colour;
    }
}


Angler* WordLayer::getAngler(){
    if(_angler==NULL){
        _angler = new ColorMapAngler(this, new MostlyHorizontalAngler());
        //				this._angler = new MostlyHorizAngler();
    }
    return _angler;
}

Colorer* WordLayer::getColorer(){
    if(_colorer==NULL){
        _colorer = new ColorSheetColorer(this, new TwoHueRandomSatsColorer());
        //				this._angler = new MostlyHorizAngler();
    }
    return _colorer;
}

