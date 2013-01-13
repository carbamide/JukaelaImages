//
//  MosaicModuleView.m
//  MosaicUI
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicCell.h"
#import "MosaicView.h"
#import "JukaelaLabel.h"
#import "Helpers.h"

#define kMosaicDataViewFont @"Helvetica"

@implementation MosaicCell

@synthesize module = _module;

#pragma mark - Private

-(UIFont *)fontWithModuleSize:(NSUInteger)aSize
{
    UIFont *returnValue = nil;
    
    switch (aSize) {
        case 0:
            returnValue = [UIFont fontWithName:kMosaicDataViewFont size:24];
            
            break;
        case 1:
            returnValue = [UIFont fontWithName:kMosaicDataViewFont size:15];
            
            break;
        case 2:
            returnValue = [UIFont fontWithName:kMosaicDataViewFont size:14];
            
            break;
        default:
            returnValue = [UIFont fontWithName:kMosaicDataViewFont size:14];
            
            break;
    }
    
    return returnValue;
}

-(NSString *)title
{
    NSString *returnValue = [[self titleLabel] text];
    
    return returnValue;
}

-(void)setTitle:(NSString *)title
{
    [[self titleLabel] setText:title];
}

-(void)setModule:(MosaicData *)newModule
{
    _module = newModule;
        
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[self imageView] setImage:img];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [_indicator setCenter:CGPointMake(CGRectGetMidX(self.imageView.bounds), CGRectGetMidY(self.imageView.bounds))];
    
    [self addSubview:_indicator];
    
    [_indicator startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        NSMutableString *tempString = [NSMutableString stringWithString:[_module imageFilename]];
        
        NSString *tempExtensionString = [NSString stringWithFormat:@".%@", [tempString pathExtension]];
        
        [tempString stringByReplacingOccurrencesOfString:tempExtensionString withString:@""];
        [tempString appendFormat:@"m"];
        [tempString appendString:tempExtensionString];
        
        NSString *localfile = [tempString lastPathComponent];
        
        __block UIImage *anImage = [UIImage imageWithContentsOfFile:[[[Helpers sharedInstance] documentsPath] stringByAppendingPathComponent:localfile]];
        
        if (anImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self imageView] setImage:anImage];
                
                CATransition *transition = [CATransition animation];
                [transition setDuration:1];
                [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [transition setType:kCATransitionFade];
                
                [[[self imageView] layer] addAnimation:transition forKey:nil];
                
                [self finishUpWithImageView:anImage indicator:_indicator];
            });
        }
        else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                NSURL *url = [NSURL URLWithString:tempString];
                
                anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self imageView] setImage:anImage];
                    
                    CATransition *transition = [CATransition animation];
                    [transition setDuration:1];
                    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    [transition setType:kCATransitionFade];
                    
                    [[[self imageView] layer] addAnimation:transition forKey:nil];
                    
                    [[Helpers sharedInstance] saveImage:anImage withFileName:localfile];
                    
                    [self finishUpWithImageView:anImage indicator:_indicator];
                });
            });
        }
    });
}

-(void)finishUpWithImageView:(UIImage *)anImage indicator:(UIActivityIndicatorView *)indicator
{
    float scale = 1;
    
    if (anImage.size.width < anImage.size.height) {
        scale = anImage.size.width / anImage.size.height;
    }
    else {
        scale = anImage.size.height / anImage.size.width;
    }
    
    CGRect newFrame = self.imageView.frame;
    newFrame.size.height /= scale;
    newFrame.size.width /= scale;
    
    [[self imageView] setFrame:newFrame];
    [[self imageView] setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    NSInteger marginLeft = self.frame.size.width / 20;
    NSInteger marginBottom = self.frame.size.height / 20;
    
    [[self titleLabel] setText:[_module title]];
    [[self titleLabel] setFont:[self fontWithModuleSize:[_module size]]];
    [[self titleLabel] setNumberOfLines:3];
    
    CGSize newSize = [[_module title] sizeWithFont:[[self titleLabel] font] constrainedToSize:self.titleLabel.frame.size];
    CGRect newRect = CGRectMake(marginLeft, self.frame.size.height - newSize.height - marginBottom, newSize.width + 15, newSize.height + 15);
    
    [[self titleLabel] setFrame:newRect];
    
    [[self titleLabel] setCenter:CGPointMake(self.imageView.center.x, newRect.origin.y)];
    
    [indicator stopAnimating];
}

-(MosaicData *)module
{
    return _module;
}

-(void)displayHighlightAnimation
{
    [self setAlpha:0.3];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self setAlpha:1];
                     }
                     completion:^(BOOL completed) {
                         
                     }];
}

-(void)simpleTapReceived:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(mosaicViewDidTap:)]) {
        [[self delegate] mosaicViewDidTap:self];
    }
    
    [[self mosaicView] setSelectedDataView:self];
    
    [self displayHighlightAnimation];
}

-(void)doubleTapReceived:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(mosaicViewDidDoubleTap:)]) {
        [[self delegate] mosaicViewDidDoubleTap:self];
    }
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect imageViewFrame = CGRectMake(0,0,frame.size.width,frame.size.height);
        
        [self setImageView:[[UIImageView alloc] initWithFrame:imageViewFrame]];
        
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:[self imageView]];
        
        CGRect titleLabelFrame = CGRectMake(0, round(frame.size.height/2), frame.size.width - 10, round(frame.size.height/2));
        
        [self setTitleLabel:[[JukaelaLabel alloc] initWithFrame:titleLabelFrame]];
                
        [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self titleLabel] setBackgroundColor:[UIColor clearColor]];
        [[self titleLabel] setFont:[UIFont fontWithName:kMosaicDataViewFont size:12]];
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
        [[self titleLabel] setShadowColor:[UIColor blackColor]];
        [[self titleLabel] setShadowOffset:CGSizeMake(0, 1)];
        [[self titleLabel] setNumberOfLines:1];
        [[self titleLabel] setMinimumScaleFactor:8];
        [[self titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [[self titleLabel] setClipsToBounds:NO];
        [[[self titleLabel] layer] setMasksToBounds:NO];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"show_labels"] == YES){
            [self addSubview:[self titleLabel]];
        }
                
        [[self layer] setBorderWidth:1];
        [[self layer] setBorderColor:[[UIColor blackColor] CGColor]];
        
        [self setClipsToBounds:YES];
        
        UITapGestureRecognizer *simpleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleTapReceived:)];
        
        [simpleTapRecognizer setNumberOfTapsRequired:1];
        [simpleTapRecognizer setDelegate:self];
        
        [self addGestureRecognizer:simpleTapRecognizer];
    }
    
    return self;
}

-(void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super removeFromSuperview];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL returnValue = YES;
    
    SEL aSel = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    
    if ([UIView instancesRespondToSelector:aSel]) {
        returnValue = [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
    
    return returnValue;
}

@end
