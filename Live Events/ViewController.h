//
//  ViewController.h
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>
#import "BVProductCarousel.h"

@interface ViewController : UIViewController<BVDelegate, SwipeViewDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
