#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/time.h>

#include "model/PolarCanvas.h"
#include "model/ImageShape.h"
#include "model/TextImageShape.h"
#include "tree/PolarTree.h"
#include "polartreeapi.h"
#include "tree/PolarRootTree.h"
#include "model/WordLayer.h"
#include "constants.h"
#include "ThreadControllers.h"
#include "model/structs.h"
#include "encoding/base64.h"
#include <assert.h>
#include <pthread.h>
#include <string>
#include <sstream>
#include "lib_json/json_tool.h"

using namespace std;

//pthread_t*       pendingMainRountineThread = NULL;
//pthread_t*       currentMainRountineThread = NULL;

void initCanvas(){
    pthread_mutex_lock(&PolarCanvas::threadControllers.stopping_mutex);
    if(PolarCanvas::current!=NULL && PolarCanvas::current->getStatus()>0){
        PolarCanvas::current->setStatus(-1);
//        pthread_cond_wait(&PolarCanvas::threadControllers.stopping_cv, &PolarCanvas::threadControllers.stopping_mutex);
        while(PolarCanvas::current->getStatus()!=0){
            pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_mutex);
            printf("initCanvas broadcasting a next_feed_cv signal.\n");
            pthread_cond_broadcast(&PolarCanvas::threadControllers.next_feed_cv);
            pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_mutex);
            usleep(5000);
        }
    }
    
//    if(PolarCanvas::current!=NULL)
//    PolarCanvas::current->fixShape(PolarCanvas::current->displayShapes->at(0)->getUid(),
//                                   PolarCanvas::current->displayShapes->at(0)->getFinalPlacement().location.x,
//                                   PolarCanvas::current->displayShapes->at(0)->getFinalPlacement().location.y, 0, 1, 1);

    PolarCanvas* newCanvas = new PolarCanvas();
    
    //transfer fixed shapes
    if(PolarCanvas::current!=NULL){
        assert(PolarCanvas::current->getStatus()==0);
        for (tr1::unordered_map<unsigned int,EngineShape*>::iterator it=PolarCanvas::current->fixedShapes.begin(); it != PolarCanvas::current->fixedShapes.end(); ++it ) {
            EngineShape* shape = it->second;
            newCanvas->registerShape(shape);
            newCanvas->fixShape(shape->getUid());
        }
        delete PolarCanvas::current;
    }
    
    PolarCanvas::current = newCanvas;
    printf("Canvas initialized. Ready to receive template bytes. numFixedShapes: %d\n", (int)PolarCanvas::current->fixedShapes.size());
    pthread_mutex_unlock(&PolarCanvas::threadControllers.stopping_mutex);
}

void modifyCanvas(){
    pthread_mutex_lock(&PolarCanvas::threadControllers.stopping_mutex);
    if(PolarCanvas::current!=NULL && PolarCanvas::current->getStatus()>0){
        PolarCanvas::current->setStatus(-1);
        //        pthread_cond_wait(&PolarCanvas::threadControllers.stopping_cv, &PolarCanvas::threadControllers.stopping_mutex);
        while(PolarCanvas::current->getStatus()!=0){
            pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_mutex);
            printf("initCanvas broadcasting a next_feed_cv signal.\n");
            pthread_cond_broadcast(&PolarCanvas::threadControllers.next_feed_cv);
            pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_mutex);
            usleep(5000);
        }
    }
    
    //reset failure count
    assert(PolarCanvas::current->getStatus()==0);
    PolarCanvas::current->reset();
    
    //remove shapes that collides with fixed shapes

    for (tr1::unordered_map<unsigned int,EngineShape*>::iterator it=PolarCanvas::current->fixedShapes.begin(); it != PolarCanvas::current->fixedShapes.end(); ++it ) {
        EngineShape* shape = it->second;
        vector<int> collides = PolarCanvas::current->getShapesCollidingWith(shape->getUid());
        for (vector<int>::iterator sit=collides.begin(); sit != collides.end(); ++sit ){
            int sid = *sit;
            PolarCanvas::current->removeShape(sid);
        }
    }
    
    printf("Canvas modified. Ready to resume rendering. \n");
    pthread_mutex_unlock(&PolarCanvas::threadControllers.stopping_mutex);
}

void appendLayer(unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip,bool rgbaToArgb){
    assert(width>0);
    assert(height>0);
	WordLayer* layer = new WordLayer(pixels, width, height, PolarCanvas::current==NULL?0:(int)PolarCanvas::current->size(), flip,rgbaToArgb);

	if(colorPixels>0){
		layer->setColorSheet(new WordLayer::ColorSheet(colorPixels, width, height,flip,rgbaToArgb));
        layer->getColorSheet()->printStats();
    }

    printf("Special point(5,5): %x, isEmpty: %d\n", layer->getPixel(5,5), layer->isEmpty(layer->getPixel(5,5)));
	printf("Special point(600,400): %xisEmpty: %d\n", layer->getPixel(600,400), layer->isEmpty(layer->getPixel(600,400)));
	layer->printStats();
    
	PolarCanvas::current->addLayer(layer);
}

void appendLayer(unsigned int *combinedPixels,int width, int height,bool flip,bool rgbaToArgb){
    size_t size = width * height;
    appendLayer(combinedPixels, combinedPixels+size, width, height, flip, rgbaToArgb);
}

void appendLayer(unsigned char *png, size_t png_size){
    WordLayer* layer = new WordLayer(png,png_size,(int)PolarCanvas::current->size());
    printf("Special point(5,5): %x\n", layer->getPixel(5,5));
	printf("Special point(600,400): %x\n", layer->getPixel(600,400));    
	PolarCanvas::current->addLayer(layer);
}

void setPerseverance(int perseverance){
	PolarCanvas::current->setPerseverance(perseverance);
}



void updateTemplate(unsigned int* data){
//    unsigned int* data = (unsigned int*)base64_str.c_str();
    initCanvas();
    int counter = 0;
    int numLayers = data[counter++];
    printf("numLayers: %d\n",numLayers);
    
    assert(numLayers>0 && numLayers<500);
    for(int i=0;i<numLayers;i++){
        int directionWidth = data[counter++];
        int directionHeight = data[counter++];
        int directionLength = data[counter++]/sizeof(unsigned int *);
        int directionStart = counter;
        printf("dirWidth: %d, dirHeight, %d, dirLength: %d, dirStart: %d\n",directionWidth,directionHeight,directionLength,directionStart);
        counter+=directionLength;
        int colorWidth = data[counter++];
        printf("a\n");
        int colorHeight = data[counter++];
        int colorLength = data[counter++];
        int colorStart = counter;
        printf("coloWidth: %d, colorHeight, %d, colorLength: %d, colorStart: %d\n",colorWidth,colorHeight,colorLength,colorStart);

        appendLayer(data+directionStart, data+colorStart, directionWidth, directionHeight, true,false);
    }
}

void updateTemplate(unsigned int *zipData,int size){
    //TODO
}

void feedShape(unsigned int* data, double shrinkage){
//    unsigned int* data = (unsigned int*)base64_str.c_str();
    int counter = 0;
    unsigned int sid = data[counter++];
    int width = data[counter++];
    int height = data[counter++];
    feedShape(data+counter, width, height, sid,false,false,shrinkage);
}

void feedShape(unsigned int *pixels, int width, int height,unsigned int sid,bool flip,bool rgbaToArgb, double shrinkage)
{
//    try{
//    assert(shrinkage>=getShrinkage());
    if(PolarCanvas::current->pendingShapes.size()<FEED_QUEUE_BUFFER){
        TextImageShape *shape = new TextImageShape(pixels, width, height, flip,rgbaToArgb);
        // shape->printStats();
        PolarCanvas::current->feedShape(shape,sid);
            pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_mutex);
            printf("feedShape broadcasting a next_feed_cv signal.\n");
            pthread_cond_broadcast(&PolarCanvas::threadControllers.next_feed_cv);
            pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_mutex);
    //        }
    //    }
    //    catch(int e){
    //        printf("An exception occurred. Exception Nr. %d\n",e);
    //    }
    }

}

SlapInfo* slapShape(unsigned int *pixels, int width, int height,unsigned int sid)
{
    feedShape(pixels, width, height,sid,false,false,getShrinkage());
    return tryNextShape();
}

SlapInfo* tryNextShape()
{
    ((PolarCanvas*)PolarCanvas::current)->tryNextEngineShape();
    return getNextSlap();
}
void* renderRoutine(void*){
//    if(PolarCanvas::current!=NULL){
    PolarCanvas* canvas = PolarCanvas::current;
        canvas->setStatus(RENDERING);
//        try{
            printf("internal render routine started.\n");
            pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_mutex);

            while(canvas->getStatus()>0){
                    if(canvas->pendingShapes.size()<FEED_QUEUE_BUFFER){
//                        for(int i=(int)canvas->pendingShapes.size();i<FEED_QUEUE_BUFFER;i++){
                            pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_req_mutex);
                            pthread_cond_broadcast(&PolarCanvas::threadControllers.next_feed_req_cv);
                            printf("renderRoutine is broadcasting a next_feed_req_cv signal. Current queue size: %ld\n", canvas->pendingShapes.size());
                            pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_req_mutex);
//                        }
                    }
                if(canvas->pendingShapes.empty())
                    printf("Render routine waiting on next_feed_cv...\n");
                    pthread_cond_wait(&PolarCanvas::threadControllers.next_feed_cv, &PolarCanvas::threadControllers.next_feed_mutex);
                    printf("Render routine wait is over on next_feed_cv.\n");
                    if(canvas->getStatus()>0)
                    {
                        pthread_mutex_lock(&PolarCanvas::threadControllers.stopping_mutex);
                        canvas->tryNextEngineShape();
                        pthread_mutex_unlock(&PolarCanvas::threadControllers.stopping_mutex);
                        pthread_mutex_lock(&PolarCanvas::threadControllers.next_slap_req_mutex);
                        pthread_cond_broadcast(&PolarCanvas::threadControllers.next_slap_req_cv);
                        pthread_mutex_unlock(&PolarCanvas::threadControllers.next_slap_req_mutex);
                    }
            }
        pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_mutex);

//        }
//        catch(int e){
//            printf("Exception! No. %d\n",e);
//        }

//        pthread_mutex_lock(&PolarCanvas::threadControllers.stopping_mutex);
//        pthread_cond_broadcast(&PolarCanvas::threadControllers.stopping_cv);
//        pthread_mutex_unlock(&PolarCanvas::threadControllers.stopping_mutex);
        printf("Render completed. Sucess rate: %f\n", canvas->getSuccessRate());
        ((PolarCanvas*)PolarCanvas::current)->setStatus(0);

        return NULL;
//    }
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
//    PolarCanvas::current->setStatus(RENDERING);
//
//    while(((PolarCanvas*)PolarCanvas::current)->getStatus()>0){
//        ((PolarCanvas*)PolarCanvas::current)->tryNextEngineShape();
//        pthread_cond_broadcast(&PolarCanvas::threadControllers.next_slap_req_cv);
//        pthread_cond_broadcast(&PolarCanvas::threadControllers.next_feed_req_cv);
//
//    }

}

//void pauseRendering(){
//    PolarCanvas::current->setStatus(PAUSED);
//}

int getStatus()
{
    if(PolarCanvas::current!=NULL)
        return PolarCanvas::current->getStatus();
    else return 0;
}

void setStatus(int status)
{
	PolarCanvas::current->setStatus(status);
}

unsigned int getNumberOfPendingShapes(){
    return (unsigned int)PolarCanvas::current->pendingShapes.size();
}


double getShrinkage()
{
	return PolarCanvas::current->getShrinkage();
}

SlapInfo* getNextSlap(){
    if(PolarCanvas::current->slaps.empty()) return NULL;
    SlapInfo* info = PolarCanvas::current->slaps.front();
    PolarCanvas::current->slaps.pop();
    
    //DEBUG
//    info->location.x = 200;
//    info->location.y = 200;

    return info;
}

Dimension getCanvasSize(){
    Dimension d;
    d.width = (int)PolarCanvas::current->getWidth();
    d.height = (int)PolarCanvas::current->getHeight();
    return d;
}

void resetFixedShapes(){
    PolarCanvas::current->resetFixedShapes();
}
string setFixedShape(int sid, double x, double y, double rotation,double scaleX,double scaleY){
    PolarCanvas::current->fixShape(sid,x, y, rotation,scaleX,scaleY);
    vector<int> overlaps = PolarCanvas::current->getShapesCollidingWith(sid);
    std::stringstream ss;
    ss << sid << ",";
    for(int i=0;i<overlaps.size();i++)
        ss << overlaps.at(i) << ",";
    return ss.str();
}

void loadTemplateFromSeiralization(unsigned char *data, int length){
    //TODO
}
void serializeTemplate(unsigned int* previewPixels, int width, int height, unsigned char*& data, int& length){
    //TODO
}
void serializeTemplate(unsigned char* previewPng, int len, unsigned char*& data, int& length){
    //TODO
}