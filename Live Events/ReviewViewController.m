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
    
    self.continueButton.borderColor = [UIColor BVDarkBlue];
    
    self.errorLabel.alpha = 0;
    
    self.emailDone.borderColor = [UIColor BVDarkBlue];
    self.emailView.hidden = YES;
    self.emailLink.text = self.productToReview.productPageUrl;
}

- (void)viewWillAppear:(BOOL)animated{
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

- (IBAction)emailClicked:(id)sender {
    self.emailField.text = @"";
    self.emailView.hidden = NO;
}
- (IBAction)emailCancelClicked:(id)sender {
    self.emailView.hidden = YES;
}
- (IBAction)emailDoneClicked:(id)sender {
    self.emailView.hidden = YES;
    UIAlertView * submitted = [[UIAlertView alloc] initWithTitle:@"Email Sent!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [submitted show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Tell Us What You Think"]){
        textView.text = @"";
    }
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
