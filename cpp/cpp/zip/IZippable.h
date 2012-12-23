//
//  IZippable.h
//  cpp
//
//  Created by Xiyang Chen on 12/22/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef cpp_IZippable_h
#define cpp_IZippable_h
#include <tr1/unordered_map>
#include <string>

class ZipOutput;
class ZipInput;

class IZippable{
public:
    virtual void writeNonJSONPropertiesToZip(ZipOutput* output) = 0;
    virtual void readNonJSONPropertiesFromZip(ZipInput* input) = 0;
    virtual void saveProperties(std::tr1::unordered_map<std::string, std::string> &dict) = 0;
};

#endif
