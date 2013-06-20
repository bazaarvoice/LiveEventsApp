//
//  ReviewItemView.m
//  Mockup
//
//  Created by Alex Medearis on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ReviewItemView.h"

@implementation ReviewItemView

- (id)init{
    return [self initWithFrame:CGRectMake(0, 0, 250, 350)];
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
    return @"ReviewCell";
}

- (void)setup{
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ReviewItem" owner:self options:nil] objectAtIndex:0]];
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
