//
//  ProductReview.h
//  Live Events
//
//  Created by Alex Medearis on 8/1/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductReview : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productPageUrl;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * reviewText;
@property (nonatomic, retain) NSString * localVideoPath;
@property (nonatomic, retain) NSString * uploadedVideoUrl;

@end
