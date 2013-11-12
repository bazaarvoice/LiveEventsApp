//
//  LEDataManager.h
//  Live Events
//
//  Handles review creation, persistence, submission
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductReview.h"
#import <BVSDK/BVSDK.h>

// Identifier for caching initial products
#define INITIAL_SEARCH @"LEDataManagerInitialSearch"

// Identifier for caching product grid products
#define PRODUCT_SEARCH @"LEDataManagerProductSearch"

// Delegate protocol for notifications that a submission has completed
@protocol LEDDataManagerDelegate
-(void)receivedResponse;
@end

@interface LEDataManager : NSObject<BVDelegate>

// Shared object context
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
// Delegate to receive notifications
@property (weak) id<LEDDataManagerDelegate> delegate;

// Singleton context getter
+(id)sharedInstanceWithContext:(NSManagedObjectContext *) managedObjectContext;

// Retrieves cached data (if any) for a particular itentifier
- (NSArray *)getCachedProductsForIdentifier:(NSString *)identifier;
// Sets cached data (if any) for a particular itentifier
- (BOOL)setCachedProducts:(NSArray *)products forIdentifier:(NSString *)identifier;

// Get a clean cacheable product
-(ProductReview *)getNewProductReview;
// Adds the cached product to our queue of products to submit
-(BOOL)addOutstandingObjectToQueue;
// Purges the queue of pending reviews, submits over network
-(void)purgeQueue;
// Returns an array of all cached/pending product reviews
-(NSArray *)getAllProductReviews;

@end
