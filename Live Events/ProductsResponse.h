//
//  ProductsResponse.h
//  Live Events
//
//  Created by Alex Medearis on 6/25/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductsResponse : NSManagedObject

@property (nonatomic, retain) NSData * response;

@end
