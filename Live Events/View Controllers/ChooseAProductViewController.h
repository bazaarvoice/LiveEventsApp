//
//  ViewController.h
//  Live Events
//
//  Step 1 - Choose a product from carousel view controller
//
//  Created by Bazaarvoice Engineering on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>
#import "BVProductCarousel.h"

@interface ChooseAProductViewController : UIViewController<BVDelegate, SwipeViewDelegate>

// Shared object context
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
