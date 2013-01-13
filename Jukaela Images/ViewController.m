//
//  ViewController.m
//  Jukaela Images
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ViewController.h"
#import "MosaicData.h"
#import "MosaicCell.h"
#import "CustomMosaicDatasource.h"
#import "AppDelegate.h"

#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ViewController ()
@property (strong, nonatomic) NSArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [kAppDelegate setCurrentViewController:self];
    
    [_mosaicView setDatasource:[CustomMosaicDatasource sharedInstance]];
    [_mosaicView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)mosaicViewDidTap:(MosaicCell *)aModule
{
    NSURL *urlOfImage = [NSURL URLWithString:[[aModule module] imageFilename]];
        
    MWPhoto *tempPhoto = [MWPhoto photoWithURL:urlOfImage];
    [tempPhoto setCaption:[[aModule module] title]];
    
    [self setPhotos:@[tempPhoto]];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setDisplayActionButton:YES];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)mosaicViewDidDoubleTap:(MosaicCell *)aModule
{
    return;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [[self photos] count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < [[self photos] count]) {
        return [[self photos] objectAtIndex:index];
    }
    return nil;
}

-(void)refresh
{    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{        
        [_mosaicView refresh];
    });
}

@end
