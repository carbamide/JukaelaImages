//
//  MosaicViewDelegateProtocol.h
//  MosaicUI
//
//  Created by Ezequiel A Becerra on 11/25/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MosaicCell;

@protocol MosaicViewDelegateProtocol <NSObject>

-(void)mosaicViewDidTap:(MosaicCell *)aModule;
-(void)mosaicViewDidDoubleTap:(MosaicCell *)aModule;

@end
