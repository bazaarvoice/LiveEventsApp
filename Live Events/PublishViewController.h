//
//  PublishViewController.h
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductReview.h"

@interface PublishViewController : UIViewController

@property (strong) ProductReview *productToReview;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
