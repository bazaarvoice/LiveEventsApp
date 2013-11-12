//
//  PublishViewController.h
//  Live Events
//
//  Step 3 - Set nickname, email and submit
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductReview.h"

@interface PublishViewController : UIViewController

@property (strong) ProductReview *productToReview;

// Shared object context
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
