//
//  HuedUILabel.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "HuedUILabel.h"
#import "AppConfig.h"

@implementation HuedUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}



-(void)setup {
    self.textColor = [AppConfig primaryColor];
}

@end
