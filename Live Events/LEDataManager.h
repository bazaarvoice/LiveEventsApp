//
//  LEDataManager.h
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductReview.h"
#import <BVSDK/BVSDK.h>

#define INITIAL_SEARCH @"LEDataManagerInitialSearch"
#define PRODUCT_SEARCH @"LEDataManagerProductSearch"

@interface LEDataManager : NSObject<BVDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

+(id)sharedInstanceWithContext:(NSManagedObjectContext *) managedObjectContext;

- (NSArray *)getCachedProductsForTerm:(NSString *)term;
- (BOOL)setCachedProducts:(NSArray *)products forTerm:(NSString *)term;

-(ProductReview *)getNewProductReview;
-(BOOL)addOutstandingObjectToQueue;
-(void)purgeQueue;

@end
