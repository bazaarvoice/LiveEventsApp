//
//  ViewController.h
//  Live Events
//
//  Created by Alex Medearis on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>
#import "CategoryCell.h"

@interface ViewController : UIViewController<BVDelegate>

@property (weak, nonatomic) IBOutlet CategoryCell *productsView;

@end
