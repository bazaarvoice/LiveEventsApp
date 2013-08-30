//
//  GridViewController.m
//  Mockup
//
//  Created by Alex Medearis on 5/23/13.
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

#define DEFAULT_SEARCH @""

@interface GridViewController ()

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong) MBProgressHUD *HUD;

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
    CGRect frame = self.searchTextField.frame;
    frame.size = CGSizeMake(self.searchTextField.frame.size.width, self.searchTextField.frame.size.height + 15);
    self.searchTextField.frame = frame;
    self.dataArray = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getCachedProductsForTerm:PRODUCT_SEARCH];

    if(!self.dataArray){
        [self searchWithTerm:DEFAULT_SEARCH];
    } else {
        [self reload];
    }
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.itemSize = CGSizeMake(237, 348);
}

- (IBAction)emptySearch:(id)sender {
    self.searchTextField.text = @"";
    //TODO: remove
    return;
    [self searchWithTerm:DEFAULT_SEARCH];
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
        [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:@"27101950,27101948,27101946,27101945,27101944,24761799,26354605,24857366,26678596,26906088,24537160,21151436,26975622,26975621,26975620,26975619,26975618,26975616,25634479,26464937,24633531,24244654,23001149,25246401,25246400,16671381,25139301,27101953,26922972,24857342,24857338,24857337,24761803,22959246,22959245,22726173,22726171,21129050,25710579,24501961,23764195,22018267,22018255,27130731,24857302,24857361,24857359,25863298,24430386,24787041,24787040,26680901,26680887,26012799,25863345,25863344,25863343,25634553,25246421,25246420,23268060,20968683,25440895,23991159,24625660,24625659,24511209,24511205,24413342,23583146,23583145,26827376,24062803,24062802,24062801,24221406,26095121,26095120,24017198,24017186,21106759,24857365,24625654,26906090,22881103,21095595,26906086,26095141,24413343,24414348,21151441,21151440,21151439,21151438,21151437,21151435,21151434,26095143,26095134,26354616,25634436,25634438,25634445"];
        
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
    ReviewItemView * reviewItem = [[ReviewItemView alloc] init];
    reviewItem.index = index;
    reviewItem.productTitle.text = product[@"Name"];
    [reviewItem.productImage setImageWithURL:[NSURL URLWithString:product[@"ImageUrl"]]];
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
    if([self.searchTextField.text isEqual: @""]){
        self.tempDataArray = self.dataArray;
        return;
    }
    NSMutableArray * newResults = [[NSMutableArray alloc] init];
    for (NSDictionary * product in self.dataArray){
        NSString * name = product[@"Name"];
        if ([name.lowercaseString rangeOfString:self.searchTextField.text.lowercaseString].location == NSNotFound) {
        
        } else {
            [newResults addObject:product];
        }
    }
    self.tempDataArray = newResults;
}


- (IBAction)textFieldChanged:(id)sender {
    [self pruneResults];
    [self reload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // TODO: remove later
    return NO;
    [self searchWithTerm:self.searchTextField.text];
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
    if(self.longPressRecognizer.state == UIGestureRecognizerStateRecognized){
        [self performSegueWithIdentifier:@"manageReviews" sender:self];        
    }
}

@end
