//
//  ProductsResponse.h
//  Live Events
//
//  Created by Bazaarvoice Engineering on 8/21/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductsResponse : NSManagedObject

@property (nonatomic, retain) NSData * response;
@property (nonatomic, retain) NSString * term;

@end
