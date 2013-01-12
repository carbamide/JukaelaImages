//
//  MosaicModule.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MosaicData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (strong, nonatomic) NSString *imageFilename;
@property (strong, nonatomic) NSString *title;
@property (readwrite, nonatomic) NSInteger size;

@end
