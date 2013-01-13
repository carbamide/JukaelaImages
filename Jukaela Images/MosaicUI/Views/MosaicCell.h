//
//  MosaicModuleView.h
//  MosaicUI
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MosaicData.h"
#import "MosaicViewDelegateProtocol.h"
@class MosaicView;

@interface MosaicCell : UIView <UIGestureRecognizerDelegate>
{
    MosaicData *_module;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) MosaicData *module;
@property (weak, nonatomic) MosaicView *mosaicView;
@property (weak, nonatomic) id delegate;

@end
