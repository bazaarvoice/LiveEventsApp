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

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define INITIAL_OFFSET 42
#define KEYBOARD_HEIGHT 352

@interface PublishViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *videoFrame;
@property (weak, nonatomic) IBOutlet RoundedCornerButton *doneButton;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *videoController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPosition;


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
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadVideoPlayer];
}

- (void)loadVideoPlayer {
    NSURL *url = [NSURL URLWithString:self.productToReview.localVideoPath];
    ALAssetsLibrary *myAssetLib=[[ALAssetsLibrary alloc] init];
    
    [myAssetLib assetForURL:url
                resultBlock:^(ALAsset *asset) {
                    NSURL * url = [[asset defaultRepresentation]url];
                    NSLog(@"%@", url);
                    self.videoController = [[MPMoviePlayerController alloc] initWithContentURL:[[asset defaultRepresentation]url]];
                    [self.videoController prepareToPlay];
                    [self.videoController.view setFrame: CGRectMake(0, 0, 480, 320)];
                    [self.videoFrame addSubview: self.videoController.view];
                }
                failureBlock:^(NSError *error){NSLog(@"test:Fail");}];
}



- (IBAction)shareYourThoughtsClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)prepClicked:(id)sender {
    [self.navigationController popToViewController:(UIViewController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
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

- (void) keyboardWillShowHandler:(NSNotification *)notification {
    [self positionScrollView:YES orientation:self.interfaceOrientation];
}

- (void) keyboardWillHideHandler:(NSNotification *)notification {
    [self positionScrollView:NO orientation:self.interfaceOrientation];
}

-(void) positionScrollView:(BOOL)up orientation:(UIInterfaceOrientation)orientation {
    if(up) {
        // Move scrollview up
        self.topPosition.constant = INITIAL_OFFSET - KEYBOARD_HEIGHT;
    } else {
        self.topPosition.constant = INITIAL_OFFSET;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
