//
//  MainMenu.h
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

class PolarTree;
class PolarRootTree;

@interface MainView : NSView{
    NSBitmapImageRep *mainImage;
    NSBitmapImageRep *directionImage;
    IBOutlet NSView *mainView;
    NSMutableArray *trees;

}
- (IBAction)drawRandomText:(id)sender;
-(void) drawLeaves:(PolarTree*)tree;
-(void) drawTree:(PolarTree*)tree;
-(void) drawArc:(float)center_x
    withCenterY:(float)center_y
     withRadius:(float)radius
  withAngleFrom:(float)angle_from
    withAngleTo:(float)angle_to
 owithPrecision:(float)precision
 withTree:(PolarTree*)tree;

+(NSBitmapImageRep*) getTextImage:(NSAttributedString*)str;
+(bool)collide:(PolarRootTree*)tree:(NSArray*)oTrees;
+(unsigned int *) getFlippedPixels:(NSBitmapImageRep*)image;
@end
