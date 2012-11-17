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
#include <iostream>


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
                 pixelsWide:800
                 pixelsHigh:500
                 bitsPerSample: 8
                 samplesPerPixel: 4
                 hasAlpha: YES
                 isPlanar: NO
                 colorSpaceName: NSCalibratedRGBColorSpace
                 bytesPerRow: 0	// "you figure it out"
                 bitsPerPixel: 32];
    NSUInteger zColourAry[3] = {255,255,255};
    for(int x=0;x<mainImage.size.width;x++)
        for(int y=0;y<mainImage.size.height;y++)
            [mainImage setPixel:zColourAry atX:x y:y];

    trees = [NSMutableArray array];
}

-(void) drawTree:(PolarTree*)tree{
    [self drawLeaves:tree];
}

-(void) drawLeaves:(PolarTree*)tree {
    if (tree->isLeaf() || tree->getKidsNoGrowth()==NULL || tree->getKidsNoGrowth()->size()==0) {
        [self drawBounds:tree];
    } else {
        for (int i=0; i < tree->getKidsNoGrowth()->size(); i++) {
            [self drawLeaves:tree->getKidsNoGrowth()->at(i)];
        }
    }
}
//
-(void) drawBounds:(PolarTree*)tree
{
    int x1, x2, x3, x4, y1, y2, y3, y4;
    x1 = int((tree->getRootX() + tree->d1 * cos(tree->getR1(true))));
    y1 = int(
             mainImage.size.height-
             ((tree->getRootY() - tree->d1 * sin(tree->getR1(true)))));
    x2 = int((tree->getRootX() + tree->d1 * cos(tree->getR2(true))));
    y2 = int(
             mainImage.size.height-
             ((tree->getRootY() - tree->d1 * sin(tree->getR2(true)))));
    x3 = int((tree->getRootX() + tree->d2 * cos(tree->getR1(true))));
    y3 = int(
             mainImage.size.height-
             ((tree->getRootY() - tree->d2 * sin(tree->getR1(true)))));
    x4 = int((tree->getRootX() + tree->d2 * cos(tree->getR2(true))));
    y4 = int(
             mainImage.size.height-
             ((tree->getRootY() - tree->d2 * sin(tree->getR2(true)))));

    float r = tree->getR2(true) - tree->getR1(true);
    if (r < 0)
        r+=TWO_PI;
    
//    assert(r < PI);
    
    [self drawArc:tree->getRootX() withCenterY:tree->getRootY() withRadius:tree->d2 withAngleFrom:tree->getR1(true) withAngleTo:tree->getR2(true) withPrecision:1.0 withTree:tree];
    [self drawArc:tree->getRootX() withCenterY:tree->getRootY() withRadius:tree->d1 withAngleFrom:tree->getR1(true) withAngleTo:tree->getR2(true) withPrecision:1.0 withTree:tree];
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    [thePath setLineWidth:1.0]; // Has no effect.
    [thePath moveToPoint:NSMakePoint(x1, y1)];
    [thePath lineToPoint:NSMakePoint(x3, y3)];
    [thePath moveToPoint:NSMakePoint(x2, y2)];
    [thePath lineToPoint:NSMakePoint(x4, y4)];
}

-(void) drawArc:
                  (float)center_x
                  withCenterY:(float)center_y
                  withRadius:(float)radius
                  withAngleFrom:(float)angle_from
                  withAngleTo:(float)angle_to
                  withPrecision:(float)precision
                  withTree:(PolarTree*)tree{
    float angle_diff=angle_to-angle_from;
    int steps=round(angle_diff*precision);
    if(steps==0) steps = 1;
    float angle = angle_from;
    float px=center_x+radius * cos(angle);
    float py=
        mainImage.size.height-
        (center_y-radius * sin(angle));
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    [thePath setLineWidth:1.0]; // Has no effect.
    [thePath moveToPoint:NSMakePoint(px, py)];
    
    for (int i=1; i<=steps; i++) {
        angle=angle_from+angle_diff/steps*i;
        int x = center_x+radius*cos(angle);
        int y =
        mainImage.size.height-
        (center_y-radius*sin(angle));
        [thePath lineToPoint:NSMakePoint(x, y)];
    }
    [thePath stroke];

}


- (void)drawRandomText:(id)sender{
    int x,y;
    float rotation;
    PolarRootTree *tree;
    ImageShape *shape;
    NSArray *strings = [[NSArray alloc] initWithObjects:@"椅子",@"passion",@"LOL",
                        @"尼玛",@"FCUK",@"Quick fox",@"Halo",nil];
    NSArray *colors = [[NSArray alloc] initWithObjects:[NSColor greenColor],
                       [NSColor blackColor],[NSColor brownColor],[NSColor cyanColor],
                       [NSColor blueColor],[NSColor yellowColor],[NSColor darkGrayColor],
                       [NSColor headerColor],[NSColor knobColor],[NSColor magentaColor],nil];
    NSString *str = strings[arc4random() % [strings count]];
    NSAttributedString *stringToInsert;
    while(true){

        NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 130];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];

//        [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
        [string addAttribute:NSForegroundColorAttributeName value:colors[arc4random()%[colors count]] range:NSMakeRange(0,[str length])];
//        [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];

      stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
        
        NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
    //    unsigned char* d = [textImage bitmapData];
    //    int a = d[(int)([textImage size].width-1)*(int)([textImage size].height-1)];
    //    [textImages addObject:textImage];
        
        unsigned int * pixels = [MainView getFlippedPixels:textImage];
        
        shape = new PixelImageShape((unsigned char *)pixels, [textImage size].width, [textImage size].height);
        tree = makeTree(shape, 0);
        int count = 0;
        do {
            x = arc4random() % (int)(mainImage.size.width+textImage.size.width)-textImage.size.width/2;
            y = arc4random() % (int)(mainImage.size.height+textImage.size.height)-textImage.size.height/2;
            rotation = ((double)arc4random() / 0x100000000) * 90;
//            rotation = 0;
            tree->setTopLeftLocation(x,
                                     mainImage.size.height-tree->shape->getHeight()-
                                     y);
            tree->setRotation(-rotation/360*TWO_PI+PI);
        }
        while ([MainView collide:tree:trees] && ++count<10000);
        if(count<1000)
            break;
        else
            return;
    }

        NSPoint point = NSMakePoint(x, y);
//        NSPoint point = NSMakePoint(0, 0);

    
        [trees addObject:[NSValue valueWithPointer:tree]];

    [self drawText:point withStringToInsert:stringToInsert withRotation:rotation];
//    [self drawTextTree:tree];
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
                 withRotation:(float)rotation
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
        // rorate
        NSAffineTransform *transform = [NSAffineTransform transform];
    
//        [transform translateXBy: stringToInsert.size.width yBy: stringToInsert.size.height];
//        [transform rotateByDegrees:rotation];
//        [transform translateXBy: -stringToInsert.size.width yBy: -stringToInsert.size.height];
//    
        [transform translateXBy: point.x+stringToInsert.size.width/2 yBy: point.y+stringToInsert.size.height/2];
        [transform rotateByDegrees:-rotation];
        [transform translateXBy: -point.x-stringToInsert.size.width/2 yBy: -point.y-stringToInsert.size.height/2];
    
		[transform concat];
    
		[stringToInsert drawAtPoint:point];
    
		[NSGraphicsContext restoreGraphicsState];
        [mainView setNeedsDisplay:YES];
        [self setNeedsDisplay:YES];
}

- (void)drawTextTree:(PolarTree*)tree
{
    
    NSGraphicsContext* nsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:mainImage];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsContext];
    
    [self drawTree:tree];
    
    [NSGraphicsContext restoreGraphicsState];
    [mainView setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];
}

+(NSBitmapImageRep*) getTextImage:(NSAttributedString*)str
{
    // Assign the redrawRect based on the string's size and the insertion point
//    NSRect rect = [str boundingRectWithSize:[str size]
//                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics];
//    std::cout << "width: " << str.size.width << "; height: " << str.size.height;

    NSBitmapImageRep *textImage = [[NSBitmapImageRep alloc]
                                   initWithBitmapDataPlanes:nil
                                   pixelsWide:str.size.width
                                   pixelsHigh:str.size.height
                                   bitsPerSample: 8
                                   samplesPerPixel: 4
                                   hasAlpha: YES
                                   isPlanar: NO
                                   colorSpaceName: NSCalibratedRGBColorSpace
                                   bytesPerRow: 0	// "you figure it out"
                                   bitsPerPixel: 32];
    NSUInteger zColourAry[3] = {255,255,255};
    for(int x=0;x<textImage.size.width;x++)
        for(int y=0;y<textImage.size.height;y++)
            [textImage setPixel:zColourAry atX:x y:y];
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:textImage]];
    [str drawAtPoint:NSMakePoint(0, 0)];
    [NSGraphicsContext restoreGraphicsState];
    return textImage;
}

+(unsigned int *) getFlippedPixels:(NSBitmapImageRep*)image{
    int width = [image size].width;
    int height = [image size].height;
    
    int size = sizeof(unsigned int)*width*height;

//    unsigned char * orig = image.bitmapData;
    unsigned int * pixels = (unsigned int *)malloc(size);
//    unsigned char * origPixels = [image bitmapData];
    for (int xx=0; xx<width; xx++) {
        for(int yy=0;yy<height;yy++){
            NSUInteger pixelData[4] = {0,0,0,0};
            [image getPixel:pixelData atX:xx y:yy];
//            origPixels[int(image.size.height-yy)*((int)image.size.width)+xx];
            //                cout << pixelData[0] << " " << pixelData[1] << " " << pixelData[2] << " "<< pixelData[3] << "|";
            int i = (height-yy-1)*width+(width-xx-1);
            pixels[i] = (((unsigned int)pixelData[0]<<16)|((unsigned int)pixelData[1]<<8)|((unsigned int)pixelData[2])|((unsigned int)pixelData[3]<<24));
            //                cout << pixels[xx*((int)textImage.size.width)+yy] << " ";
        }
    }
    return pixels;
}

@end
