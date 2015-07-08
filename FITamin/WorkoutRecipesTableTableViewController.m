//
//  WorkoutRecipesTableTableViewController.m
//  FITamin
//
//  Created by Julia Kinshofer on 01.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "WorkoutRecipesTableTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkoutRecipeCustomCell.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import "RecipeDetailVC.h"
#import "AFHTTPSessionManager.h"
#import "RecipeApiController.h"
#import "RecipeListModel.h"

@interface WorkoutRecipesTableTableViewController ()

@property (nonatomic, strong) NSArray *recipeArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *recipeDictionary;

@property (strong, nonatomic) NSArray *searchRecipeArray;
@property (strong, nonatomic) NSMutableArray *searchRecipeSectionTitles;
@property (strong, nonatomic) NSDictionary *searchRecipeDict;

@property (nonatomic, strong) UISearchBar *searchRecipeBar;
@property (nonatomic, strong) UISearchController *searchRecipeController;

@end

@implementation WorkoutRecipesTableTableViewController

WorkoutRecipeCustomCell *workoutRecipeCell;
NSArray *workoutRecipeArray;
NSDictionary *workoutRecDic;
RecipeModel *selectedWorkoutRecipe;

- (id)initWithStyle:(UITableViewStyle)style
{
    
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"WorkoutRecipeCustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WorkoutRecipeCustomCell"];
    
    // Schnellindex anpassen
    [self.tableView setSectionIndexColor:[UIColor blackColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];

    self.searchSummary = [[SearchModel alloc]init];
    workoutRecipeArray = [[NSArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            
            NSString *chosenMode = mode[@"title"];
            NSLog(@"Muskelgruppe: %@", chosenMode);
            if([chosenMode  isEqual: @"Muskelaufbau"]){
                [self searchWithValue:@"Protein"];
            } else if([chosenMode  isEqual: @"Fettverbrennung"]){
                [self searchWithValue:@"Low Carb"];
            }
            
            
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];
    
    
    


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Anzahl reihen: %lu" , (unsigned long)self.searchSummary.recipes.count);
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutRecipeCustomCell";
    
    WorkoutRecipeCustomCell *cell;
    
    
    
    /** NSArray *array = [NSArray array];
     
     if (tableView == self.tableView) {
     
     //NSString *sectionTitle = self.sectionTitles[indexPath.section];
     //array = (self.recipeDictionary)[sectionTitle];
     
     } else {
     
     NSString *sectionTitle = self.searchRecipeSectionTitles[indexPath.section];
     array = (self.searchRecipeDict)[sectionTitle];
     }*/
    
    // Zellenhintergrund mit Farbverlauf füllen
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    // Farben für Farbverlauf
    //    UIColor *whiteColor = [UIColor whiteColor];
    //    UIColor *darkGreyColor = [UIColor colorWithRed:255.0/255.0 green:230.0/255.0 blue:255.0/255.0 alpha:1.0];
    //
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = cell.bounds;
    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    UIView *background = [[UIView alloc] initWithFrame:cell.bounds];
    [background.layer insertSublayer:farbverlauf atIndex:0];
    cell.backgroundView = background;
    
    RecipeListModel *recipe = [[self.searchSummary recipes] objectAtIndex:indexPath.row];
    
    NSLog(@"Name %@" ,  [recipe title]);
    cell.WorkoutRecipeLabel.text = [recipe title];
    
    [cell.WorkoutRecipeImage setImageWithURL:[NSURL URLWithString:[[recipe image_url ]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] usingProgressView:nil];
    
    
    cell.WorkoutRecipeRating.canRate = false;
    cell.WorkoutRecipeRating.rating = ([[recipe social_rank]doubleValue]/100) * 5;
    cell.WorkoutRecipeRating.starSize = 10;
    cell.WorkoutRecipeLabel.font = [UIFont fontWithName:@"Avenir Next" size:15];
    NSLog(@"Rating %@", [recipe social_rank]);
    NSLog(@"Rating Star%f",  cell.WorkoutRecipeRating.rating);
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect headerFrame = CGRectMake(0, 0, tableView.bounds.size.width, 40);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = headerView.frame;
    
    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    farbverlauf.locations =@[@0.0f, @0.5f, @0.51f, @1.0f];
    
    [headerView.layer insertSublayer:farbverlauf atIndex:0];
    
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:@"Avenir Next" size:15];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    [headerView addSubview:label];
    
    return headerView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"fetching"];
    [HUD show:YES];
    
    RecipeListModel *recipe = [[self.searchSummary recipes] objectAtIndex:indexPath.row];
    [[RecipeApiController instanceShared] getReceipeWithID:[recipe recipe_id] withBlock:^(GetRequestModel *response, NSError *error) {
        if (error==nil) {
            if ([response recipe]!=nil) {
                selectedWorkoutRecipe = [response recipe];
                [self performSegueWithIdentifier:@"showRecipeDetail" sender:self];
                // [self.navigationController pushViewController:detailVC animated:YES];
                [HUD hide:YES];
            }else{
                [HUD setMode:MBProgressHUDModeCustomView];
                [HUD setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-failed"]]];
                [HUD setLabelText:@"Fetching failed"];
                [HUD hide:YES afterDelay:1];
            }
        }else{
            [HUD setMode:MBProgressHUDModeCustomView];
            [HUD setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-error"]]];
            [HUD setLabelText:@"Connection error"];
            [HUD hide:YES afterDelay:1];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        
        RecipeDetailVC *dvc = segue.destinationViewController;
        dvc.recipe = selectedWorkoutRecipe;
    }
}


- (void) searchWithValue:(NSString*) param{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"searching"];
    [HUD show:YES];
    
    [[RecipeApiController instanceShared] searchWithValue:param Page:nil SortBy:SortingByNon withBlock:^(SearchModel *response, NSError *error) {
        if (error==nil) {
            if ([response count]!=nil) {
                self.searchSummary = response;
                NSLog(@"searchSummary %@", self.searchSummary);
                NSLog(@"Länge rückgabe array: %lu", (unsigned long)[[self.searchSummary recipes] count]);
                [self.tableView reloadData];
                [HUD hide:YES];
            }else{
                [HUD setMode:MBProgressHUDModeCustomView];
                [HUD setLabelText:@"Searching failed"];
                [HUD hide:YES afterDelay:1];
            }
        }else{
            [HUD setMode:MBProgressHUDModeCustomView];
            [HUD setLabelText:@"Connection error"];
            [HUD hide:YES afterDelay:1];
        }
    }];
}

@end
