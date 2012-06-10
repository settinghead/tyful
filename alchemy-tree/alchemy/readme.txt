Mike Chambers
mesh@adobe.com

stringecho

Simple example that shows how to create a C class that takes a String from ActionScript and then returns the same string.

To compile into a SWC:

flaccon
gcc stringecho.c -O3 -Wall -swc -o stringecho.swc

Contents:

stringecho.c - c code that contains echo method.

as3/ - Folder that contains a simple ActionScript project that loads the SWC generated from c code, and calls the echo method.