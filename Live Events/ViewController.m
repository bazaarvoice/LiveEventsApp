//
//  ViewController.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/14/13.
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
#import "GridViewController.h"
#import "AppConfig.h"

#define SLIDE_INTERVAL 3.0
#define IDLE_INTERVAL 6.0

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
@property (weak, nonatomic) IBOutlet FadeLabel *informOthers;
@property (weak, nonatomic) IBOutlet FadeLabel *rateAndReview;
@property (weak, nonatomic) IBOutlet CategoryCell *productsView;
@property (weak, nonatomic) IBOutlet BorderedBar *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *startBar;

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
    
    self.title = [AppConfig title];
    [BVSettings instance].baseURL = [AppConfig apiEndpoint];
    [BVSettings instance].staging = true;
    [BVSettings instance].passKey = [AppConfig apiKey];
    
    self.productsData = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProductsForTerm:INITIAL_SEARCH];
    self.productsView.dataArray = self.productsData;
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:@"27101950,27101948,27101946,27101945,27101944,24761799,26354605,24857366,26678596,26906088,24537160,21151436,26975622,26975621,26975620,26975619,26975618,26975616,25634479,26464937,24633531,24244654,23001149,25246401,25246400,16671381,25139301,27101953,26922972,24857342,24857338,24857337,24761803,22959246,22959245,22726173,22726171,21129050,25710579,24501961,23764195,22018267,22018255,27130731,24857302,24857361,24857359,25863298,24430386,24787041,24787040,26680901,26680887,26012799,25863345,25863344,25863343,25634553,25246421,25246420,23268060,20968683,25440895,23991159,24625660,24625659,24511209,24511205,24413342,23583146,23583145,26827376,24062803,24062802,24062801,24221406,26095121,26095120,24017198,24017186,21106759,24857365,24625654,26906090,22881103,21095595,26906086,26095141,24413343,24414348,21151441,21151440,21151439,21151438,21151437,21151435,21151434,26095143,26095134,26354616,25634436,25634438,25634445"];
    getFresh.limit = 100;
    [getFresh addStatsOn:BVIncludeStatsTypeReviews];
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];

    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:SLIDE_INTERVAL
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:nil
                                                       repeats:YES];

    self.rateAndReview.secondaryColor = [AppConfig primaryColor];
    self.informOthers.secondaryColor = [AppConfig primaryColor];
    
    self.productsView.delegate = self;
    
    self.startBar.backgroundColor = [AppConfig primaryColor];
    
    self.seeAllButton.titleLabel.text = [NSString stringWithFormat:@"See all %@ products >", [AppConfig title]];
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
    [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] setCachedProducts:results forTerm:INITIAL_SEARCH];
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
