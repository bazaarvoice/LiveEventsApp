//
//  ManageReviewsViewController.m
//  Live Events
//
//  Created by Alex Medearis on 8/28/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "ManageReviewsViewController.h"
#import "LEDataManager.h"

@interface ManageReviewsViewController ()
@property (weak, nonatomic) IBOutlet MDSpreadView *spreadView;
@property (strong) NSArray * reviews;
@property (strong) NSArray * columns;
@end

@implementation ManageReviewsViewController

-(void)viewDidLoad {
    self.columns = @[@"Status", @"Created", @"Nickname", @"ProductId", @"Review Text", @"ReviewId"];
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

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath
{
    return 220+indexPath.column*5;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
{
    //    if (columnSection == 2) return 0; // uncomment to hide this header!
    return 110+columnSection*5;
}
*/


-(NSString *)textForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath {
    NSString * text;
    
    ProductReview * currProductReview = self.reviews[rowPath.row];
    if(columnPath.column == 0){
        text = currProductReview.status;
    } else if(columnPath.column == 1){
        text = currProductReview.created;
    } else if(columnPath.column == 2){
        text = currProductReview.nickname;
    } else if(columnPath.column == 3){
        text = currProductReview.productId;
    } else if(columnPath.column == 4){
        text = currProductReview.reviewText;
    } else if(columnPath.column == 5){
        text = currProductReview.reviewId;
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
    return self.columns[columnSection];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return self.columns[columnPath.column];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    return [NSString stringWithFormat:@"%i", rowPath.row];
}

- (id)spreadView:(MDSpreadView *)aSpreadView objectValueForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return [self textForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath];
}

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    [self.spreadView deselectCellForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath animated:YES];
    NSLog(@"Selected %@ x %@", rowPath, columnPath);
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];

}

@end
