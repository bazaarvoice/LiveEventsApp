//
//  PublishViewController.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "PublishViewController.h"
#import "LEDataManager.h"
#import "RoundedCornerButton.h"
#import "AppConfig.h"

@interface PublishViewController ()
// Nickname text field
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
// Nickname text field label
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
// Email text field
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
// Email text field label
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
// Label indicating an error occurred
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
// Done button
@property (weak, nonatomic) IBOutlet RoundedCornerButton *doneButton;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Publish";
    self.errorLabel.alpha = 0;
    self.doneButton.borderColor = [AppConfig primaryColor];
    [self.doneButton setTitleColor:[AppConfig primaryColor] forState:UIControlStateNormal];
}

// Bottom bar actions
- (IBAction)shareYourThoughtsClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Sets focus to the email field, even if they didn't exactly click it
- (IBAction)emailBGClicked:(id)sender {
    [self.emailTextField becomeFirstResponder];
}

// Sets focus to the nickname field, even if they didn't exactly click it
- (IBAction)nicknameBGClicked:(id)sender {
    [self.nicknameTextField becomeFirstResponder];
}

// Next/done button should move forward in the form or submit if possible
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.nicknameTextField){
        [textField resignFirstResponder];
        [self.emailTextField becomeFirstResponder];
    } else if(textField == self.emailTextField){
        [textField resignFirstResponder];
        [self doValidation];
    }
    return NO;
}

// If the user clicks done, attempt to submit
- (IBAction)doneClicked:(id)sender {
    [self doValidation];
}

- (void)doValidation {
    // Validates form fields, makes red if a field fails validation, otherwise, adds review to outstanding queue
    BOOL error = NO;
    if(self.nicknameTextField.text.length == 0){
        self.nicknameLabel.textColor = [AppConfig errorColor];
        error = YES;
    } else {
        self.nicknameLabel.textColor = [AppConfig secondaryActionColor];
    }
    
    if(![self validateEmailWithString:self.emailTextField.text]){
        self.emailLabel.textColor = [AppConfig errorColor];
        error = YES;
    } else {
        self.emailLabel.textColor = [AppConfig secondaryActionColor];
    }
    
    if(error) {
        self.errorLabel.alpha = 1;
        return;
    } else {
        self.productToReview.nickname = self.nicknameTextField.text;
        self.productToReview.email = self.emailTextField.text;
        [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] addOutstandingObjectToQueue];
        // Don't purge here anymore...
        //[[LEDataManager sharedInstanceWithContext:self.managedObjectContext] purgeQueue];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                          message:@"Your review has been submitted. Thank you for your feedback."
                                                         delegate:nil
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

@end
