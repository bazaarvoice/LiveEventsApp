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

#define DEFAULT_SEARCH @"Fresh"

@interface GridViewController ()

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
    [self searchWithTerm:DEFAULT_SEARCH];
}

- (IBAction)emptySearch:(id)sender {
    self.searchTextField.text = @"";
    [self searchWithTerm:DEFAULT_SEARCH];
}

- (void)searchWithTerm:(NSString *)term {
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
    [self.HUD hide:YES];
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
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    NSDictionary *product = self.dataArray[index];
    ReviewItemView * reviewItem = [[ReviewItemView alloc] init];
    reviewItem.index = index;
    reviewItem.productTitle.text = product[@"Name"];
    [reviewItem.productImage setImageWithURL:[NSURL URLWithString:product[@"ImageUrl"]]];
    return reviewItem;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    NSDictionary * selectedProduct = self.dataArray[index];
    ProductReview * productReview = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getNewProductReview];
    productReview.name = selectedProduct[@"Name"];
    productReview.imageUrl = selectedProduct[@"ImageUrl"];
    productReview.productId = selectedProduct[@"Id"];
    [self performSegueWithIdentifier:@"rate" sender:productReview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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
    }
}

- (void)reload{
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reload];
}

- (NSArray *)dataArray{
    return _dataArray;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(185, 350);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 60);
}


@end
