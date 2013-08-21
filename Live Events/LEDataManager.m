//
//  LEDataManager.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "LEDataManager.h"
#import "BVProductReviewPost.h"
#import "ProductsResponse.h"

@interface LEDataManager()

@property (strong) NSMutableDictionary * outstandingReviews;
@property (strong) ProductReview * outstandingProductReview;

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
        self.outstandingProductReview = nil;
    }
    return self;
}

- (ProductReview *)getNewProductReview {
    // If we have a product outstanding, but try to create a new one, discard the old one
    if(self.outstandingProductReview != nil){
        NSError *error;
        [self.managedObjectContext deleteObject:self.outstandingProductReview];
        [self.managedObjectContext save:&error];
    }
    
    ProductReview * productReview = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"ProductReview"
                                     inManagedObjectContext:self.managedObjectContext];
    self.outstandingProductReview = productReview;
    return productReview;
}


-(BOOL)addOutstandingObjectToQueue {
    // Make sure that the object is saved, allow creation of new objects
    NSError *error;
    BOOL success = [self.managedObjectContext save:&error];
    self.outstandingProductReview = nil;
    return success;
}

-(void)purgeQueue {
    // If we have a product outstanding, but try to purge the queue before saving, delete the outstanding product review
    NSError *error;
    if(self.outstandingProductReview != nil){
        [self.managedObjectContext deleteObject:self.outstandingProductReview];
        [self.managedObjectContext save:&error];
    }
    
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

- (NSArray *)getCachedProductsForTerm:(NSString *)term{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProductsResponse"
        inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *response = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    ProductsResponse * productResponse;
    for(ProductsResponse * currProductResponse in response){
        if([currProductResponse.term isEqualToString:term]){
            productResponse = currProductResponse;
        }
    }
    
    if(!productResponse){
        // If it doesn't exist yet, just return nil
        return nil;
    } else {
        // Otherwise, return the response as an array -- it is stored as data in the ProductResponse, so we need to convert it
        ProductsResponse * productResponse = response[0];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:productResponse.response];
        NSArray *cachedResponse = [unarchiver decodeObjectForKey:@"response"];
        [unarchiver finishDecoding];
        return cachedResponse;
    }
}


- (BOOL)setCachedProducts:(NSArray *)products forTerm:(NSString *)term {
    // Look up the existing ProductResponse
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProductsResponse"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *response = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    ProductsResponse * productResponse;
    for(ProductsResponse * currProductResponse in response){
        if([currProductResponse.term isEqualToString:term]){
            productResponse = currProductResponse;
        }
    }
    
    if(!productResponse){
        // If it doesn't exist, create a new one
        productResponse = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"ProductsResponse"
                                         inManagedObjectContext:self.managedObjectContext];
    }
    
    // Set term
    productResponse.term = term;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:products forKey:@"response"];
    [archiver finishEncoding];
    productResponse.response = data;
    
    return [self.managedObjectContext save:&error];
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
