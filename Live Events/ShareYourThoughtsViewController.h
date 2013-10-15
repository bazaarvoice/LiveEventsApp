//
//  ShareYourThoughtsViewController.h
//  LiveEvents
//
//  Step 2 - Rate, Set Title, Write Review
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "ProductReview.h"
#import <MessageUI/MessageUI.h>

@interface ShareYourThoughtsViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (strong) ProductReview *productToReview;

// Shared review object context
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
