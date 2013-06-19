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

@interface ReviewItemView : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (nonatomic) NSInteger index;
@property (strong) id<SwipeViewDelegate> swipeDelegate;

@end
