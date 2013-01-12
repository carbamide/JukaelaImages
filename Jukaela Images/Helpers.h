//
//  Helpers.h
//  Jukaela Images
//
//  Created by Josh on 1/12/13.
//  Copyright (c) 2013 Jukaela Enterprises All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+(id)sharedInstance;

-(NSString *)documentsPath;

-(void)saveImage:(UIImage *)image withFileName:(NSString *)itemNumber;

@end
