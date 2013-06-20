//
//  ProductReview.h
//  Live Events
//
//  Created by Alex Medearis on 6/20/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductReview : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * reviewText;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * imageUrl;

@end
