//
//  MainMenu.m
//  osx_client
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "MainView.h"
//#include "../../cpp/cpp/model/PixelImageShape.h"
//#include "../../cpp/cpp/model/TextImageShape.h"
//#include "../../cpp/cpp/model/ImageShape.h"
//#include "../../cpp/cpp/tree/PolarRootTree.h"
//#include "../../cpp/cpp/tree/PolarTree.h"
//#include "../../cpp/cpp/tree/PolarTreeBuilder.h"
//#include "../../cpp/cpp/constants.h"
#include "../../cpp/cpp/model/PolarCanvas.h"
//#include "../../cpp/cpp/model/PolarLayer.h"
//#include "../../cpp/cpp/model/WordLayer.h"
#include "../../cpp/cpp/model/structs.h"
#include "../../cpp/cpp/polartreeapi.h"
#include <stdlib.h>
#include <iostream>
#include <pthread.h>


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
    canvas = (PolarCanvas*)initCanvas();
    unsigned int * pixels = [MainView getPixels:directionImage withFlip:false];
    appendLayer(canvas,pixels,NULL,(int)directionImage.size.width, (int)directionImage.size.height,false);
    dict = [[NSMutableDictionary alloc] init];
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
                          @"pbs.png",
                          @"ghandi.png",
                            @"swift.png",
                          nil];
    NSString *tpl = [templates objectAtIndex:arc4random() % [templates count]];
    NSLog(@"Template: %@",tpl);
    [[self window] setTitle:tpl];
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSImage * zNSImage =  [[NSImage alloc] initWithContentsOfFile: [[bundleRoot stringByAppendingString:@"/Contents/Resources/"] stringByAppendingString:tpl]];
	NSData *zNsDataTifData = [[NSData alloc] initWithData:[zNSImage TIFFRepresentation]];
	directionImage = [[NSBitmapImageRep alloc] initWithData:zNsDataTifData];

}

-(void) drawTree:(PolarTree*)tree
       withColor:(NSColor*)color{
    [self drawLeaves:tree withColor:color];
}
//
//-(void) drawLeaves:(PolarTree*)tree
//         withColor:(NSColor*)color{
//    if (tree->isLeaf() || tree->getKidsNoGrowth()==NULL || tree->getKidsNoGrowth()->size()==0) {
//        [self drawBounds:tree withColor:color];
//    } else {
//        for (int i=0; i < tree->getKidsNoGrowth()->size(); i++) {
//            [self drawLeaves:tree->getKidsNoGrowth()->at(i) withColor:color];
//        }
//    }
//}
////
//-(void) drawBounds:(PolarTree*)tree
//         withColor:(NSColor*)color
//{
//    int x1, x2, x3, x4, y1, y2, y3, y4;
//    x1 = int((tree->getRootX(tree->getFinalSeq()) + tree->d1 * cos(tree->getR1(tree->getFinalSeq(),true))));
//    y1 = int(
//             mainImage.size.height-
//             ((tree->getRootY(tree->getFinalSeq()) - tree->d1 * sin(tree->getR1(tree->getFinalSeq(),true)))));
//    x2 = int((tree->getRootX(tree->getFinalSeq()) + tree->d1 * cos(tree->getR2(tree->getFinalSeq(),true))));
//    y2 = int(
//             mainImage.size.height-
//             ((tree->getRootY(tree->getFinalSeq()) - tree->d1 * sin(tree->getR2(tree->getFinalSeq(),true)))));
//    x3 = int((tree->getRootX(tree->getFinalSeq()) + tree->d2 * cos(tree->getR1(tree->getFinalSeq(),true))));
//    y3 = int(
//             mainImage.size.height-
//             ((tree->getRootY(tree->getFinalSeq()) - tree->d2 * sin(tree->getR1(tree->getFinalSeq(),true)))));
//    x4 = int((tree->getRootX(tree->getFinalSeq()) + tree->d2 * cos(tree->getR2(tree->getFinalSeq(),true))));
//    y4 = int(
//             mainImage.size.height-
//             ((tree->getRootY(tree->getFinalSeq()) - tree->d2 * sin(tree->getR2(tree->getFinalSeq(),true)))));
//
//    double r = tree->getR2(tree->getFinalSeq(),true) - tree->getR1(tree->getFinalSeq(),true);
//    if (r < 0)
//        r+=TWO_PI;
//    
////    assert(r < PI);
//    [self drawArc:tree->getRootX(tree->getFinalSeq()) withCenterY:tree->getRootY(tree->getFinalSeq()) withRadius:tree->d2 withAngleFrom:tree->getR1(tree->getFinalSeq(),true) withAngleTo:tree->getR2(tree->getFinalSeq(),true) withPrecision:1.0 withTree:tree withColor:color];
//    [self drawArc:tree->getRootX(tree->getFinalSeq()) withCenterY:tree->getRootY(tree->getFinalSeq()) withRadius:tree->d1 withAngleFrom:tree->getR1(tree->getFinalSeq(),true) withAngleTo:tree->getR2(tree->getFinalSeq(),true) withPrecision:1.0 withTree:tree withColor:color];
//    
//    NSBezierPath* thePath = [NSBezierPath bezierPath];
//    [color set];
//    [thePath setLineWidth:1.0]; // Has no effect.
//    [thePath moveToPoint:NSMakePoint(x1, y1)];
//    [thePath lineToPoint:NSMakePoint(x3, y3)];
//    [thePath moveToPoint:NSMakePoint(x2, y2)];
//    [thePath lineToPoint:NSMakePoint(x4, y4)];
//}
//
//-(void) drawArc:
//                  (int)center_x
//                  withCenterY:(int)center_y
//                  withRadius:(double)radius
//                  withAngleFrom:(double)angle_from
//                  withAngleTo:(double)angle_to
//                  withPrecision:(double)precision
//                  withTree:(PolarTree*)tree
//                withColor:(NSColor*)color{
//    double angle_diff=angle_to-angle_from;
//    int steps=round(angle_diff*precision);
//    if(steps==0) steps = 1;
//    double angle = angle_from;
//    double px=center_x+radius * cos(angle);
//    double py=
//        mainImage.size.height-
//        (center_y-radius * sin(angle));
//    
//    NSBezierPath* thePath = [NSBezierPath bezierPath];
//    [thePath setLineWidth:1.0]; // Has no effect.
//    [thePath moveToPoint:NSMakePoint(px, py)];
//    for (int i=1; i<=steps; i++) {
//        angle=angle_from+angle_diff/steps*i;
//        int x = center_x+radius*cos(angle);
//        int y =
//        mainImage.size.height-
//        (center_y-radius*sin(angle));
//        [color set];
//        [thePath lineToPoint:NSMakePoint(x, y)];
//    }
//    [thePath stroke];
//
//}

NSArray *strings = [[NSArray alloc] initWithObjects:
                    @"橙子",@"passion",@"贪婪",
                    @"可笑可乐",
                    @"Circumstances do not make the man.\nThey reveal him.",
                    @"The self always\n comes through.",
                    @"Forgive me.\nYou have my soul and \n I have your money.",
                    @"War rages on\n in Africa."
                    ,@"Quick fox",@"Halo",@"Service\nIndustry\nStandards",@"Tyful"
                    ,@"Γαστριμαργία",@"Πορνεία",@"Φιλαργυρία",@"Ὀργή"
                    ,@"compassion",@"ice cream",@"HIPPO",@"inferno",@"Your\nname"
                    ,nil];
int counter = 0;
int sid = 0;

- (void)drawCanvas{
    counter = 0;
    NSDate *methodStart = [NSDate date];
    
    startRendering(canvas);
    
    pthread_mutex_lock(&canvas->next_slap_mutex);
    while(getStatus(canvas)>0){
        while(canvas->pendingShapes->size()<10)
            [self feedNextText];
        pthread_cond_wait(&canvas->next_slap_cv, &canvas->next_slap_mutex);
        [self checkAndRenderSlaps];
    }
    pthread_mutex_unlock(&canvas->next_slap_mutex);

    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Execution time: %f",executionTime);

}

- (void)drawColorMappedText:(id)sender{
    [self loadDirectionImage];
    [self resetMainImage];
    

    [NSThread detachNewThreadSelector:@selector(drawCanvas) toTarget:self withObject:nil];

}

- (void)feedNextText{
    NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
    NSAttributedString *stringToInsert;
    
    NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 150*getShrinkage(canvas)+12];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    
    unsigned int sid = (unsigned int)[dict count];
    [dict setObject:string forKey:[NSString stringWithFormat:@"%u", sid]];
    
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
    stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
    
    NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
    
    if(textImage.size.width>0){
        unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
        
        feedShape(canvas, pixels, textImage.size.width, textImage.size.height, sid);
    }
}

-(void)checkAndRenderSlaps{
    while(!canvas->slaps->empty()){
        SlapInfo* placement = canvas->slaps->front();
        canvas->slaps->pop();
        double rotation = -(placement->rotation)*360/M_PI/2;
        NSMutableAttributedString *string = [dict objectForKey:[NSString stringWithFormat:@"%u", placement->sid]];
        NSPoint point = NSMakePoint(placement->location.x,
                                    mainImage.size.height-string.size.height-placement->location.y);
        printf("Coord: %f, %f; rotation: %f, color: %x, total: %d\n"
               ,point.x
               ,point.y
               ,placement->rotation,placement->color, counter++);
        unsigned int textColor = placement->color & 0x00FFFFFF;
        NSColor* color = [NSColor colorWithCalibratedRed:((double)(textColor>>16))/255 green:((double)(textColor>>8 & 0x000000FF))/255 blue:((double)(textColor & 0xFF))/255 alpha:1.0F];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[string length])];
        NSAttributedString* stringToDraw = [[NSAttributedString alloc] initWithAttributedString:string];
        
        [self drawText:point withStringToInsert:stringToDraw withRotation:rotation];
    }
}


//- (void)drawRandomText:(id)sender{
//    int x,y;
//    double rotation;
//    ImageShape *shape;
//    NSArray *strings = [[NSArray alloc] initWithObjects:@"椅子",@"passion",@"LOL",
//                        @"尼玛",@"FCUK",@"Quick fox",@"Halo",nil];
//    NSArray *colors = [[NSArray alloc] initWithObjects:[NSColor greenColor],
//                       [NSColor blackColor],[NSColor brownColor],[NSColor cyanColor],
//                       [NSColor blueColor],[NSColor yellowColor],[NSColor darkGrayColor],
//                       [NSColor headerColor],[NSColor knobColor],[NSColor magentaColor],nil];
//    NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
//    NSAttributedString *stringToInsert;
//    NSColor* color = [colors objectAtIndex:arc4random()%[colors count]];
//
//    while(true){
//
//        NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 130];
//        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
//
////        [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
//        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[str length])];
////        [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
//        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
//
//      stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
//        
//        NSBitmapImageRep *textImage = [MainView getTextImage:stringToInsert];
//    //    unsigned char* d = [textImage bitmapData];
//    //    int a = d[(int)([textImage size].width-1)*(int)([textImage size].height-1)];
//    //    [textImages addObject:textImage];
//        
//        unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
//        
//        shape = new TextImageShape(pixels, [textImage size].width, [textImage size].height,false);
//        int count = 0;
//        do {
//            x = arc4random() % (int)(mainImage.size.width+textImage.size.width)-textImage.size.width/2;
//            y = arc4random() % (int)(mainImage.size.height+textImage.size.height)-textImage.size.height/2;
//            rotation = ((double)arc4random() / 0x100000000) * 90;
////            rotation = 0;
//            shape->getTree()->setTopLeftLocation(x,
//                                     mainImage.size.height-shape->getHeight()-
//                                     y);
//            shape->getTree()->setRotation(-rotation/360*TWO_PI+PI);
//        }
//        while ([MainView collide:shape->getTree():trees] && ++count<1000);
//        if(count<1000)
//            break;
//        else
//            return;
//    }
//
//        NSPoint point = NSMakePoint(x, y);
////        NSPoint point = NSMakePoint(0, 0);
//
//    
//        [trees addObject:[NSValue valueWithPointer:shape->getTree()]];
//
//    [self drawText:point withStringToInsert:stringToInsert withRotation:rotation];
////    [self drawTextTree:shape->getTree() withColor:color];
//}

//+(bool)collide:(PolarRootTree*)tree:
//                (NSArray*)oTrees{
//    NSEnumerator *e = [oTrees objectEnumerator];
//    NSValue *oTree;
//    while (oTree = [e nextObject]) {
//        if(tree->overlaps((PolarTree*)oTree.pointerValue)) return true;
//    }
//    return false;
//}

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
