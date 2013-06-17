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
- (void)cellClickedAtRow:(NSInteger)row column:(NSInteger)column withRating:(NSInteger)rating;
@end

@interface CategoryCell : UITableViewCell<SwipeViewDataSource, SwipeViewDelegate>

@property (strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger myRow;
@property (strong) id<CategoryCellDelegate> delegate;

@end
