//
//  JukaelaLabel.m
//  Jukaela Images
//
//  Created by Josh on 1/10/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JukaelaLabel.h"

@implementation JukaelaLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawTextInRect:(CGRect)rect
{
    CGSize myShadowOffset = CGSizeMake(0, 0);
    float myColorValues[] = {0, 0, 0, .9};
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
    CGContextSetShadowWithColor (myContext, myShadowOffset, 5, myColor);
    
    [super drawTextInRect:rect];
    
    CGColorRelease(myColor);
    CGColorSpaceRelease(myColorSpace);
    
    CGContextRestoreGState(myContext);
}

@end
