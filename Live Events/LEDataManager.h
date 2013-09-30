//
//  LEDataManager.h
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductReview.h"
#import <BVSDK/BVSDK.h>

#define INITIAL_SEARCH @"LEDataManagerInitialSearch"
#define PRODUCT_SEARCH @"LEDataManagerProductSearch"

@protocol LEDDataManagerDelegate
-(void)receivedResponse;
@end

@interface LEDataManager : NSObject<BVDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (weak) id<LEDDataManagerDelegate> delegate;

+(id)sharedInstanceWithContext:(NSManagedObjectContext *) managedObjectContext;

- (NSArray *)getCachedProductsForTerm:(NSString *)term;
- (BOOL)setCachedProducts:(NSArray *)products forTerm:(NSString *)term;

-(ProductReview *)getNewProductReview;
-(BOOL)addOutstandingObjectToQueue;
-(void)purgeQueue;
-(NSArray *)getAllProductReviews;

@end
