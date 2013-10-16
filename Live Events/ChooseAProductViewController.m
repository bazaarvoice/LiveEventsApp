//
//  ViewController.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/14/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ChooseAProductViewController.h"
#import "BVProductCarousel.h"
#import <QuartzCore/QuartzCore.h>
#import "FadeLabel.h"
#import "BorderedBar.h"
#import "ProductReview.h"
#import "ShareYourThoughtsViewController.h"
#import "LEDataManager.h"
#import "ChooseAProductGridViewController.h"
#import "AppConfig.h"

#define SLIDE_INTERVAL 3.0
#define IDLE_INTERVAL 6.0

@interface ChooseAProductViewController ()

// Overlay containing the "Start" bar
@property (weak, nonatomic) IBOutlet UIView *overlayView;
// Start bar
@property (weak, nonatomic) IBOutlet UIView *startBar;
// "See all X products" button
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
// Large guidance label
@property (weak, nonatomic) IBOutlet FadeLabel *rateAndReview;
// "Inform others" guidance label
@property (weak, nonatomic) IBOutlet FadeLabel *informOthers;
// Carousel of products to display
@property (weak, nonatomic) IBOutlet BVProductCarousel *productsView;
// Bottom bar
@property (weak, nonatomic) IBOutlet BorderedBar *bottomBar;

// Counts the number of times we've received a callback so that we know when to fade to screensaver mode
@property (assign) int idleCount;
// Timer to create screensaver callbacks
@property (strong) NSTimer * scrollTimer;

// Products to display
@property (strong) NSArray * productsData;
// Mode -- screensaver or enabled
@property (assign) BOOL enabled;

@end

@implementation ChooseAProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Choose a Product";
    
    // Global appearance
    self.navigationController.navigationBar.tintColor = [AppConfig primaryColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil];
    
    // Configure global API key and endpoint to use for requests
    [BVSettings instance].baseURL = [AppConfig apiEndpoint];
    [BVSettings instance].passKey = [AppConfig apiKey];
    
    // Load cached products data if possible
    self.productsData = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProductsForIdentifier:INITIAL_SEARCH];
    self.productsView.dataArray = self.productsData;
    
    // Fetch products over network
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    if([AppConfig initialProducts].length > 0) {
        [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:[AppConfig initialProducts]];        
    }
    if([AppConfig initialCategory].length > 0) {
        [getFresh setFilterForAttribute:@"CategoryId" equality:BVEqualityEqualTo value:[AppConfig initialCategory]];
    }
    getFresh.limit = 100;
    [getFresh addStatsOn:BVIncludeStatsTypeReviews];
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];

    // Setup scroll timer (each time this fires, the carousel scrolls 1 over if in screensaver mode)
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:SLIDE_INTERVAL
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:nil
                                                       repeats:YES];

    // Set up initial colors
    self.rateAndReview.secondaryColor = [AppConfig primaryColor];
    self.informOthers.secondaryColor = [AppConfig primaryColor];
    self.startBar.backgroundColor = [AppConfig primaryColor];
    
    // Receive callbacks from carousel
    self.productsView.delegate = self;
    
    [self.seeAllButton setTitle:[NSString stringWithFormat:@"See all %@ products >", [AppConfig brandName]] forState:UIControlStateNormal];
}

- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    NSArray *results = [response objectForKey:@"Results"];
    // Write results to disk cache with identifier INITIAL_SEARCH
    [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] setCachedProducts:results forIdentifier:INITIAL_SEARCH];
    self.productsData = results;
    self.productsView.dataArray = self.productsData;
}

- (void)viewWillAppear:(BOOL)animated {
    self.enabled = true;
    [self enabledValues];
}

// Sets appearance to "enabled"
-(void)enabledValues {
    self.idleCount = 0;
    self.overlayView.alpha = 0;
    self.productsView.alpha = 1.0;
    [self.informOthers showSecondaryColor:YES];
    [self.rateAndReview showSecondaryColor:YES];
    self.bottomBar.alpha = 1;
    self.seeAllButton.alpha = 1;
}

// Sets appearance to disabled / screensaver
-(void)notEnabledValues {
    self.overlayView.alpha = 1.0;
    self.productsView.alpha = 0.5;
    [self.informOthers showSecondaryColor:NO];
    [self.rateAndReview showSecondaryColor:NO];
    self.bottomBar.alpha = 0;
    self.seeAllButton.alpha = 0;
}

// Animate to enabled or screensaver state
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

// Callback for timer events
-(void)timerFired:(NSTimer *) theTimer
{
    if(self.enabled){
        // If enabled then increatse the timer count to return to screen saver mode
        // With every action the idle count is set back to 0
        self.idleCount++;
        if(self.idleCount > (IDLE_INTERVAL / SLIDE_INTERVAL)) {
            [self animateEnabled:NO];
        }
    } else if([self.navigationController visibleViewController] == self) {
        // Animate to next item in the carousel if this is the VC in the foreground
        [self.productsView animateToNext];
    }
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
    // Fill in the product review data from the selected item
    ProductReview * productReview = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getNewProductReview];
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"] != [NSNull null] ? selectedProduct[@"ImageUrl"] : nil;
    productReview.productId = selectedProduct[@"Id"];
    productReview.productPageUrl = selectedProduct[@"ProductPageUrl"] != [NSNull null] ? selectedProduct[@"ProductPageUrl"] : nil;
    [self performSegueWithIdentifier:@"rate" sender:productReview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"rate"])
    {
        // Get reference to the destination view controller
        ShareYourThoughtsViewController *rateVC = [segue destinationViewController];
        rateVC.productToReview = (ProductReview *)sender;
        rateVC.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"seeall"]){
        ChooseAProductGridViewController *gridView = [segue destinationViewController];
        gridView.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)seeAllClicked:(id)sender {
    [self performSegueWithIdentifier:@"seeall" sender:self];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.view setNeedsDisplay];
}

@end
