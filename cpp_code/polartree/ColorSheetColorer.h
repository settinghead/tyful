//
//  ColorSheetColorer.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#ifndef __PolarTree_Experiment__ColorSheetColorer__
#define __PolarTree_Experiment__ColorSheetColorer__
#include "Colorer.h"
class WordLayer;
struct Placement;

class ColorSheetColorer:public Colorer
{
    //		private var otherwise:WordColorer = new TwoHuesRandomSatsColorer();
public:
    ColorSheetColorer(WordLayer* layer, Colorer* otherwise);
    unsigned int colorFor(Placement* place);
private:
    WordLayer* layer;
    Colorer* otherwise;
};

#endif /* defined(__PolarTree_Experiment__ColorSheetColorer__) */
