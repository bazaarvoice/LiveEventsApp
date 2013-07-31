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

#define BOTTOM_SPACE 50
#define KEYBOARD_PORTRAIT 264
#define KEYBOARD_LANDSCAPE 352
#define SCROLL_TO_BOTTOM_PORTRAIT 180
#define SCROLL_TO_BOTTOM_LANSCAPE 450


@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet RoundedCornerButton *continueButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

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
    
    self.continueButton.borderColor = [UIColor BVDarkBlue];
    
    self.errorLabel.alpha = 0;
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
    
    if(self.nicknameTextField.text.length == 0) {
        self.nicknameLabel.textColor = [UIColor BVBrightRed];
        error = YES;
    } else {
        self.nicknameLabel.textColor = [UIColor BVVeryLightGray];
    }
    
    if(!error){
        self.errorLabel.alpha = 0;
        self.productToReview.rating = [NSNumber numberWithFloat:self.rateView.rating];
        self.productToReview.nickname = self.nicknameTextField.text;
        [self performSegueWithIdentifier:@"record" sender:nil];
    } else {
        self.errorLabel.alpha = 1;
    }
}


- (IBAction)nicknameBGClicked:(id)sender {
    [self.nicknameTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
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
    [self positionScrollView:self.nicknameTextField.isFirstResponder orientation:self.interfaceOrientation];
}


@end
