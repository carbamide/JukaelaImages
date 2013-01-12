//
//  TwoDimentionalArray.m
//  MosaicUI
//
//  Created by Ezequiel A Becerra on 11/24/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "TwoDimentionalArray.h"

#define INVALID_ELEMENT_INDEX -1

@implementation TwoDimentionalArray

#pragma mark - Private

-(NSInteger)elementIndexWithColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex
{
    NSInteger returnValue = 0;

    if (xIndex >= _columns || yIndex >= _rows) {
        returnValue = INVALID_ELEMENT_INDEX;
    }
    else{
        returnValue = xIndex + (yIndex * _columns);
    }
    return returnValue;
}

#pragma mark - Public

-(id)initWithColumns:(NSUInteger)numberOfColumns andRows:(NSUInteger)numberOfRows
{
    self = [super init];
    if (self) {
        NSUInteger capacity = numberOfColumns * numberOfRows;
        _columns = numberOfColumns;
        _rows = numberOfRows;
        _elements = [[NSMutableArray alloc] initWithCapacity:capacity];
        
        for (NSInteger i=0; i<capacity; i++) {
            [_elements addObject:[NSNull null]];
        }
    }
    return self;
}

-(id)objectAtColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex
{
    id returnValue = nil;
    
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];

    if (elementIndex != INVALID_ELEMENT_INDEX) {
        if ([_elements objectAtIndex:elementIndex] != [NSNull null]) {
            returnValue = [_elements objectAtIndex:elementIndex];
        }
    }

    return returnValue;
}

-(void)setObject:(id)anObject atColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex
{
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];
    
    [_elements replaceObjectAtIndex:elementIndex withObject:anObject];
}

@end
