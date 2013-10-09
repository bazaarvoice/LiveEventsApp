//
//  ManageReviewsViewController.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ManageReviewsViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ManageReviewsViewController ()
@property (weak, nonatomic) IBOutlet MDSpreadView *spreadView;
@property (strong) NSArray * reviews;
@property (strong) NSArray * columns;
@property (strong) NSMutableArray * sorts;

@end

@implementation ManageReviewsViewController

-(void)viewDidLoad {
    self.title = @"Review Submission Dashboard";
    
    self.columns = @[@"Status", @"Created", @"Nickname", @"ProductId", @"Title", @"Review Text", @"SubmissionId"];
    self.sorts = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.columns.count; i++) {
        [self.sorts addObject:[NSNumber numberWithBool:YES]];
    }
    self.reviews = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getAllProductReviews];
    [self.spreadView reloadData];
}

-(void)receivedResponse {
    self.reviews = [[LEDataManager sharedInstanceWithContext:self.managedObjectContext] getAllProductReviews];
    [self.spreadView reloadData];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Spread View Datasource

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfColumnsInSection:(NSInteger)section
{
    return self.columns.count;
}

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfRowsInSection:(NSInteger)section
{
    return self.reviews.count;
}

- (NSInteger)numberOfColumnSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

- (NSInteger)numberOfRowSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

- (IBAction)sendClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        LEDataManager * dataManager = [LEDataManager sharedInstanceWithContext:self.managedObjectContext];
        dataManager.delegate = self;
        [dataManager purgeQueue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

#pragma mark Heights
/*
 // Comment these out to use normal values (see MDSpreadView.h)
 - (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(MDIndexPath *)indexPath
 {
 return 25+indexPath.row;
 }
 
 - (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowHeaderInSection:(NSInteger)rowSection
 {
 //    if (rowSection == 2) return 0; // uncomment to hide this header!
 return 22+rowSection;
 }
 
 - (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
 {
 //    if (columnSection == 2) return 0; // uncomment to hide this header!
 return 110+columnSection*5;
 }
 */

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath
{
    if(indexPath.column == 4) {
        return 420;
    } else {
        return 220;
    }
}


-(NSString *)textForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath {
    NSString * text;
    
    ProductReview * currProductReview = self.reviews[rowPath.row];
    if(columnPath.column == 0){
        if([currProductReview.status isEqualToString:@"Pending"] || [currProductReview.status isEqualToString:@"Submitted"]) {
            text = currProductReview.status;
        } else {
            text = @"Error";
        }
    } else if(columnPath.column == 1){
        text = currProductReview.created;
    } else if(columnPath.column == 2){
        text = currProductReview.nickname;
    } else if(columnPath.column == 3){
        text = currProductReview.productId;
    } else if(columnPath.column == 4){
        text = currProductReview.title;
    } else if(columnPath.column == 5){
        text = currProductReview.reviewText;
    } else if(columnPath.column == 6){
        text = currProductReview.submissionId;
    }
    
    return text;
}

#pragma Cells
- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [self textForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath];
    return cell;
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)rowSection forColumnSection:(NSInteger)columnSection
{
    return rowSection == 0 ? @"" : self.columns[columnSection];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return self.columns[columnPath.column];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    return [NSString stringWithFormat:@"%i", rowPath.row + 1];
}

- (id)spreadView:(MDSpreadView *)aSpreadView objectValueForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return [self textForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath];
}

- (void)sortColumn:(int)column {
    NSString *columnName;
    BOOL ascending = YES;
    if(column == 0){
        columnName = @"status";
        ascending = [self.sorts[0] boolValue];
        self.sorts[0] = [NSNumber numberWithBool:!ascending];
    } else if(column == 1){
        columnName = @"created";
        ascending = [self.sorts[1] boolValue];
        self.sorts[1] = [NSNumber numberWithBool:!ascending];
    } else if(column == 2){
        columnName = @"nickname";
        ascending = [self.sorts[2] boolValue];
        self.sorts[2] = [NSNumber numberWithBool:!ascending];
    } else if(column == 3){
        columnName = @"productId";
        ascending = [self.sorts[3] boolValue];
        self.sorts[3] = [NSNumber numberWithBool:!ascending];
    } else if(column == 4){
        columnName = @"title";
        ascending = [self.sorts[4] boolValue];
        self.sorts[4] = [NSNumber numberWithBool:!ascending];
    } else if(column == 5){
        columnName = @"reviewText";
        ascending = [self.sorts[5] boolValue];
        self.sorts[5] = [NSNumber numberWithBool:!ascending];
    } else if(column == 6){
        columnName = @"submissionId";
        ascending = [self.sorts[6] boolValue];
        self.sorts[6] = [NSNumber numberWithBool:!ascending];
    }

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:columnName ascending:ascending];
    self.reviews = [self.reviews sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.spreadView reloadData];
}

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    if(rowPath.row == -1) {
        [self sortColumn:columnPath.row];
    } else if(columnPath.column == 0) {
        ProductReview * currProductReview = self.reviews[rowPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:currProductReview.status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [self.spreadView deselectCellForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath animated:YES];
    NSLog(@"Selected %@ x %@", rowPath, columnPath);
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];

}

@end
