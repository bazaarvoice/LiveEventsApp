//
//  LEDataManager.h
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductReview.h"

@interface LEDataManager : NSObject

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

+(id)sharedInstanceWithContext:(NSManagedObjectContext *) managedObjectContext;

@end
