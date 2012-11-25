

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
    virtual inline bool isEmpty(unsigned int pixelValue) = 0;

    inline bool containsPoint(int x, int y){
        return !isEmpty(getPixel(x, y));
    }
	inline bool intersects(int x, int y, int width, int height){
        if(x>=getWidth()) x=getWidth()-1;
        else if (x<0) x=0;
        if(y>=getHeight()) y=getHeight()-1;
        else if (y<0) y=0;
        
        int cmp = getPixel(x, y);
        for (int yy = y; yy < y+height && yy <getHeight(); yy++) {
            for (int xx = x; xx < x+width && xx < getWidth(); xx++) {
                //            if(pixels[yy * width + xx] >0)
                //                std::cout << (unsigned int)pixels[yy * width + xx] << ",";
                if (getPixel(xx,yy) != cmp)
                    return true;
            }
            //        std::cout << "\n";
        }
        return false;
    }

	inline bool contains(int x, int y, int width, int height){
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
    PolarRootTree* getTree();
protected:
    PolarRootTree* tree;
};
#endif

