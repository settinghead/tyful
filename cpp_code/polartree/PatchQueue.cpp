//
//  PatchQueue.cpp
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/17/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include "PatchQueue.h"
#include <queue>
#include <cstdlib>
#include <cstring>
#include <vector>
#include "PolarLayer.h"
#include "Patch.h"
#include "LeveledPatchMap.h"
#include "DensityPatchIndex.h"


LeveledPatchMap* PatchQueue::getMap(){
    return map;
}
