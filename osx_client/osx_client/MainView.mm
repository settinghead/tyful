//
//  MainMenu.m
//  osx_client
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "MainView.h"
#include "../../cpp/cpp/model/PolarCanvas.h"
#include "../../cpp/cpp/model/EngineShape.h"
#include "../../cpp/cpp/model/ImageShape.h"
#include "../../cpp/cpp/model/structs.h"
#include "../../cpp/cpp/polartreeapi.h"
#include "../../cpp/cpp/tree/PolarRootTree.h"
#include <stdlib.h>
#include <iostream>
#include <pthread.h>
#include<stdio.h>


@implementation MainView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    [NSThread detachNewThreadSelector:@selector(slapRoutine) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(feedShapes) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(fixThingsAtRandom) toTarget:self withObject:nil];

}

-(void)resetMainImage {
    initCanvas();
//    unsigned int * pixels = [MainView getPixels:directionImage withFlip:false];
    prevShrinkage = 1.0;
    int counter;
    FILE *f;
    f=fopen([directionFile UTF8String],"rb");
    fseek(f, 0, SEEK_END);
    size_t size = ftell(f);
    fseek(f, 0, SEEK_SET);
    
    unsigned char *png = (unsigned char *)malloc(size);
    fread(png, size, 1, f);
    fclose(f);

    appendLayer(png,size);
    
//    appendLayer(pixels,NULL,(int)directionImage.size.width, (int)directionImage.size.height,false);
    dict = [[NSMutableDictionary alloc] init];
    Dimension d = getCanvasSize();
    mainImage = [[NSBitmapImageRep alloc]
                 initWithBitmapDataPlanes:nil
                 pixelsWide:d.width
                 pixelsHigh:d.height
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
                          @"dog.png",
                          @"wheel_h.png",
                          @"egg.png",
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
    directionFile = [[bundleRoot stringByAppendingString:@"/Contents/Resources/"] stringByAppendingString:tpl];
//    NSImage * zNSImage =  [[NSImage alloc] initWithContentsOfFile: [[bundleRoot stringByAppendingString:@"/Contents/Resources/"] stringByAppendingString:tpl]];
//	NSData *zNsDataTifData = [[NSData alloc] initWithData:[zNSImage TIFFRepresentation]];
//	directionImage = [[NSBitmapImageRep alloc] initWithData:zNsDataTifData];

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
                    @"C-3PO",
                    @"橙子",@"passion",@"贪婪",
                    @"可笑可乐",
                    @"Circumstances\n do not make the man.\nThey reveal him.",
                    @"The self always\n comes through.",
                    @"Forgive me.\nYou have my soul and \n I have your money.",
                    @"War rages on\n in Africa.",
                    @"Quick fox",@"Halo",@"Service\nIndustry\nStandards",@"Tyful",
                    @"Γαστριμαργία",@"Πορνεία",@"Φιλαργυρία",@"Ὀργή",
                    @"compassion",@"ice cream",@"HIPPO",@"inferno",@"Your\nname",
                    @"To be\n or not to be",@"床前明月光\n疑是地上霜\n举头望明月\n低头思故乡",
                    nil];
int counter = 0;
int sid = 0;

- (void) slapRoutine{
    pthread_mutex_lock(&PolarCanvas::threadControllers.next_slap_req_mutex);
    while(true){
        pthread_cond_wait(&PolarCanvas::threadControllers.next_slap_req_cv, &PolarCanvas::threadControllers.next_slap_req_mutex);
        [self checkAndRenderSlaps];
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_slap_req_mutex);
}

-(void)feedShapes{
    pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_req_mutex);
    while(true){
//        while(getStatus()>0&&PolarCanvas::current->pendingShapes->size()<5 && getStatus()>0)
        pthread_cond_wait(&PolarCanvas::threadControllers.next_feed_req_cv, &PolarCanvas::threadControllers.next_feed_req_mutex);
            [self feedNextText];
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_req_mutex);
}


-(void)fixThingsAtRandom{
    while(true){
        sleep(1);
        EngineShape* shape = NULL;
        //    NSMutableAttributedString * string;
        unsigned int textColor = 0xFF0000 & 0x00FFFFFF;
        NSColor* color = [NSColor colorWithCalibratedRed:((double)(textColor>>16))/255 green:((double)(textColor>>8 & 0x000000FF))/255 blue:((double)(textColor & 0xFF))/255 alpha:1.0F];
        
        NSMutableAttributedString* stringToDraw = NULL;
        if(PolarCanvas::current!=NULL){
//            pthread_mutex_lock(&PolarCanvas::current->shape_mutex);

//            if(PolarCanvas::current->displayShapes.size()>0){ //DEBUG block for fixshape

        //        NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
        //        NSAttributedString *stringToInsert;
        //        double shrinkage = 1;

        //        NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 150*shrinkage+12];
        //        string = [[NSMutableAttributedString alloc] initWithString:str];

//                shape = PolarCanvas::current->displayShapes.at(arc4random() % PolarCanvas::current->displayShapes.size());
                
        //        [dict setObject:string forKey:[NSString stringWithFormat:@"%u", sid]];

        //        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];

        //        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[string length])];

        //        stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];

//                stringToDraw = [dict objectForKey:[NSString stringWithFormat:@"%u", shape->getUid()]];
//                NSBitmapImageRep *textImage = [MainView getTextImage:stringToDraw];
//                [stringToDraw removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0,[stringToDraw length])];
//                [stringToDraw addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[stringToDraw length])];
//                
//                unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
//
//                feedShape(pixels, textImage.size.width, textImage.size.height, shape->getUid(),false,false,getShrinkage());
//                
//                PolarCanvas::current->fixShape(shape->getUid());
//            }
//            pthread_mutex_unlock(&PolarCanvas::current->shape_mutex);

            if(shape!=NULL){
                CartisianPoint center = shape->getFinalPlacement()->location;
                NSPoint point = NSMakePoint(center.x,
                                            mainImage.size.height-stringToDraw.size.height-center.y);
                double rotation = -(shape->getFinalPlacement()->rotation)*360/M_PI/2;
                [self drawText:point withStringToInsert:stringToDraw withRotation:rotation];
                
        }
        }
    }
}

- (void)drawColorMappedText:(id)sender{
    
    
    [self loadDirectionImage];
    [self resetMainImage];
    
    startRendering();

}

- (void)feedNextText{
    NSString *str = [strings objectAtIndex:arc4random() % [strings count]];
//    NSAttributedString *stringToInsert;
    double shrinkage = getShrinkage();
    assert(shrinkage<=prevShrinkage);
    prevShrinkage = shrinkage;
    NSFont *font = [NSFont fontWithName:@"Arial" size:((double)arc4random() / 0x100000000) * 150*shrinkage+12];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    
    unsigned int sid = (unsigned int)[dict count];
    [dict setObject:string forKey:[NSString stringWithFormat:@"%u", sid]];
    
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
//    stringToInsert = [[NSAttributedString alloc] initWithAttributedString:string];
    
    NSBitmapImageRep *textImage = [MainView getTextImage:string];
    
    if(textImage.size.width>0){
        unsigned int * pixels = [MainView getPixels:textImage withFlip:false];
        
        feedShape(pixels, textImage.size.width, textImage.size.height, sid,false,false,getShrinkage());
    }
}

-(void)checkAndRenderSlaps{
    SlapInfo placement;
    while(!(placement=getNextSlap()).isEmpty()){
        double rotation = -(placement.rotation)*360/M_PI/2;
        NSMutableAttributedString *string = [dict objectForKey:[NSString stringWithFormat:@"%u", placement.sid]];
        if(string!=nil){
            NSPoint point = NSMakePoint(placement.location.x,
                                        mainImage.size.height-string.size.height-placement.location.y);
            printf("Coord: %f, %f; rotation: %f, color: %x, total: %d\n"
                   ,point.x
                   ,point.y
                   ,placement.rotation,placement.color, counter++);
            unsigned int textColor = placement.color & 0x00FFFFFF;
            NSColor* color = [NSColor colorWithCalibratedRed:((double)(textColor>>16))/255 green:((double)(textColor>>8 & 0x000000FF))/255 blue:((double)(textColor & 0xFF))/255 alpha:1.0F];
            [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[string length])];
//            NSAttributedString* stringToDraw = [[NSAttributedString alloc] initWithAttributedString:string];
            
            [self drawText:point withStringToInsert:string withRotation:rotation];
        }
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
    CGFloat xx = point.x;
    CGFloat yy = point.y +stringToInsert.size.height;
        [transform translateXBy: xx yBy: yy];
        [transform rotateByDegrees:-rotation];
        [transform translateXBy: -xx yBy: -yy];
    
		[transform concat];

    NSPoint topLeftPoint = NSMakePoint(point.x-stringToInsert.size.width/2,
                                point.y+stringToInsert.size.height/2);
		[stringToInsert drawAtPoint:topLeftPoint];
    
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
    
    
    
//    NSUInteger zColourAry[3] = {255,255,255};
//    for(int x=0;x<textImage.size.width;x++)
//        for(int y=0;y<textImage.size.height;y++)
//            [textImage setPixel:zColourAry atX:x y:y];
    
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

- (IBAction)showSavePanel:(id)sender
{
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    NSString *defaultDirectoryPath = @"~";

    // Restrict the file type to whatever you like
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"tyful"]];
    // Set the starting directory
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:defaultDirectoryPath]];
    // Perform other setup
    // Use a completion handler -- this is a block which takes one argument
    // which corresponds to the button that was clicked
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            // Close panel before handling errors
//            [openPanel orderOut:self];
            NSLog(@"Got URL: %@", [savePanel URL]);
            // Do what you need to do with the selected path
        }
    }];
}

@end
