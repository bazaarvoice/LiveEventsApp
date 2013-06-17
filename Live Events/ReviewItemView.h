//
//  ReviewItemView.h
//  Mockup
//
//  Created by Alex Medearis on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "SwipeView.h"

@interface ReviewItemView : UICollectionViewCell <RateViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet RateView *rateViewEnabled;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (nonatomic) NSInteger index;
@property (strong) id<SwipeViewDelegate> swipeDelegate;

@end
