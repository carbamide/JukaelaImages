//
//  JukaelaActivity.m
//  Jukaela Images
//
//  Created by Josh on 1/11/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JukaelaActivity.h"
#import "BlockAlertView.h"

@implementation JukaelaActivity

- (NSString *)activityType
{
    return @"com.jukaela.Jukaela";
}

- (NSString *)activityTitle
{
    return @"Jukaela Social";
}

- (UIImage *)activityImage
{
    UIImage *icon = [UIImage imageNamed:@"jukaelashare.png"];
    
    return icon;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"prepareWithActivityItems");
}

- (void)performActivity
{
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Nothing!" message:@"This doesn't do anything yet!"];
    
    [alert setCancelButtonWithTitle:@"OK" block:nil];
    
    [alert show];
}

@end
