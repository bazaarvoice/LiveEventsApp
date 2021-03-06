//
//  ReviewItemView.m
//  LiveEvents
//
//  Created by Bazaarvoice Engineering on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ReviewItemView.h"

@implementation ReviewItemView

- (id)init{
    return [self initWithFrame:CGRectMake(0, 0, 237, 348)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];    
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self setup];
    }
    return self;
}

-(NSString *)reuseIdentifier {
    return @"ReviewItemCell";
}

- (void)setup{
    // Load the review item as a subview from nib
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ReviewItem" owner:self options:nil] objectAtIndex:0]];
}


@end
