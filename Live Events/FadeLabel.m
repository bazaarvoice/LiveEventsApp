//
//  FadeLabel.m
//  Live Events
//
//  Created by Alex Medearis on 6/19/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "FadeLabel.h"

@interface FadeLabel()

@property (weak)UILabel * boldLabel;

@end

@implementation FadeLabel

@synthesize secondaryColor = _secondaryColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *boldLabel = [[UILabel alloc] initWithFrame:self.frame];
    [self addSubview:boldLabel];
    self.boldLabel = boldLabel;
    self.boldLabel.text = self.text;
    self.boldLabel.font = self.font;
    self.boldLabel.textColor = [UIColor blueColor];
    self.boldLabel.backgroundColor = [UIColor clearColor];
    [self showSecondaryColor:NO];
}

-(void)layoutSubviews {
    self.boldLabel.frame = self.bounds;
}

-(UIColor *)secondaryColor {
    return _secondaryColor;
}

-(void)setSecondaryColor:(UIColor *)secondaryColor{
    _secondaryColor = secondaryColor;
    self.boldLabel.textColor = secondaryColor;
}

-(void)showSecondaryColor:(BOOL)secondaryColorVisible{
    if(secondaryColorVisible){
        self.boldLabel.alpha = 1.0;
    } else {
        self.boldLabel.alpha = 0;
    }
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
