//
//  LEDataManager.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "LEDataManager.h"
#import "BVProductReviewPost.h"
#import "ProductsResponse.h"

#define CONCURRRENT_REQUESTS 2

@interface LEDataManager()

@property (strong) NSMutableDictionary * outstandingReviews;
@property (strong) ProductReview * outstandingProductReview;
// Semaphore for ensuring only CONCURRENT_REQUESTS requests are outstanding at a time

@property (strong) NSCondition *outstandingCondition;
@property (assign) int outstandingRequests;


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
        self.outstandingCondition = [[NSCondition alloc] init];
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
    // Set as pending
    self.outstandingProductReview.status = @"Pending";
    // Get current time string
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    self.outstandingProductReview.created = [formatter stringFromDate:[NSDate date]];

    BOOL success = [self.managedObjectContext save:&error];
    self.outstandingProductReview = nil;
    return success;
}

-(NSArray *)getAllProductReviews {
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
    return productsToSend;
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
        if([product.status isEqualToString:@"Submitted"]){
            continue;
        }
        
        // Ensure that only CONCURRENT_REQUESTS can be dispatched at a time
        [self.outstandingCondition lock];
        while(self.outstandingRequests >= CONCURRRENT_REQUESTS)
            [self.outstandingCondition wait];
        self.outstandingRequests++;
        [self.outstandingCondition unlock];
        
        BVProductReviewPost *postReview = [[BVProductReviewPost alloc] initWithProductReview:product];
        [postReview sendRequestWithDelegate:self];
    }
    
    // Ensure that we only proceed when no requests are outstanding
    [self.outstandingCondition lock];
    while(self.outstandingRequests > 0)
        [self.outstandingCondition wait];
    [self.outstandingCondition unlock];
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
    // Mark received response
    [self.outstandingCondition lock];
    self.outstandingRequests--;
    [self.outstandingCondition signal];
    [self.outstandingCondition unlock];
    
    BVProductReviewPost * theRequest = (BVProductReviewPost *)request;
    if(![self hasErrors:response]){
        theRequest.productToReview.status = @"Submitted";
        theRequest.productToReview.submissionId = response[@"SubmissionId"];
        // Uncomment to delete on submission
        //[self.managedObjectContext deleteObject:theRequest.productToReview];
    } else {
        theRequest.productToReview.status = [self getErrorFromResponse:response];
    }
    NSError *error;
    [self.managedObjectContext save:&error];
    
    if(self.delegate) {
        [self.delegate receivedResponse];
    }
}

- (NSString *)getErrorFromResponse:(NSDictionary *)response {
    NSString * errorMessage;
    NSDictionary *errors = [response objectForKey:@"Errors"];
    NSDictionary *formErrors = [response objectForKey:@"FormErrors"];
    if(errors && errors.count > 0)
    {
        NSDictionary * anError = [[response objectForKey:@"Errors"] objectAtIndex:0];
        errorMessage = [anError objectForKey:@"Message"];
    }
    else if(formErrors && formErrors.count > 0)
    {
        NSDictionary * fieldErrors = [[formErrors allValues] objectAtIndex:0];
        if(fieldErrors.count > 0)
        {
            NSDictionary * anError = [[fieldErrors allValues] objectAtIndex:0];
            errorMessage = [anError objectForKey:@"Message"];
        } else {
            errorMessage = @"An Error Occurred";
        }
    }
    else
    {
        errorMessage = @"An Error Occurred";
    }
    return errorMessage;
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request {
    // Mark received response
    [self.outstandingCondition lock];
    self.outstandingRequests--;
    [self.outstandingCondition unlock];
    
    BVProductReviewPost * theRequest = (BVProductReviewPost *)request;
    theRequest.productToReview.status = @"Network Error";
    NSError *error;
    [self.managedObjectContext save:&error];
    
    
    if(self.delegate) {
        [self.delegate receivedResponse];
    }
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
