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

@interface RecipeTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *recipeArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *recipeDictionary;

@property (strong, nonatomic) NSArray *searchRecipeArray;
@property (strong, nonatomic) NSMutableArray *searchRecipeSectionTitles;
@property (strong, nonatomic) NSDictionary *searchRecipeDict;

@property (nonatomic, strong) UISearchBar *searchRecipeBar;
@property (nonatomic, strong) UISearchController *searchRecipeController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchRecipeButton;

@end

@implementation RecipeTableViewController

RecipeCustomCell *recipeCell;
NSArray *recipeArray;
NSDictionary *recDic;
RecipeModel *selectedRecipe;
@synthesize recipeSearchBar;


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
    
    /**
    // SearchBar erzeugen
    self.searchRecipeBar = [[UISearchBar alloc] init];
    self.searchRecipeController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchRecipeController.searchResultsUpdater = self;
    self.searchRecipeController.dimsBackgroundDuringPresentation = NO;
    self.searchRecipeController.delegate = self;
    self.tableView.tableHeaderView = self.searchRecipeController.searchBar;
    [self.searchRecipeBar sizeToFit];
    **
    
    Recipe *recipe1 = [Recipe new];
    recipe1.recipeDetailName = recipeCell.recipeNameLabel.text;
    recipe1.recipeDetailImage = @"Avocado.jpg";
    recipe1.recipeDetailText = @"Test";
    
    Recipe *recipe2 = [Recipe new];
    recipe2.recipeDetailName = recipeCell.recipeNameLabel.text;
    recipe2.recipeDetailImage = @"Avocado.jpg";
    recipe2.recipeDetailText = @"Test";
   */
    self.searchSummary = [[SearchModel alloc]init];
    //recipeArray = [[NSArray alloc]init];
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // self.recipeArray = [Datahandler loadData];
   // self.recipeDictionary = [self dictionaryAusArray:self.recipeArray];
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [self searchWithValue:searchText];
    
    if ([scope isEqualToString:@"Protein"]) {
        NSLog(@"Protein");
        // Further filter the array with the scope
        [self searchWithValue:@"protein"];
    } else if([scope isEqualToString:@"Low Carb"]){
        [self searchWithValue:@"low carb"];

    }else if([scope isEqualToString:@"Quinoa"]){
        [self searchWithValue:@"quinoa"];
        
    }else if([scope isEqualToString:@"Tuna"]){
        [self searchWithValue:@"tuna"];
        
    }else if([scope isEqualToString:@"Oats"]){
        [self searchWithValue:@"oats"];
        
    }else if([scope isEqualToString:@"Avocado"]){
        [self searchWithValue:@"avocado"];
        
    }
    
    
    NSLog(@"searchSummary: %@",[self.searchSummary recipes]);
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Anzahl reihen: %lu" , (unsigned long)self.searchSummary.recipes.count);
    return self.searchSummary.recipes.count;
   /** if (tableView == self.tableView) {
        NSArray *array = [self.recipeDictionary valueForKey:self.sectionTitles[section]];
        return [array count];
    } else { // (tableView == self.searchDisplayController.searchResultsTableView)
        NSArray *array = [self.searchRecipeDict valueForKey:self.searchRecipeSectionTitles[section]];
        return [array count];
    }*/
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{   return @"Rezepte";
//    /**
//    if (tableView == self.tableView) {
//        return self.sectionTitles[section];
//    } else {
//        return self.searchRecipeSectionTitles[section];
//    }
//  */
//}

/* SCHNELLINDEX ANFANG
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.sectionTitles;
    } else {
        //return self.searchRecipeSectionTitles;
    }
} */

/* SCHNELLINDEX ENDE */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeCustomCell";
    
    RecipeCustomCell *cell;
    
  
    
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
//    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
//    
//    farbverlauf.frame = cell.bounds;
//    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
//    
//    UIView *background = [[UIView alloc] initWithFrame:cell.bounds];
//    [background.layer insertSublayer:farbverlauf atIndex:0];
//    cell.backgroundView = background;
    
  /**  cell.recipeImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.recipeImageView.layer.borderWidth = 1;
    cell.recipeImageView.layer.cornerRadius = 5;
    cell.recipeImageView.clipsToBounds = YES; */
    
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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    CGRect headerFrame = CGRectMake(0, 0, tableView.bounds.size.width, 40);
//    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
//    
//    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
//    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
//    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
//    
//    farbverlauf.frame = headerView.frame;
//    
//    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
//    
//    farbverlauf.locations =@[@0.0f, @0.5f, @0.51f, @1.0f];
//    
//    [headerView.layer insertSublayer:farbverlauf atIndex:0];
//    
//    // Label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
//    label.text = [self tableView:tableView titleForHeaderInSection:section];
//    label.font = [UIFont fontWithName:@"Avenir Next" size:15];
//    label.shadowOffset = CGSizeMake(0, 1);
//    label.shadowColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    
//    [headerView addSubview:label];
//    
//    return headerView;
//}
/*
-(NSDictionary *)dictionaryAusArray:(NSArray *)array
{
    // Übergebenes Array alphabetisch sortieren
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    if ([self.searchRecipeController isActive]) {
        self.searchRecipeSectionTitles = [NSMutableArray new];
        
        NSLog(@"ZutatenDic: %@", sortedArray);
    } else {
        self.sectionTitles = [NSMutableArray new];
        
        NSLog(@"ZutatenDic2: %@", sortedArray);
    }
    
    // Dictionary, welches zurück gegeben werden soll, initialisieren
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (NSString *string in sortedArray) {
        
        unichar c = [string characterAtIndex:0];
        
        NSString *character = [NSString stringWithCharacters:&c length:1];
        
        if (![self.searchRecipeController isActive]) {
            
            if (![self.sectionTitles containsObject:character]) {
                
                [self.sectionTitles addObject:character];
                NSMutableArray *countryStringArray = [NSMutableArray new];
                [countryStringArray addObject:string];
                dict[character] = countryStringArray;
                
            } else {
                
                NSMutableArray *countryArray = [NSMutableArray new];
                countryArray = dict[character];
                [countryArray addObject:string];
                dict[character] = countryArray;
                
            }
            
        } else {
            
            if (![self.searchRecipeSectionTitles containsObject:character]) {
                
                [self.searchRecipeSectionTitles addObject:character];
                NSMutableArray *countryStringArray = [NSMutableArray new];
                [countryStringArray addObject:string];
                dict[character] = countryStringArray;
                
            } else {
                
                NSMutableArray *countryArray = [NSMutableArray new];
                countryArray = dict[character];
                [countryArray addObject:string];
                dict[character] = countryArray;
                
            }
        }
    }
    NSLog(@"ZutatenDic3: %@", dict);
    return dict;
    
}*/




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
        dvc.recipe = selectedRecipe;/**
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
    }




@end
