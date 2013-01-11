//
//  ViewController.h
//  Jukaela Images
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicView.h"
#import "MosaicViewDelegateProtocol.h"
#import "MWPhotoBrowser.h"

@interface ViewController : UIViewController <MosaicViewDelegateProtocol, MWPhotoBrowserDelegate>

@property (strong, nonatomic) IBOutlet MosaicView *mosaicView;

-(void)refresh;

@end
