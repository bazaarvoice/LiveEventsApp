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
        NSString * nicknameString = productReview.nickname;
        if(nicknameString.length > 24)
            nicknameString = [productReview.nickname substringWithRange:NSMakeRange(0, 24)];
        self.productToReview = productReview;
        self.userNickname = nicknameString;
        self.productId = productReview.productId;
        self.userId = nicknameString;
        self.userEmail = productReview.email;
        self.rating = [productReview.rating intValue];
        self.reviewText = productReview.reviewText;
        self.action = BVActionSubmit;
        
        // Fix nickname so that it is unique and short enough
        if(self.userNickname.length > 15)
            self.userNickname = [self.userNickname substringWithRange:NSMakeRange(0, 15)];
        self.userNickname = [NSString stringWithFormat:@"%@%@", self.userNickname, [self getRandomStringToAppend]];
        self.userNickname = [self.userNickname stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // User id should be the same as nickname
        self.userId = self.userNickname;
        
        // Campaign id and CDV
        self.campaignId = [AppConfig appCDV];
        [self setContextDataValue:[AppConfig appCDV] value:@"true"];

    }
    return self;
}

- (NSString *) getRandomStringToAppend {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    NSMutableString *s = [NSMutableString stringWithCapacity:6];
    for (NSUInteger i = 0U; i < 6; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

@end
