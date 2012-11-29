//
//  ColorSheetColorer.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ColorSheetColorer.h"
#include "WordLayer.h"
#include "structs.h"
#include "Patch.h"
#include "WordLayer.h"
ColorSheetColorer::ColorSheetColorer(WordLayer* layer, Colorer* otherwise){
    this->layer = layer;
    this->otherwise = otherwise;
}
unsigned int ColorSheetColorer::colorFor(Placement* place){
    unsigned int color;
    if(place->patch->getLayer()->getColorSheet()!=NULL)
        color = layer->getColorSheet()->getPixel(place->location.x, place->location.y);
    else
        color = otherwise->colorFor(place);
    return color;
}