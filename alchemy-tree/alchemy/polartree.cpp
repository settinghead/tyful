//Simple String Echo example
//mike chambers
//mchamber@adobe.com

#include <stdlib.h>
#include <stdio.h>
#include "AS3.h"

#include "BBPolarTreeBuilder.h"
#include "ImageShape.h"

//Header file for AS3 interop APIs
//this is linked in by the compiler (when using flaccon)

using namespace std;
using namespace polartree;

static int counter;

//Method exposed to ActionScript
//Takes a String and echos it
static AS3_Val buildTree(void* self, AS3_Val args) {

//	makeTree(img,0);

	unsigned int width, height;
	AS3_Val src = AS3_Undefined();

	AS3_ArrayValue(args, "AS3ValType, IntType, IntType", &src, &width, &height);

	ImageShape* img = new ImageShape(src, width, height);
	BBPolarRootTreeVO* tree_ptr = makeTree(img, 0);
//
//
//	sprintf(str, "%d, %d, %d, %x,%x,%x,%x,%x,%x,%x,%x", width, height, len,
//			((unsigned int *) pixels)[0],
//			((unsigned int *) pixels)[1],
//			((unsigned int *) pixels)[2],
//			((unsigned int *) pixels)[3],
//			((unsigned int *) pixels)[4],
//			((unsigned int *) pixels)[5],
//			((unsigned int *) pixels)[6],
//			((unsigned int *) pixels)[7]);

//otherwise, return the string that was passed in
	return AS3_Ptr(tree_ptr);
}

static AS3_Val setRotation(void* self, AS3_Val args) {
	void *ptr;
	double rotation;
	AS3_ArrayValue(args, "PtrType, NumberType", &ptr, &rotation);
	((BBPolarRootTreeVO*) ptr)->setRotation(rotation);
	return AS3_Null();

}

static AS3_Val setLocation(void* self, AS3_Val args) {
	void *ptr;
	int x, y;
	AS3_ArrayValue(args, "PtrType, IntType, IntType", &ptr, &x, &y);
	((BBPolarRootTreeVO*) ptr)->setLocation(x, y);

	return AS3_Null();

}
static AS3_Val overlaps(void* self, AS3_Val args) {
	void *ptr1, *ptr2;
	AS3_ArrayValue(args, "PtrType, PtrType", &ptr1, &ptr2);
	bool result = ((BBPolarTreeVO*) ptr1)->overlaps((BBPolarTreeVO*) ptr2);
	return result ? AS3_True() : AS3_False();

}

//entry point for code
int main() {
	//define the methods exposed to ActionScript
	//typed as an ActionScript Function instance
	AS3_Val buildTreeMethod = AS3_Function(NULL, buildTree);
	AS3_Val setLocationMethod = AS3_Function(NULL, setLocation);
	AS3_Val setRotationMethod = AS3_Function(NULL, setRotation);
	AS3_Val overlapsMethod = AS3_Function(NULL, overlaps);

	// construct an object that holds references to the functions
	AS3_Val result =
			AS3_Object(
					"buildTree: AS3ValType, setLocation: AS3ValType, setRotation: AS3ValType, overlaps: AS3ValType",
					buildTreeMethod, setLocationMethod, setRotationMethod,
					overlapsMethod);
	// Release
	AS3_Release(buildTreeMethod);
	AS3_Release(setLocationMethod);
	AS3_Release(setRotationMethod);
	AS3_Release(overlapsMethod);

	// notify that we initialized -- THIS DOES NOT RETURN!
	AS3_LibInit(result);

	// should never get here!
	return 0;
}
