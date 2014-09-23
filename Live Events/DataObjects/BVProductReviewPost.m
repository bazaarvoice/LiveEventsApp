//
//  BVProductReviewPost.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BVProductReviewPost.h"
#import "AppConfig.h"

@implementation BVProductReviewPost


-(id)initWithProductReview:(ProductReview *)productReview {
    self = [super initWithType:BVPostTypeReview];
    if(self){
        
        self.userNickname = productReview.nickname;
        // Truncate nickname to 15 characters
        if(self.userNickname.length > 15)
            self.userNickname = [self.userNickname substringWithRange:NSMakeRange(0, 15)];
        // Append random number for uniqueness
        int randNum = arc4random_uniform(100000);
        self.userNickname = [NSString stringWithFormat:@"%@%d", self.userNickname, randNum];
        // Remove spaces (just in case)
        self.userNickname = [self.userNickname stringByReplacingOccurrencesOfString:@" " withString:@""];
        // Add extra padding if too short
        if(self.userNickname.length < 5) {
            randNum = arc4random_uniform(100);
            self.userNickname = [NSString stringWithFormat:@"%@%d", self.userNickname, randNum];
        }
        
        self.productToReview = productReview;
        self.productId = productReview.productId;
        // UserId should be the same as nickname
        self.userId = self.userNickname;
        self.userEmail = productReview.email;
        self.rating = [productReview.rating intValue];
        self.reviewText = productReview.reviewText;
        self.title = productReview.title;
        self.action = BVActionSubmit;
        
        // User id should be the same as nickname
        self.userId = self.userNickname;
        
        // Campaign id and CDV
        self.campaignId = [AppConfig appCampaignID];
        [self setContextDataValue:[AppConfig appCampaignID] value:@"true"];
        
        // TODO: Remove
        [self setContextDataValue:@"EyecarePro" value:@"Yes"];

    }
    return self;
}

@end
