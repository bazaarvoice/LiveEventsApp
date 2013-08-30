//
//  ReviewViewController.m
//  Mockup
//
//  Created by Alex Medearis on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "RoundedCornerButton.h"
#import "PublishViewController.h"
#import "UIColor+AppColors.h"

#define BOTTOM_SPACE 42
#define KEYBOARD_PORTRAIT 264
#define KEYBOARD_LANDSCAPE 352
#define SCROLL_TO_BOTTOM_PORTRAIT 180
#define SCROLL_TO_BOTTOM_LANSCAPE 450


@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet RoundedCornerButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UITextField *reviewTextView;

@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet RoundedCornerButton *emailDone;
@property (weak, nonatomic) IBOutlet RoundedCornerButton *emailCancel;
@property (weak, nonatomic) IBOutlet UILabel *emailLink;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
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
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.rateView.notSelectedImage = [UIImage imageNamed:@"A_Star-Empty.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"A_Star-Filled.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.title = @"Write a Review";
    
    self.scrollView.bounces = NO;
    
    self.continueButton.borderColor = [UIColor BVBrightBlue];
    
    self.errorLabel.alpha = 0;
    
    self.emailDone.borderColor = [UIColor BVBrightBlue];
    self.emailView.hidden = YES;
    self.emailLink.text = self.productToReview.productPageUrl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self positionScrollView:NO orientation:self.interfaceOrientation];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.productLabel.text = self.productToReview.name;
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
        self.rateLabel.textColor = [UIColor BVBrightRed];
        error = YES;
    } else {
        self.rateLabel.textColor = [UIColor BVVeryLightGray];
    }
    
    if(self.reviewTextView.text.length == 0 || [self.reviewTextView.text isEqualToString:@"Tell Us What You Think"]) {
        self.reviewLabel.textColor = [UIColor BVBrightRed];
        error = YES;
    } else {
        self.reviewLabel.textColor = [UIColor BVVeryLightGray];
    }
    
    if(!error){
        self.errorLabel.alpha = 0;
        self.productToReview.rating = [NSNumber numberWithFloat:self.rateView.rating];
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
    self.emailField.text = @"";
    self.emailView.hidden = NO;
}
- (IBAction)emailCancelClicked:(id)sender {
    [self.emailField resignFirstResponder];
    self.emailView.hidden = YES;
}
- (IBAction)emailDoneClicked:(id)sender {
    self.emailView.hidden = YES;
    UIAlertView * submitted = [[UIAlertView alloc] initWithTitle:@"Email Sent!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [submitted show];
}


- (void) keyboardWillHideHandler:(NSNotification *)notification {
    [self positionScrollView:NO orientation:self.interfaceOrientation];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self positionScrollView:YES orientation:self.interfaceOrientation];
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
