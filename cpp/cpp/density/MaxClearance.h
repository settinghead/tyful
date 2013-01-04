//
//  MaxClearance.h
//  cpp
//
//  Created by Xiyang Chen on 1/2/13.
//  Copyright (c) 2013 settinghead. All rights reserved.
//

#ifndef __cpp__MaxClearance__
#define __cpp__MaxClearance__
#include "../constants.h"
#include "../model/PixelImageShape.h"
#include <math.h>
#include <vector.h>
#define EAST 1
#define WEST -1
#define UPPER 0
#define SELF 1
#define LOWER 2

struct Vertex{
    Vertex(double x,double y):x(x),y(y),subsumed(false),selected(false),
    upperBound(INFINITY),lowerBound(-INFINITY),upper(NULL),lower(NULL){
        
    }
    double x,y;
    vector<Vertex*> onPath;
    double upperBound,lowerBound;
    Vertex* upper; Vertex* lower;
    inline double getIntersectionY(Vertex* vertex, int x){
        //calculate y coordinate of intersection
        double midY = (double)(vertex->y + this->y) / 2;
        if(vertex->x == this->x)
            return midY;
        else{
			double midX = (vertex->x + this->x) / 2;
            double atanRatio = (vertex->y-this->y)/(double)(vertex->x-this->x);
            return midY - (x-midX) / atanRatio;
        }
    }
    inline bool isSubsumed(){return subsumed;}
    inline bool isSelected(){return selected;}
    inline void setSubsumed(){assert(selected); subsumed = true;}
    inline void setSelected(){ selected = true;}
private:
    bool subsumed, selected;
};

class MaxClearance:public PixelImageShape{
private:
    double* distData;
    inline int getAlpha(int x, int y){
        return getPixel(x, y) >> 24 & 0xFF;
    }
    int ww,hh;
    
    typedef int Where;
    
    inline static Vertex* subsume(Vertex* vk, Vertex* vj, Vertex* &begin, Vertex* &end){
        vk->setSubsumed();
        if(vk->upper!=NULL) vk->upper->lower = vk->lower;
        if(vk->lower!=NULL) vk->lower->upper = vk->upper;
        vj->upperBound = vk->upperBound;
        vj->lowerBound = vk->lowerBound;
        if(begin == vk) begin = vj; if(end == vk) end = vj;
        //        assert(vj->upper!=vj&&vj->lower!=vj);
        return vk;
    }
    
    inline static void updateBounds(Vertex* v, int xc){
        if(v->upper!=NULL) v->upper->lowerBound = v->upperBound = v->getIntersectionY(v->upper, xc);
        if(v->lower!=NULL) v->lower->upperBound = v->lowerBound = v->getIntersectionY(v->lower, xc);
    }
    
    inline static double distance(double x1,double y1,double x2,double y2){
        return sqrt(pow(y2-y1,2)+pow(x2-x1,2));
    }
    
    inline static void connect(Vertex* pos, Vertex* v, Where where, Vertex* &begin, Vertex* &end){
        switch(where){
            case UPPER:
                if(pos->upper!=NULL){
                    pos->upper->lower = v;
                    v->upper = pos->upper;
                }
                pos->upper = v;
                v->lower = pos;
                if(end==pos) end = v;
                break;
            case SELF:
                if(pos->upper!=NULL){
                    pos->upper->lower = v;
                    v->upper = pos->upper;
                }
                if(pos->lower!=NULL){
                    pos->lower->upper = v;
                    v->lower = pos->lower;
                }
                break;
            case LOWER:
                if(pos->lower!=NULL){
                    pos->lower->upper = v;
                    v->lower = pos->lower;
                }
                pos->lower = v;
                v->upper = pos;
                if(begin==pos) begin = v;
                break;
        }
        assert(v->upper!=v&&v->lower!=v);
    }
    
    inline double getMinBorderDistance(double x, double y){
        double minXBorderDist,minYBorderDist;
        if(x>(double)width/2) minXBorderDist = width - x;
        else minXBorderDist = x;
        if(y>(double)height/2) minYBorderDist = height - y;
        else minYBorderDist = y;
        return (minXBorderDist < minYBorderDist)?minXBorderDist:minYBorderDist;
    }
    
    inline void sweep(int direction){
        Vertex** A;
        Vertex* begin = NULL; Vertex* end = NULL;
        A = (Vertex**)malloc(height*sizeof(Vertex*));
        int nn = direction > 0 ? width : 0;
        for(int xc  = direction > 0 ? 0 : width - MAXCLEAR_UNIT; xc * direction < nn; xc += direction*MAXCLEAR_UNIT){
            int xx = xc/MAXCLEAR_UNIT;
            for(int y = 0; y < height; y+=MAXCLEAR_UNIT){
                int yy = y/MAXCLEAR_UNIT;
                A[yy] = NULL;
                int alpha = getAlpha(xc,y);
                if(alpha == 0){
                    A[yy] = new Vertex(xc,y);
                }
            }
            for(int j=0;j<height;j+=MAXCLEAR_UNIT){
                Vertex* vj = *(A+j/MAXCLEAR_UNIT);
                if(vj!=NULL&&!vj->isSubsumed()&&!vj->isSelected()){
                    if(begin==NULL){
                        begin = end = vj;
                        vj->setSelected();
                    }
                    else{
                        bool entered_range = false;
                        Vertex* pos = NULL; Where where;
                        Vertex* vk = end;
                        while(vk!=NULL){
                            if(!vk->isSubsumed()){
                                double y = vj->getIntersectionY(vk, xc);
                                if(vj->y > vk->y){
                                    if (y<vk->lowerBound){
                                        pos = subsume(vk,vj,begin,end); where = SELF;
                                        //                                            updateBounds(vj,xc);
                                        if(!entered_range) entered_range = true;
                                    }
                                    else if (y < vk->upperBound){
                                        pos = vk; where = UPPER;
                                        //                                            updateBounds(vj, xc);
                                        if(!entered_range) entered_range = true;
                                    }
                                    else if(entered_range) break;
                                }
                                else if(vj->y==vk->y){
                                    pos = subsume(vk,vj,begin,end); where = SELF;
                                    //                                        updateBounds(vj, xc);
                                    if(!entered_range) entered_range = true;
                                }
                                else{
                                    if(y>vk->upperBound){
                                        pos = subsume(vk,vj,begin,end);where = SELF;
                                        //                                            updateBounds(vj,xc);
                                        if(!entered_range) entered_range = true;
                                    }
                                    else if(y>vk->lowerBound){
                                        pos = vk; where = LOWER;
                                        //                                            updateBounds(vj, xc);
                                        if(!entered_range) entered_range = true;
                                    }
                                    else if(entered_range) break;
                                }
                            }
                            vk = vk->lower;
                        }
                        if(entered_range){
                            connect(pos,vj,where,begin,end);
                            if(pos->isSubsumed()) delete pos;
                            updateBounds(vj,xc);
                            vj->setSelected();
                        }
                    }
                }
            }
            if(begin!=NULL){
                Vertex* v = begin;
                for(int y =0; y<height;y+=MAXCLEAR_UNIT){
                    int yy = y/MAXCLEAR_UNIT;
                    if(y>v->upperBound&&v->upper!=NULL)
                        v = v->upper;
                    if(getAlpha(xc,y)>0){
                        double dist = distance(xc,y,v->x,v->y);
                        double minBorderDist = getMinBorderDistance(xc,y);
                        if(minBorderDist < dist) dist = minBorderDist;
                        if(dist>maxdist) maxdist = dist;
                        int index = xx+yy*ww;
                        if(isnan(distData[index]) || distData[index] > dist)
                            distData[index] = dist;
                    }
                }
            }
        }
        delete A;
    }
    void init(){
        ww = width/MAXCLEAR_UNIT; hh = height/MAXCLEAR_UNIT;
        distData = (double*)malloc(ww*hh*sizeof(double));
        for(int xx=0;xx<ww;xx++)
            for(int yy=0;yy<hh;yy++)
                distData[xx+yy*(int)ww] = NAN;
    }
    
public:
    double maxdist;
    
    MaxClearance(unsigned const * pixels, int width, int height, bool revert,bool rgbaToArgb):PixelImageShape(pixels,width,height,revert,rgbaToArgb){
        init();
    }
    
    MaxClearance(unsigned char * png, size_t size):PixelImageShape(png,size){
        init();
    }
    
    inline double getDistData(int x, int y){
        return distData[x/MAXCLEAR_UNIT+y/MAXCLEAR_UNIT*ww];
    }
    
    virtual ~MaxClearance(){
        delete distData;
    }
    
    void compute(){
        maxdist = 0;
        sweep(EAST);
        sweep(WEST);
    }
    
    
};

#endif /* defined(__cpp__MaxClearance__) */
