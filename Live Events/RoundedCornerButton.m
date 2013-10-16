//
//  RoundedCornerButton.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "RoundedCornerButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedCornerButton

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

// Sets the initial parameters on the button layer
- (void)baseInit {
    [self.layer setCornerRadius:8.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
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

@end
