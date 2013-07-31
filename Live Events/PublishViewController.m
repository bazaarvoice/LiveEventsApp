//
//  PublishViewController.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "PublishViewController.h"
#import "UIColor+AppColors.h"
#import "LEDataManager.h"
#import "RoundedCornerButton.h"

@interface PublishViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet RoundedCornerButton *doneButton;

@end

@implementation PublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;

}

- (void)setup {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.alpha = 0;
    self.doneButton.borderColor = [UIColor BVDarkBlue];
}

- (IBAction)shareYourThoughtsClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)emailBGClicked:(id)sender {
    [self.emailTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailTextField){
        [textField resignFirstResponder];
        [self doValidation];
    }
    return NO;
}


- (IBAction)doneClicked:(id)sender {
    [self doValidation];
}

- (void)doValidation {
    BOOL error = NO;
    
    if(![self validateEmailWithString:self.emailTextField.text]){
        self.emailLabel.textColor = [UIColor BVBrightRed];
        error = YES;
    } else {
        self.emailLabel.textColor = [UIColor BVVeryLightGray];
    }
    
    if(error) {
        self.errorLabel.alpha = 1;
        return;
    } else {
        self.productToReview.email = self.emailTextField.text;
        [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] addOutstandingObjectToQueue];
        [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] purgeQueue];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                          message:@"Your review has been submitted. Thank you for your feedback."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
