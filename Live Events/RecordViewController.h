//
//  RecordViewController.h
//  Live Events
//
//  Created by Alex Medearis on 7/30/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductReview.h"

@interface RecordViewController : UIViewController

@property (strong) ProductReview *productToReview;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
