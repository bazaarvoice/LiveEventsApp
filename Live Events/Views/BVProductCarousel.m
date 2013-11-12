//
//  BVProductCarousel.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BVProductCarousel.h"
#import "ReviewItemView.h"
#import "UIImageView+WebCache.h"
#import "LinearEaseSwipeView.h"
#import <QuartzCore/QuartzCore.h>

@interface BVProductCarousel()
// Internal swipeview
@property (strong) SwipeView * swipeView;
@end

@implementation BVProductCarousel

@synthesize dataArray = _dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// Loaded from storyboard
- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self setup];
}

- (void)setup{
    // Create a swipe view and position it to take up the entirety of the view
    LinearEaseSwipeView * swipeView = [[LinearEaseSwipeView alloc] init];
    swipeView.translatesAutoresizingMaskIntoConstraints = NO;
    swipeView.dataSource = self;
    swipeView.delegate = self;
    swipeView.wrapEnabled = YES;
    self.swipeView = swipeView;
    [self addSubview:swipeView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[swipeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(swipeView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[swipeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(swipeView)]];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.swipeView reloadData];
}

- (NSArray *)dataArray{
    return _dataArray;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return self.dataArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    // Create view if necessary
    ReviewItemView * reviewItem = (ReviewItemView *)view;
    if(reviewItem == nil){
        reviewItem = [[ReviewItemView alloc] init];
    }
    reviewItem.index = index;
    reviewItem.productTitle.text = self.dataArray[index][@"Name"];
    
    // Image data can be finnicky, particularly on staging -- validate imageurl before setting
    if(self.dataArray[index][@"ImageUrl"] && self.dataArray[index][@"ImageUrl"] != [NSNull null]) {
        // TODO: remove custom code for Acuvue
        NSString * imageUrl = [self.dataArray[index][@"ImageUrl"] stringByReplacingOccurrencesOfString:@"http://www.jnjvisioncare.com/en_US/images/products/"
                                                                              withString:@"http://www.acuvue.com/sites/default/files/content/us/images/products/"];
        
        [reviewItem.productImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noimage.jpeg"]];
    } else {
        reviewItem.productImage.image = [UIImage imageNamed:@"noimage.jpeg"];
    }
    return reviewItem;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(250, 350);
}

// Pass on delegate methods to delegate
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    [self.delegate swipeView:swipeView didSelectItemAtIndex:index];
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView {
    [self.delegate swipeViewDidScroll:swipeView];
}

- (void)animateToNext {
    [self.swipeView scrollToItemAtIndex:self.swipeView.currentItemIndex + 1 duration:3.0];
}

@end
