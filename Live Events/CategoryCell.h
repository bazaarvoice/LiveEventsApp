//
//  CategoryCell.h
//  Mockup
//
//  Created by Alex Medearis on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"


@protocol CategoryCellDelegate
- (void)cellClickedAtIndex:(NSInteger)index;
@end

@interface CategoryCell : UIView<SwipeViewDataSource, SwipeViewDelegate>

@property (strong) NSArray * dataArray;
@property (strong) id<CategoryCellDelegate> delegate;


- (void)animateToNext;

@end
