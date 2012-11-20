//
//  ColorMapAngler.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/18/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "ColorMapAngler.h"
#include "WordLayer.h"
#include "constants.h"

ColorMapAngler::ColorMapAngler(WordLayer* layer, Angler* otherwise){
    this->layer = layer;
    this->otherwise = otherwise;
}

double ColorMapAngler::angleFor(EngineShape* shape){
    if (shape->getCurrentPlacement() == NULL)
        return otherwise->angleFor(shape);
    // float angle = (img.getHue(
    // (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
    // .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
    // % BBPolarTree.TWO_PI;
    double angle= (layer->getHue(shape->getCurrentPlacement()->location.x, shape->getCurrentPlacement()->location.y) * TWO_PI);
    if (isnan(angle) || angle == 0)
        return otherwise->angleFor(shape);
    else
        return angle;
}