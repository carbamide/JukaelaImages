//
//  MosaicManager.m
//  Jukaela Images
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "CustomMosaicDatasource.h"
#import "MosaicData.h"

@implementation CustomMosaicDatasource

-(void)loadFromJukaela
{    
    NSString *pathString = @"http://cold-planet-7717.herokuapp.com/microposts/images_from_feed.json";
    
    NSData *elementsData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pathString]];

    if (!elementsData) {
        [self loadFromJukaela];
        
        return;
    }
    
    NSError *anError = nil;
    
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData options:NSJSONReadingAllowFragments error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements) {
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        
        [elements addObject:aMosaicModule];
    }
}


-(id)init
{
    self = [super init];

    if (self) {
        elements = [[NSMutableArray alloc] init];
        
        [self loadFromJukaela];
    }
    
    return self;
}

+ (CustomMosaicDatasource *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

-(NSArray *)mosaicElements
{
    NSArray *returnArray = elements;
    
    return returnArray;
}

-(void)refresh
{
    elements = [[NSMutableArray alloc] init];
    
    [self loadFromJukaela];
}

@end
