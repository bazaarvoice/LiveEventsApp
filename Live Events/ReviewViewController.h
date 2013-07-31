//
//  ReviewViewController.h
//  Mockup
//
//  Created by Alex Medearis on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "ProductReview.h"

@interface ReviewViewController : UIViewController<UITextFieldDelegate>
@property (strong) ProductReview *productToReview;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


@end
