//
//  ChooseAProductGridViewController.h
//  Live Events
//
//  Step 1 - Allows the user to select a product from a searchable grid of products
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>

@interface ChooseAProductGridViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BVDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
