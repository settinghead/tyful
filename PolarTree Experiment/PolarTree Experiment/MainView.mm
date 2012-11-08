//
//  MainMenu.m
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "MainView.h"
#include "polartree/PixelImageShape.h"
#include "polartree/PolarTree.h"
#include "polartree/PolarTreeBuilder.h"
#include <stdlib.h>


@implementation MainView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    mainImage = [[NSBitmapImageRep alloc]
                 initWithBitmapDataPlanes:nil
                 pixelsWide:500
                 pixelsHigh:500
                 bitsPerSample: 8
                 samplesPerPixel: 4
                 hasAlpha: YES
                 isPlanar: NO
                 colorSpaceName: NSCalibratedRGBColorSpace
                 bytesPerRow: 0	// "you figure it out"
                 bitsPerPixel: 32];
    trees = [NSMutableArray array];
}

- (void)drawRandomText:(id)sender{
    int x,y;
    PolarRootTree *tree;
    NSString *str = @"firstsecondthird";
    NSAttributedString *stringToInsert;
    
    while(true){

        NSFont *font = [NSFont fontWithName:@"Arial" size:(arc4random() % 30+1)];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];

        [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
        [string addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(5,6)];
        [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];

      stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
        
        NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
    //    unsigned char* d = [textImage bitmapData];
    //    int a = d[(int)([textImage size].width-1)*(int)([textImage size].height-1)];
    //    [textImages addObject:textImage];

        ImageShape *shape = new PixelImageShape([textImage bitmapData], [textImage size].width, [textImage size].height);
        tree = makeTree(shape, 0);
        
        int count = 0;
        do {
            x = arc4random() % 500;
            y = arc4random() % 500;
            tree->setLocation(x, y);
        }
        while ([MainView collide:tree:trees] && ++count<1000);
        if(count<1000)
            break;
    }

        NSPoint point = NSMakePoint(x, y);
        [trees addObject:[NSValue valueWithPointer:tree]];

        [self drawText:point withStringToInsert:stringToInsert];
}

+(bool)collide:(PolarRootTree*)tree:
                (NSArray*)oTrees{
    NSEnumerator *e = [oTrees objectEnumerator];
    NSValue *oTree;
    while (oTree = [e nextObject]) {
        if(tree->overlaps((PolarTree*)oTree.pointerValue)) return true;
    }
    return false;
}

- (void)drawRect:(NSRect)pRect
{
	[NSGraphicsContext saveGraphicsState];
	
	[mainImage drawInRect:pRect];
    
	[NSGraphicsContext restoreGraphicsState];
    
}

- (void)drawText:(NSPoint)point
                  withStringToInsert:(NSAttributedString *)stringToInsert
{
    
		// The size of the string, as a guesstimate
//		NSSize textSize = [stringToInsert size];
    
//		CGFloat xOffset = ABS(rect.origin.x);
//		CGFloat yOffset = ABS(rect.origin.y);
//		rect.size.width += xOffset + textSize.width;
//		rect.size.height += yOffset + textSize.height;
//		
//		// Shift it
//		rect.origin = NSMakePoint(floorf(point.x), floorf(point.y));
//		rect.origin.y -= rect.size.height;
//		rect.origin.y += yOffset;
//        
//		rect.origin.x += xOffset;
//        
//		// Fix the origin, since we're dealing with flipped stuff
//		rect.origin.y = [mainImage pixelsHigh] - rect.origin.y - rect.size.height;
//    
        NSGraphicsContext* nsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:mainImage];
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:nsContext];
//        NSAffineTransform *transform = [NSAffineTransform transform];
//		// Create the transform
//		[transform scaleXBy:1.0 yBy:-1.0];
//		[transform translateXBy:0 yBy:(0-[mainImage pixelsHigh])];
//		[transform concat];
		[stringToInsert drawAtPoint:point];
		[NSGraphicsContext restoreGraphicsState];
        [mainView setNeedsDisplay:YES];
        [self setNeedsDisplay:YES];
}

+(NSBitmapImageRep*) getTextImage:(NSAttributedString*)str
{
    // Assign the redrawRect based on the string's size and the insertion point
    NSRect rect = [str boundingRectWithSize:[str size]
                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics];
    NSBitmapImageRep *textImage = [[NSBitmapImageRep alloc]
                                   initWithBitmapDataPlanes:nil
                                   pixelsWide:rect.size.width
                                   pixelsHigh:rect.size.height
                                   bitsPerSample: 8
                                   samplesPerPixel: 4
                                   hasAlpha: YES
                                   isPlanar: NO
                                   colorSpaceName: NSCalibratedRGBColorSpace
                                   bytesPerRow: 0	// "you figure it out"
                                   bitsPerPixel: 32];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:textImage]];
    [str drawAtPoint:NSMakePoint(0, 0)];
    [NSGraphicsContext restoreGraphicsState];
    return textImage;
}

@end
