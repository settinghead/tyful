//
//  osx_clientTests.m
//  osx_clientTests
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "osx_clientTests.h"
#import "MainView.h"
#include "../osx_client/polartree/PolarTree.h"
#include "../osx_client/polartree/PolarTreeBuilder.h"
#include "../osx_client/polartree/PixelImageShape.h"

@implementation osx_clientTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testPolarTreeCollide
{
    
    NSString *str = @"firstsecondthird";
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc] initWithString:str];
    NSFont *font = [NSFont fontWithName:@"Arial" size:23.0];
    
    [string1 addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
    [string1 addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(5,6)];
    [string1 addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
    [string1 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
    [string2 addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(5,6)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
    [string2 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithAttributedString:string1];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithAttributedString:string2];
    
    NSBitmapImageRep *image1 = [MainView getTextImage:str1];
    NSBitmapImageRep *image2 = [MainView getTextImage:str2];
    unsigned int * pixels1 = [MainView getFlippedPixels:image1];
    unsigned int * pixels2 = [MainView getFlippedPixels:image2];
//
//    ImageShape *shape1 = new TextImageShape((unsigned int *)pixels1, [image1 size].width, [image1 size].height);
//    ImageShape *shape2 = new TextImageShape((unsigned int *)pixels2, [image2 size].width, [image2 size].height);
//    PolarRootTree *tree1 = makeTree(shape1, 0);
//    PolarRootTree *tree2 = makeTree(shape2, 0);    
//    
//    tree1->setLocation(0,0);
//    tree2->setLocation(0,image1.size.height+100);
//    
//    if(tree1->overlaps(tree2))
//        STFail(@"Collision test failed.");

    
}

@end
