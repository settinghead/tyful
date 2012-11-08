//
//  PolarTree_ExperimentTests.m
//  PolarTree ExperimentTests
//
//  Created by Xiyang Chen on 11/4/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#import "PolarTree_ExperimentTests.h"
#import "MainView.h"
#include "../PolarTree Experiment/polartree/PolarTree.h"
#include "../PolarTree Experiment/polartree/PolarTreeBuilder.h"
#include "../PolarTree Experiment/polartree/PixelImageShape.h"

@implementation PolarTree_ExperimentTests

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
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    NSFont *font = [NSFont fontWithName:@"Arial" size:23.0];
    
    [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,5)];
    [string addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(5,6)];
    [string addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,5)];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithAttributedString:string];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithAttributedString:string];
    
    NSBitmapImageRep *image1 = [MainView getTextImage:str1];
    NSBitmapImageRep *image2 = [MainView getTextImage:str2];
    
    ImageShape *shape1 = new PixelImageShape((unsigned int *)[image1 bitmapData], [image1 size].width, [image1 size].height);
    ImageShape *shape2 = new ImageShape((unsigned int *)[image2 bitmapData], [image2 size].width, [image2 size].height);
    PolarRootTree *tree1 = makeTree(shape1, 0);
    PolarRootTree *tree2 = makeTree(shape2, 0);    
    
    tree1->setLocation(0,0);
    tree2->setLocation(0,image1.size.height+10);
    
    if(tree1->collide(tree2))
        STFail(@"Collision test failed.");

    
}

@end
