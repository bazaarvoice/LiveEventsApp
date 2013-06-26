//
//  GridViewController.h
//  Mockup
//
//  Created by Alex Medearis on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>

@interface GridViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BVDelegate>

@property (strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
