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

#define SLIDE_INTERVAL 2.0
#define IDLE_INTERVAL 4.0

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
    
    self.enabled = false;
    self.title = @"Dove";
    [BVSettings instance].baseURL = @"api.bazaarvoice.com";
    [BVSettings instance].passKey = @"70idospb1wubvlbyzixo3elq9";
    
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
    self.rateAndReview.secondaryColor = [self getMidnightBlueColor];
    self.informOthers.secondaryColor = [self getMidnightBlueColor];
    self.seeAllButton.titleLabel.textColor = [self getMidnightBlueColor];
    
    self.productsView.delegate = self;

    [self notEnabledValues];
}

-(UIColor *)getMidnightBlueColor {
    return [UIColor colorWithRed:(17.0/255) green:(24.0/255) blue:(115.0/255) alpha:1.0];
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
    } else {
        [self.productsView animateToNext];
    }
}


- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    //BVGet *theRequest = (BVGet *)request;
    self.productsData = [response objectForKey:@"Results"];
    self.productsView.dataArray = self.productsData;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.enabled){
        [self animateEnabled:YES];
    }
    self.idleCount = 0;
}

- (void)cellClickedAtIndex:(NSInteger)index {
    NSDictionary * selectedProduct = self.productsData[index];
    NSManagedObjectContext * context = [self managedObjectContext];
    ProductReview * productReview = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"ProductReview"
                                      inManagedObjectContext:context];
    
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"];
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
    } else if ([[segue identifier] isEqualToString:@"gridView"]){
        /*
         GridViewController *gridView = [segue destinationViewController];
        UIButton *clickedButton = sender;
        int index = clickedButton.tag;
        if(index == 0){
            gridView.dataArray = self.extraFreshData;
        } else if(index == 1){
            gridView.dataArray = self.antiperspirantData;
        } else if(index == 2){
            gridView.dataArray = self.hairData;
        } else if(index == 3){
            gridView.dataArray = self.lotionsData;
        }*/
        
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
    [self setInformOthers:nil];
    [self setRateAndReview:nil];
    [self setBottomBar:nil];
    [super viewDidUnload];
}
@end
