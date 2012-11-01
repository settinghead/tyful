//Simple String Echo example
//mike chambers
//mchamber@adobe.com

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#include "ImageShape.h"
#include "BBPolarTreeBuilder.h"

#include "AS3/AS3.h"

//Header file for AS3 interop APIs
//this is linked in by the compiler (when using flaccon)

using namespace std;

// //Method exposed to ActionScript
// //Takes a String and echos it
// static AS3_Val buildTree(void* self, AS3_Val args) {

// //	makeTree(img,0);

// 	unsigned int width, height;
// 	AS3_Val src = AS3_Undefined();

// 	AS3_ArrayValue(args, "AS3ValType, IntType, IntType", &src, &width, &height);

// 	ImageShape* img = new ImageShape(src, width, height);
// 	BBPolarRootTreeVO* tree_ptr = makeTree(img, 0);

// 	return AS3_Ptr(tree_ptr);
// }

// static AS3_Val setRotation(void* self, AS3_Val args) {
// 	void *ptr;
// 	double rotation;
// 	AS3_ArrayValue(args, "PtrType, NumberType", &ptr, &rotation);
// 	((BBPolarRootTreeVO*) ptr)->setRotation(rotation);
// 	return AS3_Null();

// }

// static AS3_Val setLocation(void* self, AS3_Val args) {
// 	void *ptr;
// 	int x, y;
// 	AS3_ArrayValue(args, "PtrType, IntType, IntType", &ptr, &x, &y);
// 	((BBPolarRootTreeVO*) ptr)->setLocation(x, y);

// 	return AS3_Null();

// }
// static AS3_Val overlaps(void* self, AS3_Val args) {
// 	void *ptr1, *ptr2;
// 	AS3_ArrayValue(args, "PtrType, PtrType", &ptr1, &ptr2);
// 	bool result = ((BBPolarTreeVO*) ptr1)->overlaps((BBPolarTreeVO*) ptr2);
// 	return result ? AS3_True() : AS3_False();
// }

extern "C" void slapShape(){
	unsigned int * pixels = (unsigned int *) malloc(sizeof(unsigned char) * (200*200 + 1));
	ImageShape* img = new ImageShape(pixels, 200, 200);
	BBPolarRootTreeVO* tree_ptr = makeTree(img, 0);
}

int main() {

}
