//
//  ViewController.m
//  Live Events
//
//  Created by Alex Medearis on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) NSArray * productsData;
@property (strong) NSTimer * scrollTimer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

-(void)timerFired:(NSTimer *) theTimer
{
    [self.productsView animateToNext];
}


- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    BVGet *theRequest = (BVGet *)request;
    self.productsData = [response objectForKey:@"Results"];
    self.productsView.dataArray = self.productsData;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProductsView:nil];
    [super viewDidUnload];
}
@end
