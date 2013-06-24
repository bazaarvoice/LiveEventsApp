//
//  BVProductReviewPost.h
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <BVSDK/BVSDK.h>
#import "ProductReview.h"

@interface BVProductReviewPost : BVPost

@property (strong) ProductReview *productToReview;

-(id)initWithProductReview:(ProductReview *)productReview;

@end
