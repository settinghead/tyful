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

void initCanvas(){
	PolarCanvas::current = new PolarCanvas();
	PolarCanvas::current->setStatus(RENDERING);
	printf("Canvas initialized.\n");
}

void appendLayer(unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip){
    assert(width>0);
    assert(height>0);
	WordLayer* layer = new WordLayer(pixels, width, height,flip);
	if(colorPixels>0)
		layer->setColorSheet(new WordLayer::ColorSheet(colorPixels, width, height,flip));
    printf("Special point(5,5): %x\n", layer->getPixel(5,5));
	printf("Special point(600,400): %x\n", layer->getPixel(600,400));
	// layer->printStats();
    
	PolarCanvas::current->addLayer(layer);
}

void setPerseverance(int perseverance){
	PolarCanvas::current->setPerseverance(perseverance);
}

void feedShape(unsigned int *pixels, int width, int height,unsigned int sid)
{
	TextImageShape *shape = new TextImageShape(pixels, width, height, false);
	// shape->printStats();
	PolarCanvas::current->feedShape(shape,sid);
    pthread_cond_signal(&PolarCanvas::current->next_feed_cv);

}


void* renderRoutine(void*){
    PolarCanvas::current->setStatus(RENDERING);
    pthread_mutex_lock(&PolarCanvas::current->next_feed_mutex);
    while(((PolarCanvas*)PolarCanvas::current)->getStatus()>0){
        if(((PolarCanvas*)PolarCanvas::current)->pendingShapes->empty())
            pthread_cond_wait(&PolarCanvas::current->next_feed_cv, &PolarCanvas::current->next_feed_mutex);
        ((PolarCanvas*)PolarCanvas::current)->tryNextEngineShape();
        pthread_cond_signal(&((PolarCanvas*)PolarCanvas::current)->next_slap_cv);
    }
    pthread_mutex_unlock(&PolarCanvas::current->next_feed_mutex);

    
    return NULL;
}


void startRendering(){
    
    pthread_t       mainRountineThread;
    pthread_attr_t  attr;
    int             returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    pthread_create(&mainRountineThread, &attr, &renderRoutine, PolarCanvas::current);
}

int getStatus()
{
	return PolarCanvas::current->getStatus();
}

void setStatus(int status)
{
	PolarCanvas::current->setStatus(status);
}


double getShrinkage()
{
	return PolarCanvas::current->getShrinkage();
}

SlapInfo* getNextSlap(){
    if(PolarCanvas::current->slaps->empty()) return NULL;
    SlapInfo* info = PolarCanvas::current->slaps->front();
    PolarCanvas::current->slaps->pop();
    return info;
}