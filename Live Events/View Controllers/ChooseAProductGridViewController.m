//
//  ChooseAProductGridViewController.m
//  LiveEvents
//
//  Created by Bazaarvoice Engineering on 5/23/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ChooseAProductGridViewController.h"
#import "ReviewItemView.h"
#import "UIImageView+WebCache.h"
#import "ProductReview.h"
#import "ShareYourThoughtsViewController.h"
#import "MBProgressHUD.h"
#import "LEDataManager.h"
#import "ManageReviewsViewController.h"
#import "HuedUIImageView.h"
#import "AppConfig.h"

@interface ChooseAProductGridViewController ()

// Settings button - to send reviews
@property UIBarButtonItem* settingsButton;
// Button to clear search
@property (weak, nonatomic) IBOutlet UIButton *clearSearchButton;
// Loading spinner
@property (strong) MBProgressHUD *HUD;
// Text field for search query
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
// Collection view for displaying grid of products
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// "Clean" data array from network query
@property (strong) NSArray *dataArray;
// Modified data array (used for locally pruned search, no network requests)
@property (strong) NSArray *prunedDataArray;

@end

@implementation ChooseAProductGridViewController

@synthesize dataArray = _dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Choose a Product";
    
    // Fixes iOS 7 bug -- reuse identifier must be registered
    [self.collectionView registerClass:[ReviewItemView class] forCellWithReuseIdentifier:@"ReviewItemCell"];
    
    // Make the search field extra tall
    CGRect frame = self.searchTextField.frame;
    frame.size = CGSizeMake(self.searchTextField.frame.size.width, self.searchTextField.frame.size.height + 15);
    self.searchTextField.frame = frame;
    
    // See if we have a cached product list, otherwise, load it from the network
    self.dataArray = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProductsForIdentifier:PRODUCT_SEARCH];
    if(!self.dataArray){
        [self defaultSearch];
    } else {
        [self reload];
    }
    
    // Set product insets so that the products are laid out appropriately in our grid
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.itemSize = CGSizeMake(237, 348);
    
    // Set up the clear search button
    HuedUIImageView *clearSearchButton = [[HuedUIImageView alloc] initWithImage:[UIImage imageNamed:@"a_nf_Search-Button.png"]];
    [self.clearSearchButton setBackgroundImage:clearSearchButton.image forState:UIControlStateNormal];
    
    self.settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"⚙" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonClicked:)];
    [self.settingsButton setTitle:@"⚙"];
    [self.navigationItem setRightBarButtonItem:self.settingsButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// Handler for clear search button
- (IBAction)emptySearch:(id)sender {
    self.searchTextField.text = @"";
    // Go to the network if appropriate
    if([AppConfig performNetworkSearchForAllProducts]) {
        [self defaultSearch];
    }
}

// Network search without a query -- only use config filters
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
    if([AppConfig secondaryCategory].length > 0) {
        [getFresh setFilterForAttribute:@"CategoryId" equality:BVEqualityEqualTo value:[AppConfig secondaryCategory]];
    }
    getFresh.limit = 100;
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];
    
}


// Network search with a search term
- (void)searchWithTerm:(NSString *)term {
    // If term is empty, then just do a default search
    if(term.length == 0) {
        [self defaultSearch];
        return;
    }
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.labelText = @"Loading";
    [HUD show:YES];
    self.HUD = HUD;
    
    BVGet *getFresh = [[BVGet alloc]initWithType:BVGetTypeProducts];
    getFresh.search = term;
    getFresh.limit = 100;
    [getFresh setFilterForAttribute:@"Name" equality:BVEqualityNotEqualTo value:@"null"];
    [getFresh sendRequestWithDelegate:self];
}

- (BOOL) hasErrors:(NSDictionary *)response {
    BOOL hasErrors = [[response objectForKey:@"HasErrors"] boolValue] || ([response objectForKey:@"HasErrors"] == nil);
    return hasErrors;
}

// Handles network response
- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    if([self hasErrors:response]) {
        NSLog(@"%@", response);
        return;
    }
    NSArray *results = [response objectForKey:@"Results"];
    self.dataArray = results;
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.HUD hide:YES];
    BVGet *getRequest = (BVGet *)request;
    // If not a search request, then cache this response with the PRODUCT_SEARCH key
    if(!getRequest.search) {
        [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] setCachedProducts:results forIdentifier:PRODUCT_SEARCH];
    }
}

// Handles network error
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
    return self.prunedDataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Determine the product that this cell represents
    int index = indexPath.row;
    NSDictionary *product = self.prunedDataArray[index];

    // Create new item view if necessary
    ReviewItemView * reviewItem = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewItemCell" forIndexPath:indexPath];
    if(!reviewItem) {
        reviewItem = [[ReviewItemView alloc] init];
    }
    reviewItem.index = index;
    reviewItem.productTitle.text = product[@"Name"];
    
    // Image data can be finnicky, particularly on staging -- validate imageurl before setting
    if(product[@"ImageUrl"] && product[@"ImageUrl"] != [NSNull null]) {
        // TODO: remove custom code for Acuvue
        NSString * imageUrl = [product[@"ImageUrl"] stringByReplacingOccurrencesOfString:@"http://www.jnjvisioncare.com/en_US/images/products/"
                                                            withString:@"http://www.acuvue.com/sites/default/files/content/us/images/products/"];
            
        [reviewItem.productImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noimage.jpeg"]];
    } else {
        reviewItem.productImage.image = [UIImage imageNamed:@"noimage.jpeg"];
    }
    return reviewItem;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // When a user selects an item, fill in the information with our shared ProductReview
    int index = indexPath.row;
    NSDictionary * selectedProduct = self.prunedDataArray[index];
    ProductReview * productReview = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getNewProductReview];
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"] != [NSNull null] ? selectedProduct[@"ImageUrl"] : nil;
    
    // TODO: remove custom code for Acuvue
    if(productReview.imageUrl) {
        productReview.imageUrl = [productReview.imageUrl stringByReplacingOccurrencesOfString:@"http://www.jnjvisioncare.com/en_US/images/products/"
                                                                                   withString:@"http://www.acuvue.com/sites/default/files/content/us/images/products/"];
    }
    productReview.productId = selectedProduct[@"Id"];
    productReview.productPageUrl = selectedProduct[@"ProductPageUrl"] != [NSNull null] ? selectedProduct[@"ProductPageUrl"] : nil;
    [self performSegueWithIdentifier:@"rate" sender:productReview];
}

-(void)pruneResults {
    // Prunes search results locally based on a substring search
    NSString * text = self.searchTextField.text;
    if(text == nil || [text isEqual: @""]){
        self.prunedDataArray = self.dataArray;
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
    self.prunedDataArray = newResults;
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
        if(self.searchTextField.text.length) {
            [self searchWithTerm:self.searchTextField.text];
        } else {
            [self defaultSearch];
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"rate"])
    {
        // Pass the shared product and context on to the next view controller
        ShareYourThoughtsViewController *rateVC = [segue destinationViewController];
        rateVC.productToReview = (ProductReview *)sender;
        rateVC.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"manageReviews"]) {
        // Proceed to the "secret" product submission manager
        ManageReviewsViewController *manageVC = [segue destinationViewController];
        manageVC.managedObjectContext = self.managedObjectContext;
    }
}

- (void)reload{
    [self.collectionView reloadData];
}

// If the data array changes, we need to reload the product data
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self pruneResults];
    [self reload];
}

- (NSArray *)dataArray{
    return _dataArray;
}

- (void)settingsButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"manageReviews" sender:self];
}

@end
