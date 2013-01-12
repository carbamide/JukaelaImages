//
//  MosaicModule.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicData.h"

@implementation MosaicData

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self) {
        [self setImageFilename:aDict[@"imageFilename"]];
        [self setSize:[aDict[@"size"] integerValue]];
        [self setTitle:aDict[@"title"]];
    }
    return self;
}

-(NSString *)description
{
    NSString *returnValue = [NSString stringWithFormat:@"%@ %@", [super description], [self title]];
    
    return returnValue;
}

@end
