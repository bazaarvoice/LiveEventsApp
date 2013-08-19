//
//  ViewController.m
//  Live Events
//
//  Created by Alex Medearis on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "CategoryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FadeLabel.h"
#import "BorderedBar.h"
#import "ProductReview.h"
#import "ReviewViewController.h"
#import "LEDataManager.h"
#import "UIColor+AppColors.h"
#import "GridViewController.h"

#define SLIDE_INTERVAL 3.0
#define IDLE_INTERVAL 6.0

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
@property (weak, nonatomic) IBOutlet FadeLabel *informOthers;
@property (weak, nonatomic) IBOutlet FadeLabel *rateAndReview;
@property (weak, nonatomic) IBOutlet CategoryCell *productsView;
@property (weak, nonatomic) IBOutlet BorderedBar *bottomBar;

@property (assign) int idleCount;

@property (strong) NSArray * productsData;
@property (strong) NSTimer * scrollTimer;
@property (assign) BOOL enabled;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Dove";
    [BVSettings instance].baseURL = @"dove.ugc.bazaarvoice.com";
    [BVSettings instance].staging = false;

    [BVSettings instance].passKey = [BVSettings instance].staging ? @"a7mcnqr7i1a9ahgg48lknq351" : @"opcgjwnks8z2roz2gm721615h";
    

    
    self.productsData = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProducts];
    self.productsView.dataArray = self.productsData;
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    getFresh.search = @"extra fresh";
    getFresh.limit = 100;
    [getFresh addStatsOn:BVIncludeStatsTypeReviews];
    [getFresh sendRequestWithDelegate:self];

    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:SLIDE_INTERVAL
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:nil
                                                       repeats:YES];

    self.rateAndReview.secondaryColor = [UIColor BVBrightBlue];
    self.informOthers.secondaryColor = [UIColor BVBrightBlue];
    
    self.productsView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.enabled = true;
    [self enabledValues];
}

-(void)enabledValues {
    self.idleCount = 0;
    self.overlayView.alpha = 0;
    self.productsView.alpha = 1.0;
    [self.informOthers showSecondaryColor:YES];
    [self.rateAndReview showSecondaryColor:YES];
    self.bottomBar.alpha = 1;
    self.seeAllButton.alpha = 1;
}

-(void)notEnabledValues {
    self.overlayView.alpha = 1.0;
    self.productsView.alpha = 0.5;
    [self.informOthers showSecondaryColor:NO];
    [self.rateAndReview showSecondaryColor:NO];
    self.bottomBar.alpha = 0;
    self.seeAllButton.alpha = 0;
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
    if(self.enabled){
        self.idleCount++;
        if(self.idleCount > (IDLE_INTERVAL / SLIDE_INTERVAL)) {
            [self animateEnabled:NO];
        }
    } else if([self.navigationController visibleViewController] == self) {
        // Animate to next if this is the VC in the foreground
        [self.productsView animateToNext];
    }
}


- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    NSArray *results = [response objectForKey:@"Results"];
    [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] setCachedProducts:results];
    self.productsData = results;
    self.productsView.dataArray = self.productsData;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.enabled && self.productsData.count > 0){
        [self animateEnabled:YES];
    }
    self.idleCount = 0;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView {
    self.idleCount = 0;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    self.idleCount = 0;
    NSDictionary * selectedProduct = self.productsData[index];
    ProductReview * productReview = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getNewProductReview];
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"];
    productReview.productId = selectedProduct[@"Id"];
    productReview.productPageUrl = selectedProduct[@"ProductPageUrl"];
    [self performSegueWithIdentifier:@"rate" sender:productReview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"rate"])
    {
        // Get reference to the destination view controller
        ReviewViewController *rateVC = [segue destinationViewController];
        rateVC.productToReview = (ProductReview *)sender;
        rateVC.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"seeall"]){
        GridViewController *gridView = [segue destinationViewController];
        gridView.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)seeAllClicked:(id)sender {
    [self performSegueWithIdentifier:@"seeall" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload {
    [self setProductsView:nil];
    [self setOverlayView:nil];
    [self setSeeAllButton:nil];
    [self setRateAndReview:nil];
    [self setInformOthers:nil];
    [self setInformOthers:nil];
    [self setRateAndReview:nil];
    [self setBottomBar:nil];
    [super viewDidUnload];
}
@end
