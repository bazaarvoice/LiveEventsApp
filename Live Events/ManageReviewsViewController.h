//
//  ManageReviewsViewController.h
//  Live Events
//
//  Created by Bazaarvoice Engineering on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSpreadViewClasses.h"
#import "LEDataManager.h"

@interface ManageReviewsViewController : UIViewController<MDSpreadViewDelegate, MDSpreadViewDataSource, LEDDataManagerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
