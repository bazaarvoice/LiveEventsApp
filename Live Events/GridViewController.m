//
//  GridViewController.m
//  Mockup
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "GridViewController.h"
#import "ReviewItemView.h"
#import "UIImageView+WebCache.h"
#import "ProductReview.h"
#import "ReviewViewController.h"
#import "MBProgressHUD.h"
#import "LEDataManager.h"
#import "ManageReviewsViewController.h"
#import "HuedUIImageView.h"
#import "AppConfig.h"

@interface GridViewController ()

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *clearSearchButton;
@property (strong) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation GridViewController

@synthesize dataArray = _dataArray;

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
    [self.collectionView registerClass:[ReviewItemView class] forCellWithReuseIdentifier:@"ReviewItemCell"];
    
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(secretButtonClicked:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.longPressRecognizer];
    
    self.title = @"Choose a Product";
    
    CGRect frame = self.searchTextField.frame;
    frame.size = CGSizeMake(self.searchTextField.frame.size.width, self.searchTextField.frame.size.height + 15);
    self.searchTextField.frame = frame;
    self.dataArray = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProductsForTerm:PRODUCT_SEARCH];

    if(!self.dataArray){
        [self defaultSearch];
    } else {
        [self reload];
    }
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.itemSize = CGSizeMake(237, 348);
    
    HuedUIImageView *clearSearchButton = [[HuedUIImageView alloc] initWithImage:[UIImage imageNamed:@"a_nf_Search-Button.png"]];
    [self.clearSearchButton setBackgroundImage:clearSearchButton.image forState:UIControlStateNormal];
}

- (IBAction)emptySearch:(id)sender {
    self.searchTextField.text = @"";
    if([AppConfig performNetworkSearchForAllProducts]) {
        [self defaultSearch];
    }
}

- (void)defaultSearch {
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.labelText = @"Loading";
    [HUD show:YES];
    self.HUD = HUD;
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    if([AppConfig secondaryProducts].length > 0) {
        [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:[AppConfig secondaryProducts]];
    }
    getFresh.limit = 100;
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];
    
}


- (void)searchWithTerm:(NSString *)term {
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.labelText = @"Loading";
    [HUD show:YES];
    self.HUD = HUD;
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    if(term.length > 0){
        getFresh.search = term;
    } else {
        [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:[AppConfig secondaryProducts]];
    }
    getFresh.limit = 100;
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    NSLog(@"%@", response);
    NSArray *results = [response objectForKey:@"Results"];
    self.dataArray = results;
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.HUD hide:YES];
    [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] setCachedProducts:results forTerm:PRODUCT_SEARCH];
}

-(void)didFailToReceiveResponse:(NSError *)err forRequest:(id)request {
    [self.HUD hide:YES];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"An error occurred.  Please check your connection and try again."
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.tempDataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    NSDictionary *product = self.tempDataArray[index];
    ReviewItemView * reviewItem = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewItemCell" forIndexPath:indexPath];
    if(!reviewItem) {
        reviewItem = [[ReviewItemView alloc] init];
    }
    
    reviewItem.index = index;
    reviewItem.productTitle.text = product[@"Name"];
    if(product[@"ImageUrl"] && product[@"ImageUrl"] != [NSNull null]) {
        [reviewItem.productImage setImageWithURL:[NSURL URLWithString:product[@"ImageUrl"]]];
    } else {
        reviewItem.productImage.image = [UIImage imageNamed:@"noimage.jpeg"];
    }
    return reviewItem;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    NSDictionary * selectedProduct = self.tempDataArray[index];
    ProductReview * productReview = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getNewProductReview];
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"];
    productReview.productId = selectedProduct[@"Id"];
    [self performSegueWithIdentifier:@"rate" sender:productReview];
}

-(void)pruneResults {
    NSString * text = self.searchTextField.text;
    if(text == nil || [text isEqual: @""]){
        self.tempDataArray = self.dataArray;
        return;
    }
    NSMutableArray * newResults = [[NSMutableArray alloc] init];
    for (NSDictionary * product in self.dataArray){
        NSString * name = product[@"Name"];
        if ([name.lowercaseString rangeOfString:text].location == NSNotFound) {
        
        } else {
            [newResults addObject:product];
        }
    }
    self.tempDataArray = newResults;
}


- (IBAction)textFieldChanged:(id)sender {
    if(![AppConfig performNetworkSearchForAllProducts]){
        [self pruneResults];
        [self reload];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([AppConfig performNetworkSearchForAllProducts]) {
        [self searchWithTerm:self.searchTextField.text];
    }
    return NO;
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
    } else if ([[segue identifier] isEqualToString:@"manageReviews"]) {
        // Get reference to the destination view controller
        ManageReviewsViewController *manageVC = [segue destinationViewController];
        manageVC.managedObjectContext = self.managedObjectContext;
    }
    
    
}

- (void)reload{
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self pruneResults];
    [self reload];
}

- (NSArray *)dataArray{
    return _dataArray;
}

- (IBAction)secretButtonClicked:(id)sender {
    if(self.longPressRecognizer.state == UIGestureRecognizerStateBegan){
        [self performSegueWithIdentifier:@"manageReviews" sender:self];        
    }
}

@end
