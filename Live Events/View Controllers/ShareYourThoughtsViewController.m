//
//  ShareYourThoughtsViewController.m
//  LiveEvents
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ShareYourThoughtsViewController.h"
#import "UIImageView+WebCache.h"
#import "RoundedCornerButton.h"
#import "PublishViewController.h"
#import "AppConfig.h"

#define BOTTOM_SPACE 42
#define KEYBOARD_PORTRAIT 264
#define KEYBOARD_LANDSCAPE 352
#define SCROLL_TO_BOTTOM_PORTRAIT 180
#define SCROLL_TO_BOTTOM_LANSCAPE 490


@interface ShareYourThoughtsViewController ()

// Image of product
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
// Name of product
@property (weak, nonatomic) IBOutlet UILabel *productLabel;

// Scroll view containing form
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// Review later by email button
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

// Label indicating an error occurred
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

// Rating field
@property (weak, nonatomic) IBOutlet RateView *rateView;
// Rating label
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

// Title field
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
// Title label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Review field
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
// Review label
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

// Display terms and conditions button
@property (weak, nonatomic) IBOutlet UIButton *termsButton;

// Continue to next page button
@property (weak, nonatomic) IBOutlet RoundedCornerButton *continueButton;

// Manages the scrollview height so that it can be moved up when the keyboard is displayed
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@end

@implementation ShareYourThoughtsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Share Your Thoughts";
    
	// Set up the rating field
    self.rateView.notSelectedImage = [UIImage imageNamed:@"A_Star-Empty.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"A_Star-Filled.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    
    [self.termsButton setTitleColor:[AppConfig secondaryActionColor] forState:UIControlStateNormal];

    self.scrollView.bounces = NO;
    
    self.continueButton.borderColor = [AppConfig primaryColor];
    [self.continueButton setTitleColor:[AppConfig primaryColor] forState:UIControlStateNormal];

    self.emailButton.hidden = ![AppConfig emailEnabled];
    
    self.errorLabel.alpha = 0;

    
    self.productLabel.text = self.productToReview.name;
    if(self.productToReview.imageUrl && self.productToReview.imageUrl !=(id)[NSNull null]) {
        [self.productImage setImageWithURL:[NSURL URLWithString:self.productToReview.imageUrl] placeholderImage:[UIImage imageNamed:@"noimage.jpeg"]];
    } else {
        self.productImage.image = [UIImage imageNamed:@"noimage.jpeg"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    // Receive keyboard notification events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    // Scroll to top of form
    [self positionScrollView:NO orientation:self.interfaceOrientation];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

// Bottom bar actions
- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Cancel handler
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// If continue is clicked, perform validation.
- (IBAction)continueClicked:(id)sender {
    [self validate];
}

// If valid, move on, otherwise, highlight the offending field.
- (void)validate {
    
    BOOL error = NO;
    if(self.rateView.rating == 0) {
        self.rateLabel.textColor = [AppConfig errorColor];
        error = YES;
    } else {
        self.rateLabel.textColor = [AppConfig secondaryActionColor];
        
        
    }
    
    if(self.titleTextField.text.length == 0) {
        self.titleLabel.textColor = [AppConfig errorColor];
        error = YES;
    } else {
        self.titleLabel.textColor = [AppConfig secondaryActionColor];
    }
    
    if(self.reviewTextView.text.length == 0 || [self.reviewTextView.text isEqualToString:@"Tell Us What You Think"]) {
        self.reviewLabel.textColor = [AppConfig errorColor];
        error = YES;
    } else {
        self.reviewLabel.textColor = [AppConfig secondaryActionColor];
    }
    
    if(!error){
        self.errorLabel.alpha = 0;
        self.productToReview.rating = [NSNumber numberWithFloat:self.rateView.rating];
        self.productToReview.title = self.titleTextField.text;
        self.productToReview.reviewText = self.reviewTextView.text;
        [self performSegueWithIdentifier:@"publish" sender:nil];
    } else {
        self.errorLabel.alpha = 1;
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"publish"])
    {
        // Get reference to the destination view controller, pass on the product context
        PublishViewController *pubVC = [segue destinationViewController];
        pubVC.productToReview = (ProductReview *)self.productToReview;
        pubVC.managedObjectContext = self.managedObjectContext;
    }
}

// Sets focus to the title field, even if they didn't exactly click it
- (IBAction)titleBGClicked:(id)sender {
    [self.titleTextField becomeFirstResponder];
}

// Sets focus to the review field, even if they didn't exactly click it
- (IBAction)reviewBGClicked:(id)sender {
    [self.reviewTextView becomeFirstResponder];
}

// If supported, display the email compose view with the configured text and a link to the product
- (IBAction)emailClicked:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Please Review %@", self.productToReview.name]];
        NSString *emailBody = [NSString stringWithFormat:@"This is the reminder you requested to write a review. Click on the link below to submit your review: <br /><a href=\"%@\">%@</a> <br /><br />Thank you for your sharing your thoughts with us.", self.productToReview.productPageUrl, self.productToReview.productPageUrl];
        [mailer setMessageBody:emailBody isHTML:YES];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please double check that you have configured an email account and try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

// Handler for mail compose dismissal
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(result == MFMailComposeResultSent) {
        UIAlertView * submitted = [[UIAlertView alloc] initWithTitle:@"Sent!" message:@"Thanks!  You should receive an email shortly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [submitted show];
    } else if (result == MFMailComposeResultFailed) {
        UIAlertView * error = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Something went wrong.  Please double check your email configuration and try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) keyboardWillHideHandler:(NSNotification *)notification {
    [self positionScrollView:NO orientation:self.interfaceOrientation];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self positionScrollView:YES orientation:self.interfaceOrientation];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self positionScrollView:YES orientation:self.interfaceOrientation];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL shouldChange = YES;
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        shouldChange = NO;
        if(textView == self.reviewTextView) {
            [self validate];
        }
    }
    

    return shouldChange;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if(textField == self.titleTextField) {
        [self.reviewTextView becomeFirstResponder];
    }
    return YES;
}

// Manipulates the bottom of the scrollview based on whether the keyboard is visible and the current orientation
-(void) positionScrollView:(BOOL)up orientation:(UIInterfaceOrientation)orientation {
    float offset;
    if(up) {
        // Move scrollview up
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            self.bottomSpaceConstraint.constant = KEYBOARD_LANDSCAPE;
            offset = SCROLL_TO_BOTTOM_LANSCAPE;
        } else {
            self.bottomSpaceConstraint.constant = KEYBOARD_PORTRAIT;
            offset = SCROLL_TO_BOTTOM_PORTRAIT;
        }
    } else {
        self.bottomSpaceConstraint.constant = BOTTOM_SPACE;
        offset = 0;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.scrollView.contentOffset = CGPointMake(0, offset);
                     }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self positionScrollView:self.reviewTextView.isFirstResponder orientation:self.interfaceOrientation];
}


@end
