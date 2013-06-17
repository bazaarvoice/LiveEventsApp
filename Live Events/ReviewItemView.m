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
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    self.rateViewEnabled.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateViewEnabled.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateViewEnabled.alpha = 2;
    self.rateViewEnabled.editable = YES;
    self.rateViewEnabled.maxRating = 5;
    self.rateViewEnabled.delegate = self;
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    [self.swipeDelegate swipeView:(SwipeView *)self.superview.superview didSelectItemAtIndex:self.index];
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.rateViewEnabled.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:1.0
                                               delay: 2.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.rateViewEnabled.alpha = .02;
                                          }
                                          completion:nil];
                     }];
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
