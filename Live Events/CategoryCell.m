//
//  CategoryCell.m
//  Mockup
//
//  Created by Alex Medearis on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "CategoryCell.h"
#import "ReviewItemView.h"
#import "SwipeView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface CategoryCell()

@property (strong) SwipeView * swipeView;

@end


@implementation CategoryCell

@synthesize dataArray = _dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self setup];
}

- (void)setup{
    SwipeView * swipeView = [[SwipeView alloc] init];
    swipeView.translatesAutoresizingMaskIntoConstraints = NO;
    swipeView.dataSource = self;
    swipeView.delegate = self;
    swipeView.wrapEnabled = YES;
    self.swipeView = swipeView;
    [self addSubview:swipeView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[swipeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(swipeView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[swipeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(swipeView)]];
}

- (void)reload{
    [self.swipeView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reload];
}

- (NSArray *)dataArray{
    return _dataArray;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return self.dataArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    ReviewItemView * reviewItem = (ReviewItemView *)view;
    if(reviewItem == nil){
        reviewItem = [[ReviewItemView alloc] init];
    }
    reviewItem.index = index;
    reviewItem.productTitle.text = self.dataArray[index][@"Name"];
    [reviewItem.productImage setImageWithURL:[NSURL URLWithString:self.dataArray[index][@"ImageUrl"]]];
    return reviewItem;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(250, 350);
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    [self.delegate swipeView:swipeView didSelectItemAtIndex:index];
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView {
    [self.delegate swipeViewDidScroll:swipeView];
}

- (void)animateToNext {
    [self.swipeView scrollToItemAtIndex:self.swipeView.currentItemIndex + 1 duration:3.0];
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
