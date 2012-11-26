#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <omp.h>
#include <sys/time.h>
#include <Flash++.h>

#include "../cpp_common/polartree/PolarCanvas.h"
#include "../cpp_common/polartree/ImageShape.h"
#include "../cpp_common/polartree/TextImageShape.h"
#include "../cpp_common/polartree/PolarTree.h"
#include "../cpp_common/polartree/PolarRootTree.h"
#include "../cpp_common/polartree/WordLayer.h"
#include "../cpp_common/polartree/constants.h"
#include "../cpp_common/polartree/structs.h"

#include <assert.h>

// First we mark the function declaration with a GCC attribute specifying the
// AS3 signature we want it to have in the generated SWC. The function will
// be located in the sample.MurmurHash namespace.

PolarCanvas* canvas;

void initCanvas() __attribute__((used,
	annotate("as3sig:public function initCanvas(_pixels:int, _width:int, _height: int):void"),
	annotate("as3package:com.settinghead.tyful.client.algo.PolarTree")));

void initCanvas(){

	unsigned char *pixels = (unsigned char *) 0 ;
	int width = 0 ;
	int height = 0 ;

    AS3_GetScalarFromVar(pixels, _pixels);
    AS3_GetScalarFromVar(width, _width);
    AS3_GetScalarFromVar(height, _height);

    assert(width>0);
    assert(height>0);

	WordLayer* layer = new WordLayer((unsigned int const *)pixels, width, height,true);
	printf("Special point(5,5): %x\n", layer->getPixel(5,5));
	printf("Special point(600,400): %x\n", layer->getPixel(600,400));
	layer->printStats();
	canvas = new PolarCanvas();
	canvas->getLayers()->push_back(layer);
	canvas->setStatus(RENDERING);
	printf("Canvas initialized.\n");
}

void slapShape() __attribute__((used,
	annotate("as3sig:public function slapShape(_pixels:int, _width:Number, _height: Number):Vector.<Number>"),
	annotate("as3package:com.settinghead.tyful.client.algo.PolarTree")));

void slapShape()
{
	printf("slapShape requested. Current shrinkage: %f\n", canvas->getShrinkage());
	unsigned int *pixels = (unsigned int *) 0 ;
	double width = 0 ;
	double height = 0 ;

    AS3_GetScalarFromVar(pixels, _pixels);
    AS3_GetScalarFromVar(width, _width);
    AS3_GetScalarFromVar(height, _height);


	TextImageShape *shape = new TextImageShape((unsigned int *)pixels, width, height,false);
	shape->printStats();
	Placement* placement = canvas->slapShape(shape);

	if(placement!=NULL){
		printf("Coord: %f, %f; rotation: %f\n"
			,shape->getTree()->getTopLeftLocation().x
			,shape->getTree()->getTopLeftLocation().y
			,shape->getTree()->getRotation());

    	inline_as3("var coord:Vector.<Number> = new Vector.<Number>();\n");
    	inline_as3("coord.push(%0);\n" : : "r"(shape->getTree()->getTopLeftLocation().x));
    	inline_as3("coord.push(%0);\n" : : "r"(shape->getTree()->getTopLeftLocation().y));
    	inline_as3("coord.push(%0);\n" : : "r"(shape->getTree()->getRotation()));
    	AS3_ReturnAS3Var(coord);
	}
}

void getStatus() __attribute__((used,
	annotate("as3sig:public function getStatus():int"),
	annotate("as3package:com.settinghead.tyful.client.algo.PolarTree")));

void getStatus()
{
	inline_as3("var status:int = (%0);\n" : : "r"(canvas->getStatus()));
	AS3_ReturnAS3Var(status);
}

void getShrinkage() __attribute__((used,
	annotate("as3sig:public function getShrinkage():Number"),
	annotate("as3package:com.settinghead.tyful.client.algo.PolarTree")));

void getShrinkage()
{
	inline_as3("var shrinkage:Number = (%0);\n" : : "r"(canvas->getShrinkage()));
	AS3_ReturnAS3Var(shrinkage);
}
