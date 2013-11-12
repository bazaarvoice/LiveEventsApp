//
//  BVProductCarousel.h
//  Live Events
//
//  Encapsulates a custom carousel for displaying an array of BV products
//
//  Created by Bazaarvoice Engineering on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"


@interface BVProductCarousel : UIView<SwipeViewDataSource, SwipeViewDelegate>

// Data array of products to display -- typically from a parsed json reviews request
@property (strong) NSArray * dataArray;
// Delegate to proxy SwipeViewDelegate calls
@property (strong) id<SwipeViewDelegate> delegate;

// Animates the carousel to the next item
- (void)animateToNext;

@end
