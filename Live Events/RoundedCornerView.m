//
//  RoundedCornerView.m
//  RoundedCornerDemo
//
//  Created by Alex Medearis on 11/5/12.
//  Copyright (c) 2012 Aliston Software. All rights reserved.
//

#import "RoundedCornerView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BORDER_COLOR [UIColor blackColor];

@implementation RoundedCornerView

- (void)baseInit {
    [self.layer setCornerRadius:8.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBackgroundColor:[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0].CGColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.layer setBackgroundColor:backgroundColor.CGColor];
}

-(UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(float)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

- (float)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(float)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}

- (float)cornerRadius
{
    return self.layer.cornerRadius;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
