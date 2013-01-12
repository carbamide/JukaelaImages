//
//  Helpers.m
//  Jukaela Images
//
//  Created by Josh on 1/12/13.
//  Copyright (c) 2013 Jukaela Enterprises All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)saveImage:(UIImage *)image withFileName:(NSString *)name
{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDirectory = paths[0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:[NSString stringWithFormat:@"%@", name]]];
            
            NSData *data = UIImagePNGRepresentation(image);
            
            [data writeToFile:path atomically:YES];
        });
    }
    else {
        NSLog(@"The image to save is nil");
    }
}

-(NSString *)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
