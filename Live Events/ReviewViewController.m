//
//  ReviewViewController.m
//  Mockup
//
//  Created by Alex Medearis on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ReviewViewController.h"
#import "UIImageView+WebCache.h"

@interface ReviewViewController ()

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
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    self.title = @"Write a Review";

}

- (void)viewWillAppear:(BOOL)animated{
    //self.productLabel.text = self.productToReview[@"Name"];
    //[self.productImage setImageWithURL:self.productToReview[@"ImageUrl"]];
    //self.rateView.rating = [self.productToReview[@"myRating"] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
