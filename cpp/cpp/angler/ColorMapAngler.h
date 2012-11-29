//
//  ColorMapAngler.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ColorMapAngler__
#define __PolarTree_Experiment__ColorMapAngler__
#include "Angler.h"

class WordLayer;
class ColorMapAngler: public Angler{
public:
    ColorMapAngler(WordLayer* layer, Angler* otherwise);
    inline double angleFor(EngineShape* shape);
private:
    WordLayer* layer;
    Angler* otherwise;
};
#endif /* defined(__PolarTree_Experiment__ColorMapAngler__) */
