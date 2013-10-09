//
//  ReviewViewController.m
//  Mockup
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "RoundedCornerButton.h"
#import "PublishViewController.h"
#import "AppConfig.h"

#define BOTTOM_SPACE 42
#define KEYBOARD_PORTRAIT 264
#define KEYBOARD_LANDSCAPE 352
#define SCROLL_TO_BOTTOM_PORTRAIT 180
#define SCROLL_TO_BOTTOM_LANSCAPE 490


@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet RoundedCornerButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rateView.notSelectedImage = [UIImage imageNamed:@"A_Star-Empty.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"A_Star-Filled.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.title = @"Share Your Thoughts";
    
    [self.termsButton setTitleColor:[AppConfig secondaryActionColor] forState:UIControlStateNormal];
    
    self.scrollView.bounces = NO;
    
    self.continueButton.borderColor = [AppConfig primaryColor];
    [self.continueButton setTitleColor:[AppConfig primaryColor] forState:UIControlStateNormal];

    self.emailButton.hidden = ![AppConfig emailEnabled];
    
    self.errorLabel.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self positionScrollView:NO orientation:self.interfaceOrientation];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.productLabel.text = self.productToReview.name;
    
    if(self.productToReview.imageUrl && self.productToReview.imageUrl !=(id)[NSNull null]) {
        [self.productImage setImageWithURL:[NSURL URLWithString:self.productToReview.imageUrl]];
    } else {
        self.productImage.image = [UIImage imageNamed:@"noimage.jpeg"];
    }

    [self.productImage setImageWithURL:[NSURL URLWithString:self.productToReview.imageUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)continueClicked:(id)sender {
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
        // Get reference to the destination view controller
        PublishViewController *pubVC = [segue destinationViewController];
        pubVC.productToReview = (ProductReview *)self.productToReview;
        pubVC.managedObjectContext = self.managedObjectContext;
    }
}
- (IBAction)reviewBGClicked:(id)sender {
    [self.reviewTextView becomeFirstResponder];
}

- (IBAction)emailClicked:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Please Review %@", self.productToReview.name]];
        NSString *emailBody = [NSString stringWithFormat:@"<a href=\"%@\">%@</a> <br /><br /> %@", self.productToReview.productPageUrl, self.productToReview.productPageUrl, [AppConfig emailText]];
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(result == MFMailComposeResultSent) {
        NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
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
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

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

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self positionScrollView:self.reviewTextView.isFirstResponder orientation:self.interfaceOrientation];
}


@end
