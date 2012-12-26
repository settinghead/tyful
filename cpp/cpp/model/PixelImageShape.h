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
#include "../proto/template.pb.h"

class PixelImageShape : public ImageShape{
public:
    explicit PixelImageShape( unsigned int const * pixels, int width, int height, bool revert,bool rgbaToArgb);
    explicit PixelImageShape(unsigned char * png, size_t size);
	virtual ~PixelImageShape();
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
    
    void serialize(tyful::Image* image){
        image->set_width(width);
        image->set_height(height);
        image->set_data(pixels, sizeof(unsigned)*width*height);

    }

protected:
	unsigned int width, height;
    unsigned int total;
	unsigned int * pixels;
    unsigned int* convertToRGBALittleEndianPixels();
    
    
//    unsigned char * pixels;
};

#endif
