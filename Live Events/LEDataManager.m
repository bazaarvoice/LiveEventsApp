//
//  LEDataManager.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "LEDataManager.h"

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
    for (ProductReview *info in productsToSend) {
        
    }

}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

@end
