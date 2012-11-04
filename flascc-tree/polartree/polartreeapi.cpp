#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <omp.h>
#include <sys/time.h>
#include <Flash++.h>

#include "ImageShape.h"
#include "BBPolarTreeBuilder.h"


// First we mark the function declaration with a GCC attribute specifying the
// AS3 signature we want it to have in the generated SWC. The function will
// be located in the sample.MurmurHash namespace.
void slapShape() __attribute__((used,
	annotate("as3sig:public function slapShape(pixels:int, width:int, height: int):Vector.<int>"),
	annotate("as3package:polartree.PolarTree")));

void slapShape()
{
    inline_as3("var coord:Vector.<int> = new Vector.<int>();\n");
    inline_as3("coord.push(%0);\n" : : "r"(rand() % 300 + 1));
    inline_as3("coord.push(%0);\n" : : "r"(rand() % 300 + 1));
    AS3_ReturnAS3Var(coord);
}
