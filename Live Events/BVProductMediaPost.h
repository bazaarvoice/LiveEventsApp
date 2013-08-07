//
//  BVProductMediaPost.h
//  Live Events
//
//  Created by Alex Medearis on 8/6/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <BVSDK/BVSDK.h>
#import "ProductReview.h"

@interface BVProductMediaPost : BVMediaPost


@property (strong) ProductReview *productToPost;

-(id)initWithProductToPost:(ProductReview *)productToPost;

@end
