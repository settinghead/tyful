//
//  ZipOutput.h
//  cpp
//
//  Created by Xiyang Chen on 12/22/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef cpp_ZipOutput_h
#define cpp_ZipOutput_h

#include <string>
#include "zip.h"

#include "IZippable.h"
using namespace std;
class ZipOutput{
public:
    void putStringToFile(string filename, string data){
        //TODO
    }
    void putBinaryToFile(string filename, unsigned char* data, unsigned int length){
        //TODO
    }
    void putBitmapDataToPNGFile(string filename, unsigned int* data, const int width, const int height){
        //TODO
    }
    void process(IZippable* zippable, string dirName){
        //TODO
    }
    void zipUp(unsigned char*& data, int& length){
        //TODO
    }
    
};


#endif
