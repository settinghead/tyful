//
//  ColorMapAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ColorMapAngler.h"
#include "../model/WordLayer.h"
#include "../constants.h"

ColorMapAngler::ColorMapAngler(WordLayer* layer, Angler* otherwise){
    this->layer = layer;
    this->otherwise = otherwise;
}

inline double ColorMapAngler::angleFor(EngineShape* shape){
    if (shape->getCurrentPlacement() == NULL)
        return otherwise->angleFor(shape);
    // float angle = (img.getHue(
    // (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
    // .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
    // % BBPolarTree.TWO_PI;
    double angle= (layer->getHue((int)shape->getCurrentPlacement()->location.x, (int)shape->getCurrentPlacement()->location.y) * TWO_PI);
    if (isnan(angle))
        return otherwise->angleFor(shape);
    else
        return angle;
}