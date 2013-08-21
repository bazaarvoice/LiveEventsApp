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

#define DEFAULT_SEARCH @""

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
        [getFresh setFilterForAttribute:@"id" equality:BVEqualityEqualTo value:@"24221406,24062803,24787040,26012799,24062801,23583145,24221406,23583145,24934982,24062802,23583146,,24413346,24625659,23268060,26678596,26095121,25634445,25139301,26095120,24413346,24625659,24857338,21129050,24761805,24413375,26827376,27101953,27101945,24857302,,20968683,26095134,25246425,25863343,25863298,26975619,21151440,24430386,24761803,22726173,20863046,24857337,24857361,24857359,24857366,26354605,23764195,24017186,,,25246420,26680901,25539929,25634553,16671381,25246401,26354616,25246400,25440895,25246420,26680901,27130737,23991159,27130731,24017198,24501961,22018255,22018267,25710579,23001149,24633531,24244654,26464937,24511209,2451120"];
        
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


@end
