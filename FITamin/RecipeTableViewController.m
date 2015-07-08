//
//  RecipeTableViewController.m
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "RecipeTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RecipeCustomCell.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import "RecipeDetailVC.h"
#import "AFHTTPSessionManager.h"
#import "RecipeApiController.h"
#import "RecipeListModel.h"

@interface RecipeTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *recipeArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *recipeDictionary;

@property (strong, nonatomic) NSArray *searchRecipeArray;
@property (strong, nonatomic) NSMutableArray *searchRecipeSectionTitles;
@property (strong, nonatomic) NSDictionary *searchRecipeDict;

@property (nonatomic, strong) UISearchController *searchRecipeController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchRecipeButton;

@end

@implementation RecipeTableViewController

RecipeCustomCell *recipeCell;
NSArray *recipeArray;
NSDictionary *recDic;
RecipeModel *selectedRecipe;
@synthesize recipeSearchBar;
@synthesize tableView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"RecipeCustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RecipeCustomCell"];
    
    self.searchSummary = [[SearchModel alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark Content Filtering
//-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//    
//    [self searchWithValue:searchText];
//    
//    if ([scope isEqualToString:@"Protein"]) {
//        NSLog(@"Protein");
//        // Further filter the array with the scope
//        [self searchWithValue:@"protein"];
//    } else if([scope isEqualToString:@"Low Carb"]){
//        [self searchWithValue:@"low carb"];
//
//    }else if([scope isEqualToString:@"Quinoa"]){
//        [self searchWithValue:@"quinoa"];
//        
//    }else if([scope isEqualToString:@"Tuna"]){
//        [self searchWithValue:@"tuna"];
//        
//    }else if([scope isEqualToString:@"Oats"]){
//        [self searchWithValue:@"oats"];
//        
//    }else if([scope isEqualToString:@"Avocado"]){
//        [self searchWithValue:@"avocado"];
//        
//    }
//    
//    
//    NSLog(@"searchSummary: %@",[self.searchSummary recipes]);
//}

        }
    
   
    
    NSString *searchtext = recipeSearchBar.text;
    [self searchWithValue:searchtext];
    [searchBar resignFirstResponder];
    NSLog(@"search Text %@", recipeSearchBar.text);
    NSLog(@"searchButton clicked");
    self.searchDisplayController.active = NO;
    [self.tableView reloadData];

}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
//
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    // Tells the table data source to reload when scope bar selection changes
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

/**
- (void)filterContentForSearchText: (NSString *) searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    self.searchRecipeArray = [self.recipeArray filteredArrayUsingPredicate:resultPredicate];
    self.searchRecipeDict = [self dictionaryAusArray:self.searchRecipeArray];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}*/


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{   return 1;
//    /**
//    if (tableView == self.tableView) {
//        return [self.sectionTitles count];
//    } else {
//        return [self.searchRecipeSectionTitles count];
//    } */
//}

//Hier eventuell Fehler
//andere Methode:

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return [searchResults count];
//        
//    } else {
//        return [recipes count];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Anzahl reihen: %lu" , (unsigned long)self.searchSummary.recipes.count);
    if(self.searchSummary.recipes.count > 30){
        NSLog(@"Über 30");
        return 30;
    } else{
        NSLog(@"Unter 30");
    return self.searchSummary.recipes.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeCustomCell";
    
    RecipeCustomCell *cell;
    
    // Zellenhintergrund mit Farbverlauf füllen
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    RecipeListModel *recipe = [[self.searchSummary recipes] objectAtIndex:indexPath.row];
    
    NSLog(@"Name %@" ,  [recipe title]);
    cell.recipeNameLabel.text = [recipe title];
    
    [cell.recipeImageView setImageWithURL:[NSURL URLWithString:[[recipe image_url ]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] usingProgressView:nil];
    

    cell.rateView.canRate = false;
    cell.rateView.rating = ([[recipe social_rank]doubleValue]/100) * 5;
    cell.rateView.starSize = 10;
    cell.recipeNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:15];
    NSLog(@"Rating %@", [recipe social_rank]);
     NSLog(@"Rating Star%f",  cell.rateView.rating);
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
                selectedRecipe = [response recipe];
                [self performSegueWithIdentifier:@"recipeSegue" sender:self];
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

    if ([segue.identifier isEqualToString:@"recipeSegue"]) {
        
        RecipeDetailVC *dvc = segue.destinationViewController;
        dvc.recipe = selectedRecipe;
        
        /**
        NSIndexPath *indexPath = sender;
        
        NSArray *array = [NSArray array];
        
        if ([self.searchRecipeController isActive]) {
            NSString *sectionTitle = self.searchRecipeSectionTitles[indexPath.section];
            array = (self.searchRecipeDict)[sectionTitle];
            // dvc.zutat = [zutatenArray objectAtIndex:indexPath.row];
            dvc.recipeName = array[indexPath.row];
        } else{
            NSString *sectionTitle = self.sectionTitles[indexPath.section];
            array = (self.recipeDictionary)[sectionTitle];
            //dvc.zutat = [zutatenArray objectAtIndex:indexPath.row];
            dvc.recipeName = array[indexPath.row];
            
            if([dvc.recipeName isEqual:@"Avocado"]){
                NSLog(@"blblblblblblb");
                dvc.recipe = [recipeArray objectAtIndex:0];
            }

            
        }*/
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
    
        [[[self searchDisplayController] searchResultsTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }

@end
