//
//  ReviewItemView.h
//  LiveEvents
//
//  Reusable view for displaying a product.
//
//  Created by Bazaarvoice Engineering on 5/16/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewItemView : UICollectionViewCell

// Image of product
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
// Name of product
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
// Stored index (for click handling)
@property (nonatomic) NSInteger index;

@end
