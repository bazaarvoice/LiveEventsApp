//
//  ManageReviewsViewController.h
//  Live Events
//
//  Allows client to manage submitted/cached reviews and submit as a batch.
//
//  Created by Bazaarvoice Engineering on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSpreadViewClasses.h"
#import "LEDataManager.h"

@interface ManageReviewsViewController : UIViewController<MDSpreadViewDelegate, MDSpreadViewDataSource, LEDDataManagerDelegate>

// Shared object context
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
