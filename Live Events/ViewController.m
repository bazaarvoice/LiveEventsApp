//
//  ViewController.m
//  Live Events
//
//  Created by Alex Medearis on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "CategoryCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
@property (weak, nonatomic) IBOutlet UILabel *rateAndReview;
@property (weak, nonatomic) IBOutlet UILabel *informOthers;
@property (weak, nonatomic) IBOutlet CategoryCell *productsView;


@property (strong) NSArray * productsData;
@property (strong) NSTimer * scrollTimer;
@property (assign) BOOL enabled;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.enabled = false;
    self.title = @"Dove";
    [BVSettings instance].baseURL = @"api.bazaarvoice.com";
    [BVSettings instance].passKey = @"70idospb1wubvlbyzixo3elq9";
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    getFresh.search = @"extra fresh";
    getFresh.limit = 100;
    [getFresh addStatsOn:BVIncludeStatsTypeReviews];
    [getFresh sendRequestWithDelegate:self];

    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:nil
                                                       repeats:YES];
}

-(void)enabledValues {
    self.overlayView.alpha = 0;
    self.productsView.alpha = 1.0;
}

-(void)notEnabledValues {
    
}

-(void)animateEnabled:(BOOL)enabled {
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if(enabled){
                             [self enabledValues];
                         } else {
                             [self notEnabledValues];
                         }
                     }
                     completion:^ (BOOL finished){
                         if(finished){
                             self.enabled = enabled;
                         }
                     }];
}

-(void)timerFired:(NSTimer *) theTimer
{
    if(!self.enabled){
        [self.productsView animateToNext];        
    }
}


- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    BVGet *theRequest = (BVGet *)request;
    self.productsData = [response objectForKey:@"Results"];
    self.productsView.dataArray = self.productsData;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.enabled){
        [self animateEnabled:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProductsView:nil];
    [self setOverlayView:nil];
    [self setSeeAllButton:nil];
    [self setRateAndReview:nil];
    [self setInformOthers:nil];
    [super viewDidUnload];
}
@end
