//
//  BVProductReviewPost.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BVProductReviewPost.h"

@implementation BVProductReviewPost


-(id)initWithProductReview:(ProductReview *)productReview {
    self = [super initWithType:BVPostTypeReview];
    if(self){
        self.productToReview = productReview;
        self.userNickname = productReview.nickname;
        self.productId = productReview.productId;
        self.userId = productReview.nickname;
        self.userEmail = productReview.email;
        self.rating = [productReview.rating intValue];
        self.reviewText = productReview.reviewText;
        self.action = BVActionSubmit;
    }
    return self;
}

@end
