//
//  PublishViewController.m
//  Live Events
//
//  Created by Alex Medearis on 6/24/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "PublishViewController.h"
#import "UIColor+AppColors.h"

@interface PublishViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

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
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)doneClicked:(id)sender {
    BOOL error = NO;
    if(self.nicknameTextField.text.length == 0){
        self.nicknameLabel.textColor = [UIColor BVBrightRed];
        error = YES;
    } else {
        self.nicknameLabel.textColor = [UIColor BVVeryLightGray];
    }
    
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
        self.productToReview.nickname = self.nicknameTextField.text;
        self.productToReview.email = self.emailTextField.text;

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
