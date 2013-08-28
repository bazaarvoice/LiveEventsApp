//
//  ManageReviewsViewController.m
//  Live Events
//
//  Created by Alex Medearis on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ManageReviewsViewController.h"

@interface ManageReviewsViewController ()

@end

@implementation ManageReviewsViewController

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
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
