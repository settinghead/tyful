//
//  Header.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/8/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef PIXELIMAGESHAPE_H
#define PIXELIMAGESHAPE_H
#include "ImageShape.h"
#include "EngineShape.h"

class PixelImageShape : public ImageShape{
public:
    PixelImageShape( unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb);
    PixelImageShape(unsigned char * png, size_t size);
	~PixelImageShape();
    virtual bool isEmpty(unsigned int pixelValue) = 0;
    unsigned char * toPng(unsigned int pixelValue);

    void printStats();

	inline int getWidth(){
        return width;
    }
	inline int getHeight(){
        return height;
    }
	inline unsigned int getPixel(int x, int y){
        //    return    this->img->getPixel(x,y);
        //    return pixels[x * height + y];

        if(x>=width||y>=height||x<0||y<0)
            return 0x00000000;
        else
            return pixels[y * width + x];
    }

protected:
	unsigned int width, height;
    unsigned int total;
	unsigned int * pixels;
    unsigned int* convertToRGBALittleEndianPixels();
    
//    unsigned char * pixels;
};

#endif
