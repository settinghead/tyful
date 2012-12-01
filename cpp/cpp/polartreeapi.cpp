#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/time.h>

#include "model/PolarCanvas.h"
#include "model/ImageShape.h"
#include "model/TextImageShape.h"
#include "tree/PolarTree.h"
#include "tree/PolarRootTree.h"
#include "model/WordLayer.h"
#include "constants.h"
#include "model/structs.h"
#include <assert.h>

void* initCanvas(){
	PolarCanvas* canvas = new PolarCanvas();
	canvas->setStatus(RENDERING);
	printf("Canvas initialized.\n");
    return canvas;
}

void appendLayer(void* canvas,unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip){
    assert(width>0);
    assert(height>0);
	WordLayer* layer = new WordLayer(pixels, width, height,flip);
	if(colorPixels>0)
		layer->setColorSheet(new WordLayer::ColorSheet(colorPixels, width, height,flip));
    printf("Special point(5,5): %x\n", layer->getPixel(5,5));
	printf("Special point(600,400): %x\n", layer->getPixel(600,400));
	// layer->printStats();
    
	((PolarCanvas*)canvas)->addLayer(layer);
}

void setPerseverance(void* canvas,int perseverance){
	((PolarCanvas*)canvas)->setPerseverance(perseverance);
}

SlapInfo* slapShape(void* canvas,unsigned int *pixels, int width, int height)
{
	TextImageShape *shape = new TextImageShape(pixels, width, height, false);
	// shape->printStats();
	Placement* placement = ((PolarCanvas*)canvas)->slapShape(shape);

	if(placement!=NULL){
		printf("Coord: %f, %f; rotation: %f, color: 0x%x\n"
			,shape->getTree()->getTopLeftLocation(shape->getTree()->getFinalSeq()).x
			,shape->getTree()->getTopLeftLocation(shape->getTree()->getFinalSeq()).y
			,shape->getTree()->getRotation(shape->getTree()->getFinalSeq()),placement->color);
        SlapInfo* place = new SlapInfo;
        place->location = shape->getTree()->getTopLeftLocation(shape->getTree()->getFinalSeq());
        place->rotation = shape->getTree()->getRotation(shape->getTree()->getFinalSeq());
        place->color = placement->color;
        place->failureCount = ((PolarCanvas*)canvas)->getFailureCount();
        
//    	double coord[5];
//    	coord[0] = shape->getTree()->getTopLeftLocation(shape->getTree()->getFinalSeq()).x;
//    	coord[1] = shape->getTree()->getTopLeftLocation(shape->getTree()->getFinalSeq()).y;
//    	coord[2] = shape->getTree()->getRotation(shape->getTree()->getFinalSeq());
//    	coord[3] = placement->color;
//    	coord[4] = canvas->getFailureCount();
//    	return coord;
        return place;
	}
	return NULL;
}

int getStatus(void* canvas)
{
	return ((PolarCanvas*)canvas)->getStatus();
}

void setStatus(void* canvas,int status)
{
	((PolarCanvas*)canvas)->setStatus(status);
}


double getShrinkage(void* canvas)
{
	return ((PolarCanvas*)canvas)->getShrinkage();
}
