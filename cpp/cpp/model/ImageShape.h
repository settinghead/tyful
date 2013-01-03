

#ifndef IIMAGESHAPE_H
#define IIMAGESHAPE_H
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
class PolarRootTree;

class ImageShape {
public:
    ImageShape();
    virtual ~ImageShape();
    virtual bool isEmpty(unsigned int pixelValue) = 0;
    virtual unsigned char * toPng(unsigned int pixelValue) = 0;

    inline bool containsPoint(double x, double y){
        return !isEmpty(getPixel((int)x, (int)y));
    }
	inline bool intersects(double x, double y, double width, double height){
        if(x>=getWidth()) x=getWidth()-1;
        else if (x<0) x=0;
        if(y>=getHeight()) y=getHeight()-1;
        else if (y<0) y=0;
        
        int cmp = getPixel((int)x, (int)y);
        for (int yy = (int)y; yy < (int)y+(int)height && yy <(int)getHeight(); yy++) {
            for (int xx = (int)x; xx < (int)x+(int)width && xx < (int)getWidth(); xx++) {
                //            if(pixels[yy * width + xx] >0)
                //                std::cout << (unsigned int)pixels[yy * width + xx] << ",";
                if (getPixel(xx,yy) != cmp)
                    return true;
            }
            //        std::cout << "\n";
        }
        return false;
    }

	virtual inline bool contains(int x, int y, int width, int height){
        if (intersects(x, y, width, height)) {
            return false;
        } else {
            int rX = ((width==0)?0:rand() % width)+x;
            int rY = ((height==0)?0:rand() % height)+y;
            if(rX>=getWidth()) rX=getWidth()-1;
            else if (rX<0) rX=0;
            if(rY>=getHeight()) rY=getHeight()-1;
            else if (rY<0) rY=0;
            return containsPoint(rX, rY);
        }
    }
	virtual int getWidth() = 0;
	virtual int getHeight() = 0;
	virtual unsigned int getPixel(int x, int y) = 0;
};
#endif

