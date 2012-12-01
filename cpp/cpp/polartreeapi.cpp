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
#include <pthread.h>

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

void feedShape(void* canvas,unsigned int *pixels, int width, int height,unsigned int sid)
{
	TextImageShape *shape = new TextImageShape(pixels, width, height, false);
	// shape->printStats();
	((PolarCanvas*)canvas)->feedShape(shape,sid);
    pthread_cond_signal(&((PolarCanvas*)canvas)->next_feed_cv);

}


void* renderRoutine(void* _canvas){
    PolarCanvas* canvas = ((PolarCanvas*)_canvas);
    ((PolarCanvas*)canvas)->setStatus(RENDERING);
    pthread_mutex_lock(&canvas->next_feed_mutex);
    while(((PolarCanvas*)canvas)->getStatus()>0){
        if(((PolarCanvas*)canvas)->pendingShapes->empty())
            pthread_cond_wait(&canvas->next_feed_cv, &canvas->next_feed_mutex);
        ((PolarCanvas*)canvas)->tryNextEngineShape();
        pthread_cond_signal(&((PolarCanvas*)canvas)->next_slap_cv);
    }
    pthread_mutex_unlock(&canvas->next_feed_mutex);

    
    return NULL;
}


void startRendering(void* canvas){
    
    pthread_t       mainRountineThread;
    pthread_attr_t  attr;
    int             returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    pthread_create(&mainRountineThread, &attr, &renderRoutine, canvas);
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
