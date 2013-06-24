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

@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet RoundedCornerButton *continueButton;

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
    
    self.continueButton.borderColor = [UIColor colorWithRed:50/255.0 green:79/255.0 blue:133/255.0 alpha:1.0];

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
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)continueClicked:(id)sender {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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

-(void)submit {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                    message:@"Your review has been submitted.  Thank you for your feedback."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
