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
    PixelImageShape( unsigned int * pixels, int width, int height);
	~PixelImageShape();
	inline int getWidth(){
        return width;
    }
	inline int getHeight(){
        return height;
    }
    inline bool isEmpty(unsigned int pixelValue){
        return (pixelValue & 0x00FFFFFF) < 0xFFFFFF;
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
//    unsigned char * pixels;
};

#endif
