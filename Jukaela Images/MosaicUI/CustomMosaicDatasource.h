//
//  MosaicManager.h
//  Jukaela Images
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosaicViewDatasourceProtocol.h"

@interface CustomMosaicDatasource : NSObject <MosaicViewDatasourceProtocol>{
    NSMutableArray *elements;
}

+ (CustomMosaicDatasource *)sharedInstance;
-(void)refresh;

@end
