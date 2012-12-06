//
//  MainMenu.h
//  osx_client
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

class PolarTree;
class PolarRootTree;
class PolarCanvas;

@interface MainView : NSView{
    NSBitmapImageRep *mainImage;
//    NSBitmapImageRep *directionImage;
    IBOutlet NSView *mainView;
    NSMutableArray *trees;
    NSMutableDictionary *dict;
    NSString *directionFile;

}
- (IBAction)drawRandomText:(id)sender;
- (IBAction)drawColorMappedText:(id)sender;
- (void)drawCanvas;
-(void) drawLeaves:(PolarTree*)tree
         withColor:(NSColor*)color;
-(void) drawBounds:(PolarTree*)tree
         withColor:(NSColor*)color;
-(void) drawTree:(PolarTree*)tree
       withColor:(NSColor*)color;
-(void) drawArc:(double)center_x
    withCenterY:(double)center_y
     withRadius:(double)radius;
- (void)drawTextTree:(PolarTree*)tree
           withColor:(NSColor*)color;
-(void) drawArc:
(int)center_x
    withCenterY:(int)center_y
     withRadius:(double)radius
  withAngleFrom:(double)angle_from
    withAngleTo:(double)angle_to
  withPrecision:(double)precision
       withTree:(PolarTree*)tree
      withColor:(NSColor*)color;
-(void) drawLeaves:(PolarTree*)tree
         withColor:(NSColor*)color;
+(NSBitmapImageRep*) getTextImage:(NSAttributedString*)str;
+(bool)collide:(PolarRootTree*)tree:(NSArray*)oTrees;
+(unsigned int *) getPixels:(NSBitmapImageRep*)image
                   withFlip:(bool)flip;
@end
