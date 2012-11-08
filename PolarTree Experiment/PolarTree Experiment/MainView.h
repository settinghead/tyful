//
//  MainMenu.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "polartree/PolarTree.h"


@interface MainView : NSView{
    NSBitmapImageRep *mainImage;
    IBOutlet NSView *mainView;
    NSMutableArray *trees;

}
- (IBAction)drawRandomText:(id)sender;
-(NSBitmapImageRep*) getTextImage:(NSAttributedString*)str;
-(bool)collide:(PolarRootTree*)tree;
@end
