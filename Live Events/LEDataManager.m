//
//  LEDataManager.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "LEDataManager.h"
#import "BVProductReviewPost.h"

@interface LEDataManager()

@property (strong) NSMutableDictionary * outstandingReviews;

@end

@implementation LEDataManager

+(id)sharedInstanceWithContext:(NSManagedObjectContext *) managedObjectContext;
{
    static dispatch_once_t pred;
    static LEDataManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[LEDataManager alloc] init];
        sharedInstance.managedObjectContext = managedObjectContext;
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        self.outstandingReviews = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(BOOL)addToQueue:(ProductReview *)productReview {
    NSError *error;
    return [self.managedObjectContext save:&error];    
}

-(void)purgeQueue {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProductReview"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *productsToSend = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (ProductReview *product in productsToSend) {
        BVProductReviewPost *postReview = [[BVProductReviewPost alloc] initWithProductReview:product];
        [postReview sendRequestWithDelegate:self];
    }
}

- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    
    BVProductReviewPost * theRequest = (BVProductReviewPost *)request;
    if(![self hasErrors:response]){
        [self.managedObjectContext deleteObject:theRequest.productToReview];
    }
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request {
    
}

- (BOOL) hasErrors:(NSDictionary *)response {
    BOOL hasErrors = [[response objectForKey:@"HasErrors"] boolValue] || ([response objectForKey:@"HasErrors"] == nil);
    return hasErrors;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

@end
