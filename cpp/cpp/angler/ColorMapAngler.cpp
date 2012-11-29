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

inline double ColorMapAngler::angleFor(int seq,EngineShape* shape){
    if (shape->getCurrentPlacement(seq) == NULL)
        return otherwise->angleFor(seq,shape);
    // float angle = (img.getHue(
    // (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
    // .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
    // % BBPolarTree.TWO_PI;
    double angle= (layer->getHue((int)shape->getCurrentPlacement(seq)->location.x, (int)shape->getCurrentPlacement(seq)->location.y) * TWO_PI);
    if (isnan(angle))
        return otherwise->angleFor(seq,shape);
    else
        return angle;
}