//
//  ManageReviewsViewController.h
//  Live Events
//
//  Created by Alex Medearis on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSpreadViewClasses.h"

@interface ManageReviewsViewController : UIViewController<MDSpreadViewDelegate, MDSpreadViewDataSource>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
