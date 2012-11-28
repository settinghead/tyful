//
//  MainMenu.m
//  PolarTree Experiment
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "MainView.h"
#include "../../cpp_common/polartree/PixelImageShape.h"
#include "../../cpp_common/polartree/TextImageShape.h"
#include "../../cpp_common/polartree/ImageShape.h"
#include "../../cpp_common/polartree/PolarRootTree.h"
#include "../../cpp_common/polartree/PolarTree.h"
#include "../../cpp_common/polartree/PolarTreeBuilder.h"
#include "../../cpp_common/polartree/constants.h"
#include "../../cpp_common/polartree/PolarCanvas.h"
#include "../../cpp_common/polartree/PolarLayer.h"
#include "../../cpp_common/polartree/WordLayer.h"
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

}

-(void)resetMainImage {
    unsigned int * pixels = [MainView getPixels:directionImage withFlip:false];
    WordLayer* layer = new WordLayer(pixels, directionImage.size.width, directionImage.size.height,false);
    canvas = new PolarCanvas();
    canvas->getLayers()->push_back(layer);
    
    mainImage = [[NSBitmapImageRep alloc]
                 initWithBitmapDataPlanes:nil
                 pixelsWide:directionImage.size.width
                 pixelsHigh:directionImage.size.height
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

-(void) loadDirectionImage{
    NSArray *templates = [[NSArray alloc] initWithObjects:
                          @"dog.png",@"wheel_h.png",@"egg.png",
                        @"face.png",
                          @"wheel_v.png",@"star.png",
                          @"heart.png",
//                          @"quarter_red.png",
//                          @"pbs.png",
//                          @"ghandi.png",
//                            @"swift.png",
                          nil];
    NSString *tpl = [templates objectAtIndex:arc4random() % [templates count]];
    NSLog(@"Template: %@",tpl);
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSImage * zNSImage =  [[NSImage alloc] initWithContentsOfFile: [[bundleRoot stringByAppendingString:@"/Contents/Resources/"] stringByAppendingString:tpl]];
	NSData *zNsDataTifData = [[NSData alloc] initWithData:[zNSImage TIFFRepresentation]];
	directionImage = [[NSBitmapImageRep alloc] initWithData:zNsDataTifData];

}

-(void) drawTree:(PolarTree*)tree
       withColor:(NSColor*)color{
    [self drawLeaves:tree withColor:color];
}

-(void) drawLeaves:(PolarTree*)tree
         withColor:(NSColor*)color{
    if (tree->isLeaf() || tree->getKidsNoGrowth()==NULL || tree->getKidsNoGrowth()->size()==0) {
        [self drawBounds:tree withColor:color];
    } else {
        for (int i=0; i < tree->getKidsNoGrowth()->size(); i++) {
            [self drawLeaves:tree->getKidsNoGrowth()->at(i) withColor:color];
        }
    }
}
//
-(void) drawBounds:(PolarTree*)tree
         withColor:(NSColor*)color
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

    double r = tree->getR2(true) - tree->getR1(true);
    if (r < 0)
        r+=TWO_PI;
    
//    assert(r < PI);
    [self drawArc:tree->getRootX() withCenterY:tree->getRootY() withRadius:tree->d2 withAngleFrom:tree->getR1(true) withAngleTo:tree->getR2(true) withPrecision:1.0 withTree:tree withColor:color];
    [self drawArc:tree->getRootX() withCenterY:tree->getRootY() withRadius:tree->d1 withAngleFrom:tree->getR1(true) withAngleTo:tree->getR2(true) withPrecision:1.0 withTree:tree withColor:color];
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    [color set];
    [thePath setLineWidth:1.0]; // Has no effect.
    [thePath moveToPoint:NSMakePoint(x1, y1)];
    [thePath lineToPoint:NSMakePoint(x3, y3)];
    [thePath moveToPoint:NSMakePoint(x2, y2)];
    [thePath lineToPoint:NSMakePoint(x4, y4)];
}

-(void) drawArc:
                  (int)center_x
                  withCenterY:(int)center_y
                  withRadius:(double)radius
                  withAngleFrom:(double)angle_from
                  withAngleTo:(double)angle_to
                  withPrecision:(double)precision
                  withTree:(PolarTree*)tree
                withColor:(NSColor*)color{
    double angle_diff=angle_to-angle_from;
    int steps=round(angle_diff*precision);
    if(steps==0) steps = 1;
    double angle = angle_from;
    double px=center_x+radius * cos(angle);
    double py=
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
        [color set];
        [thePath lineToPoint:NSMakePoint(x, y)];
    }
    [thePath stroke];

}

- (void)drawColorMappedText:(id)sender{
    [self loadDirectionImage];
    [self resetMainImage];
    NSArray *strings = [[NSArray alloc] initWithObjects:
                        @"橙子",@"passion",@"贪婪",
                        @"可笑可乐",
                        @"Circumstances do not make the man.\nThey reveal him.",
                        @"The self always\n comes through.",
                        @"Forgive me.\nYou have my soul and \n I have your money.",
                        @"War rages on\n in Africa."
                        ,@"Quick fox",@"Halo",@"Service\nIndustry\nStandards",@"Tyful"
//                        ,@"glutton",@"lust",@"envy",@"sloth",@"贪婪",@"傲慢"
                        ,@"Γαστριμαργία",@"Πορνεία",@"Φιλαργυρία",@"Ὀργή"
                        ,@"compassion",@"ice cream",@"HIPPO",@"inferno",@"Your\nname"
//                        @"."
//                        @"文俊",@"Wenjun",@"cool"
                        ,nil];
    NSArray *colors = [[NSArray alloc] initWithObjects:
                       [NSColor greenColor],
                       [NSColor redColor],
                       [NSColor brownColor],
                       [NSColor cyanColor],
                       [NSColor blueColor],[NSColor orangeColor],[NSColor darkGrayColor],
                       [NSColor headerColor],[NSColor purpleColor],[NSColor knobColor],
                       nil];
    
    canvas->setStatus(RENDERING);
    NSDate *methodStart = [NSDate date];

    while(canvas->getStatus()==RENDERING){
        TextImageShape *shape;

        NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
        NSAttributedString *stringToInsert;
        
        NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 150*canvas->getShrinkage()+12];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
        
        //        [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
        NSColor* color = [colors objectAtIndex:arc4random()%[colors count]];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[str length])];
        //        [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
        
        stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
        
        NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
        
        if(textImage.size.width>0){
            unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
            
            shape = new TextImageShape(pixels, [textImage size].width, [textImage size].height,false);
//            shape->printStats();
            Placement* placement = canvas->slapShape(shape);
            if(placement!=NULL){
                double rotation = -(shape->getTree()->getRotation())*360/TWO_PI;
                NSPoint point = NSMakePoint(shape->getTree()->getTopLeftLocation().x,
                                            mainImage.size.height-shape->getHeight()-shape->getTree()->getTopLeftLocation().y);
                printf("Coord: %f, %f; rotation: %f\n"
                       ,shape->getTree()->getTopLeftLocation().x
                       ,shape->getTree()->getTopLeftLocation().y
                       ,shape->getTree()->getRotation());

                [self drawText:point withStringToInsert:stringToInsert withRotation:rotation];
//                [self drawTextTree:shape->getTree() withColor:color];
            }
        }
    }
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];

    NSLog(@"Execution time: %f",executionTime);
 
}



- (void)drawRandomText:(id)sender{
    int x,y;
    double rotation;
    ImageShape *shape;
    NSArray *strings = [[NSArray alloc] initWithObjects:@"椅子",@"passion",@"LOL",
                        @"尼玛",@"FCUK",@"Quick fox",@"Halo",nil];
    NSArray *colors = [[NSArray alloc] initWithObjects:[NSColor greenColor],
                       [NSColor blackColor],[NSColor brownColor],[NSColor cyanColor],
                       [NSColor blueColor],[NSColor yellowColor],[NSColor darkGrayColor],
                       [NSColor headerColor],[NSColor knobColor],[NSColor magentaColor],nil];
    NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
    NSAttributedString *stringToInsert;
    NSColor* color = [colors objectAtIndex:arc4random()%[colors count]];

    while(true){

        NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 130];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];

//        [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[str length])];
//        [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];

      stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
        
        NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
    //    unsigned char* d = [textImage bitmapData];
    //    int a = d[(int)([textImage size].width-1)*(int)([textImage size].height-1)];
    //    [textImages addObject:textImage];
        
        unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
        
        shape = new TextImageShape(pixels, [textImage size].width, [textImage size].height,false);
        int count = 0;
        do {
            x = arc4random() % (int)(mainImage.size.width+textImage.size.width)-textImage.size.width/2;
            y = arc4random() % (int)(mainImage.size.height+textImage.size.height)-textImage.size.height/2;
            rotation = ((double)arc4random() / 0x100000000) * 90;
//            rotation = 0;
            shape->getTree()->setTopLeftLocation(x,
                                     mainImage.size.height-shape->getHeight()-
                                     y);
            shape->getTree()->setRotation(-rotation/360*TWO_PI+PI);
        }
        while ([MainView collide:shape->getTree():trees] && ++count<1000);
        if(count<1000)
            break;
        else
            return;
    }

        NSPoint point = NSMakePoint(x, y);
//        NSPoint point = NSMakePoint(0, 0);

    
        [trees addObject:[NSValue valueWithPointer:shape->getTree()]];

    [self drawText:point withStringToInsert:stringToInsert withRotation:rotation];
//    [self drawTextTree:shape->getTree() withColor:color];
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
                 withRotation:(double)rotation
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
           withColor:(NSColor*)color
{
    
    NSGraphicsContext* nsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:mainImage];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsContext];
    [color set];
    [self drawTree:tree withColor:color];
    
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
    [[NSColor colorWithDeviceRed: 0 green: 0 blue: 0 alpha: 0] set];
    [NSBezierPath fillRect:NSMakeRect(0, 0, textImage.size.width, textImage.size.height)];
    [str drawAtPoint:NSMakePoint(0, 0)];
    [NSGraphicsContext restoreGraphicsState];
    return textImage;
}

+(unsigned int *) getPixels:(NSBitmapImageRep*)image
                   withFlip:(bool)flip{
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
            int i = flip? (height-yy-1)*width+xx : yy*width+xx;
            pixels[i] = (((unsigned int)pixelData[0]<<16)|((unsigned int)pixelData[1]<<8)|((unsigned int)pixelData[2])|((unsigned int)pixelData[3]<<24));
            //                cout << pixels[xx*((int)textImage.size.width)+yy] << " ";
        }
    }
    return pixels;
}

@end
