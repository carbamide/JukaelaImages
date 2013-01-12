//
//  MosaivView.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 11/26/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicView.h"
#import "MosaicData.h"
#import "MosaicDataView.h"

#define kModuleSizeInPoints_iPhone 80
#define kModuleSizeInPoints_iPad 128
#define kMaxScrollPages_iPhone 4
#define kMaxScrollPages_iPad 4

@interface MosaicView ()
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MosaicView

- (void)setup
{
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    [self setScrollView:[[UIScrollView alloc] initWithFrame:[self bounds]]];
    
    [[self scrollView] setBackgroundColor:[UIColor blackColor]];
    
    [self addSubview:[self scrollView]];
}

-(void)handleRefresh:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [[self datasource] refresh];
        
        [self setupLayoutWithMosaicElements:[[self datasource] mosaicElements]];
    });
}

- (BOOL)doesModuleWithCGSize:(CGSize)aSize fitsInCoord:(CGPoint)aPoint
{
    BOOL returnValue = YES;
    
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (returnValue && yOffset < aSize.height) {
        xOffset = 0;
        
        while (returnValue && xOffset < aSize.width) {
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            if (xIndex < [self maxElementsX] && yIndex < [self maxElementsY]) {
                
                id anObject = [[self elements] objectAtColumn:xIndex andRow:yIndex];
                
                if (anObject != nil) {
                    returnValue = NO;
                }
                
                xOffset++;
            }
            else{
                returnValue = NO;
            }
        }
        
        yOffset++;
    }
    
    return returnValue;
}

- (void)setModule:(MosaicData *)aModule withCGSize:(CGSize)aSize withCoord:(CGPoint)aPoint
{
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (yOffset < aSize.height) {
        xOffset = 0;
        
        while (xOffset < aSize.width) {
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            [[self elements] setObject:aModule atColumn:xIndex andRow:yIndex];
            
            xOffset++;
        }
        
        yOffset++;
    }
}

- (NSArray *)coordArrayForCGSize:(CGSize)aSize
{
    NSArray *returnValue = nil;
    
    BOOL hasFound = NO;
    
    NSInteger i=0;
    NSInteger j=0;
    
    while (j < [self maxElementsY] && !hasFound) {
        i = 0;
        while (i < [self maxElementsX] && !hasFound) {
            BOOL fitsInCoord = [self doesModuleWithCGSize:aSize fitsInCoord:CGPointMake(i, j)];
            
            if (fitsInCoord) {
                hasFound = YES;
                
                NSNumber *xIndex = [NSNumber numberWithInteger:i];
                NSNumber *yIndex = [NSNumber numberWithInteger:j];
                
                returnValue = @[xIndex, yIndex];
            }
            i++;
        }
        j++;
    }
    
    return returnValue;
}

- (CGSize)sizeForModuleSize:(NSUInteger)aSize
{
    CGSize returnValue = CGSizeZero;
    
    switch (aSize) {
        case 0:
            returnValue = CGSizeMake(4, 4);
            
            break;
        case 1:
            returnValue = CGSizeMake(2, 2);
            
            break;
        case 2:
            returnValue = CGSizeMake(1, 1);
            
            break;
        default:
            break;
    }
    
    return returnValue;
}

- (NSInteger)moduleSizeInPoints
{
    NSInteger returnValue = kModuleSizeInPoints_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        returnValue = kModuleSizeInPoints_iPad;
    }
    
    return returnValue;
}

- (NSInteger)maxElementsX
{
    NSInteger returnValue = _maxElementsX;
    
    if (returnValue == -1) {
        returnValue = self.frame.size.width / [self moduleSizeInPoints];
    }
    
    return returnValue;
}

- (NSInteger)maxElementsY
{
    NSInteger returnValue = _maxElementsY;
    
    if (returnValue == -1) {
        returnValue = self.frame.size.height / [self moduleSizeInPoints] * [self maxScrollPages];
    }
    
    return returnValue;
}

- (NSInteger)maxScrollPages
{
    NSInteger returnValue = kMaxScrollPages_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        returnValue = kMaxScrollPages_iPad;
    }
    
    return returnValue;
}

- (void)setupLayoutWithMosaicElements:(NSArray *)mosaicElements
{
    NSInteger yOffset = 0;
    
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    NSInteger scrollHeight = 0;
    
    [[self scrollView] setFrame:[self bounds]];
    
    for (UIView *subview in [[self scrollView] subviews]) {
        if ([subview tag] != 22) {
            [subview removeFromSuperview];
        }
    }
    
    NSUInteger maxElementsX = [self maxElementsX];
    NSUInteger maxElementsY = [self maxElementsY];
    
    [self setElements:[[TwoDimentionalArray alloc] initWithColumns:maxElementsX andRows:maxElementsY]];
        
    CGPoint modulePoint = CGPointZero;
    
    MosaicDataView *lastModuleView = nil;
    
    for (MosaicData *aModule in mosaicElements) {
        CGSize aSize = [self sizeForModuleSize:aModule.size];
        
        NSArray *coordArray = [self coordArrayForCGSize:aSize];
        
        if (coordArray) {
            NSInteger xIndex = [coordArray[0] integerValue];
            NSInteger yIndex = [coordArray[1] integerValue];
            
            modulePoint = CGPointMake(xIndex, yIndex);
            
            [self setModule:aModule withCGSize:aSize withCoord:modulePoint];
            
            CGRect mosaicModuleRect = CGRectMake(xIndex * [self moduleSizeInPoints],
                                                 yIndex * [self moduleSizeInPoints] + yOffset,
                                                 aSize.width * [self moduleSizeInPoints],
                                                 aSize.height * [self moduleSizeInPoints]);
            
            lastModuleView = [[MosaicDataView alloc] initWithFrame:mosaicModuleRect];
            [lastModuleView setModule:aModule];
            [lastModuleView setDelegate:[self delegate]];
            [lastModuleView setMosaicView:self];
            
            [[self scrollView] addSubview:lastModuleView];
            
            scrollHeight = MAX(scrollHeight, lastModuleView.frame.origin.y + lastModuleView.frame.size.height);
        }
    }
    
    CGSize contentSize = CGSizeMake(self.scrollView.frame.size.width,scrollHeight);
    
    [[self scrollView] setContentSize:contentSize];
    
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [_refreshControl setTag:22];
        
        [[self scrollView] addSubview:_refreshControl];
    }
    else {
        [_refreshControl endRefreshing];
    }
}

#pragma mark - Public

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)layoutSubviews
{
    NSArray *mosaicElements = [[self datasource] mosaicElements];
    
    [self setupLayoutWithMosaicElements:mosaicElements];
    
    [super layoutSubviews];
}

-(void)refresh
{
    [self setup];
}

@end
