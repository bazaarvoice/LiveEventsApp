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
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
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
    self.doneButton.borderColor = [AppConfig primaryColor];
    [self.doneButton setTitleColor:[AppConfig primaryColor] forState:UIControlStateNormal];
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

- (IBAction)nicknameBGClicked:(id)sender {
    [self.nicknameTextField becomeFirstResponder];
}

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


- (IBAction)doneClicked:(id)sender {
    [self doValidation];
}

- (void)doValidation {
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
