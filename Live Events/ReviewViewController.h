//
//  ReviewViewController.h
//  Mockup
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "ProductReview.h"
#import <MessageUI/MessageUI.h>

@interface ReviewViewController : UIViewController<UITextViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@property (strong) ProductReview *productToReview;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


@end
