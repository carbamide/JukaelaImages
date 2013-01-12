//
//  MosaicModuleView.m
//  MosaicUI
//
//  Created by Josh Barrow on 1/10/13.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicDataView.h"
#import "MosaicView.h"
#import "JukaelaLabel.h"
#import "Helpers.h"

#define kMosaicDataViewDidTouchNotification @"kMosaicDataViewDidTouchNotification"
#define kMosaicDataViewFont @"Helvetica"

@implementation MosaicDataView

@synthesize delegate, mosaicView;

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

-(void)mosaicViewDidTouch:(NSNotification *)aNotification
{
    MosaicDataView *aView = [[aNotification userInfo] objectForKey:@"mosaicDataView"];
    
    if (aView != self) {
        //a different cell has been selected
    }
}

-(NSString *)title
{
    NSString *returnValue = [titleLabel text];
    return returnValue;
}

-(void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
}

-(void)setModule:(MosaicData *)newModule
{
    module = newModule;
    
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
    
    [imageView setImage:img];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [indicator setCenter:CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds))];
    
    [self addSubview:indicator];
    
    [indicator startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        NSMutableString *tempString = [NSMutableString stringWithString:[[self module] imageFilename]];
        
        NSString *tempExtensionString = [NSString stringWithFormat:@".%@", [tempString pathExtension]];
        
        [tempString stringByReplacingOccurrencesOfString:tempExtensionString withString:@""];
        [tempString appendFormat:@"m"];
        [tempString appendString:tempExtensionString];
        
        NSString *localfile = [tempString lastPathComponent];
        
        __block UIImage *anImage = [UIImage imageWithContentsOfFile:[[[Helpers sharedInstance] documentsPath] stringByAppendingPathComponent:localfile]];
        
        if (anImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:anImage];
                
                [self finishUpWithImageView:anImage indicator:indicator];
            });
        }
        else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                NSURL *url = [NSURL URLWithString:tempString];
                
                anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:anImage];
                    
                    [[Helpers sharedInstance] saveImage:anImage withFileName:localfile];
                    
                    [self finishUpWithImageView:anImage indicator:indicator];
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
    
    CGRect newFrame = imageView.frame;
    newFrame.size.height /= scale;
    newFrame.size.width /= scale;
    
    [imageView setFrame:newFrame];
    [imageView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    NSInteger marginLeft = self.frame.size.width / 20;
    NSInteger marginBottom = self.frame.size.height / 20;
    
    [titleLabel setText:[module title]];
    [titleLabel setFont:[self fontWithModuleSize:[module size]]];
    [titleLabel setNumberOfLines:3];
    
    CGSize newSize = [[module title] sizeWithFont:[titleLabel font] constrainedToSize:titleLabel.frame.size];
    CGRect newRect = CGRectMake(marginLeft, self.frame.size.height - newSize.height - marginBottom, newSize.width, newSize.height);
    
    [titleLabel setFrame:newRect];
    
    [indicator stopAnimating];
    
    [indicator removeFromSuperview];
}

-(MosaicData *)module
{
    return module;
}

-(void)displayHighlightAnimation
{
    NSDictionary *aDict = @{@"mosaicDataView" : self};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMosaicDataViewDidTouchNotification object:nil userInfo:aDict];
    
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
    if ([delegate respondsToSelector:@selector(mosaicViewDidTap:)]) {
        [delegate mosaicViewDidTap:self];
    }
    
    [[self mosaicView] setSelectedDataView:self];
    
    [self displayHighlightAnimation];
}

-(void)doubleTapReceived:(id)sender
{
    if ([delegate respondsToSelector:@selector(mosaicViewDidDoubleTap:)]) {
        [delegate mosaicViewDidDoubleTap:self];
    }
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect imageViewFrame = CGRectMake(0,0,frame.size.width,frame.size.height);
        
        imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:imageView];
        
        CGRect titleLabelFrame = CGRectMake(0, round(frame.size.height/2), frame.size.width - 10, round(frame.size.height/2));
        
        titleLabel = [[JukaelaLabel alloc] initWithFrame:titleLabelFrame];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:kMosaicDataViewFont size:12]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [titleLabel setNumberOfLines:1];
        [titleLabel setMinimumScaleFactor:8];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        
        [self addSubview:titleLabel];
        
        [[self layer] setBorderWidth:1];
        [[self layer] setBorderColor:[[UIColor blackColor] CGColor]];
        
        [self setClipsToBounds:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mosaicViewDidTouch:) name:kMosaicDataViewDidTouchNotification object:nil];
        
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
