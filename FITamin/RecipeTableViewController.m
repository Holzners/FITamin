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
#import "RecipeDetailVC.h"

@interface RecipeTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>


@property (nonatomic, strong) NSArray *recipeArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *recipeDictionary;

@property (strong, nonatomic) NSArray *searchRecipeArray;
@property (strong, nonatomic) NSMutableArray *searchSectionTitles;
@property (strong, nonatomic) NSDictionary *searchRecipeDict;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonPressed:(id)sender;

@end

@implementation RecipeTableViewController

RecipeCustomCell *cell;
NSArray *zutatenArray;
NSDictionary *zutDic;

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
    
    // Schnellindex anpassen
    [self.tableView setSectionIndexColor:[UIColor blackColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    // SearchBar erzeugen
    self.searchBar = [[UISearchBar alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchBar sizeToFit];
    
    
    Recipe *recipe1 = [Recipe new];
    recipe1.recipeDetailName = cell.recipeNameLabel.text;
    recipe1.recipeDetailImage = @"Avocado.jpg";
    recipe1.recipeDetailText = @"Test";
    
    Recipe *recipe2 = [Recipe new];
    recipe2.recipeDetailName = cell.recipeNameLabel.text;
    recipe2.recipeDetailImage = @"Avocado.jpg";
    recipe2.recipeDetailText = @"Test";
    
    
    zutatenArray = [NSArray arrayWithObjects:recipe1, recipe2, nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // self.recipeArray = [Datahandler loadData];
    self.recipeDictionary = [self dictionaryAusArray:self.recipeArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [self.sectionTitles count];
    } else {
        return [self.searchSectionTitles count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSArray *array = [self.recipeDictionary valueForKey:self.sectionTitles[section]];
        return [array count];
    } else { // (tableView == self.searchDisplayController.searchResultsTableView)
        NSArray *array = [self.searchRecipeDict valueForKey:self.searchSectionTitles[section]];
        return [array count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.sectionTitles[section];
    } else {
        return self.searchSectionTitles[section];
    }
}

/* SCHNELLINDEX ANFANG */
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.sectionTitles;
    } else {
        return self.searchSectionTitles;
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.tableView) {
        return [self.sectionTitles indexOfObject:title];
    } else {
        return [self.searchSectionTitles indexOfObject:title];
    }
}

/* SCHNELLINDEX ENDE */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeCustomCell";
    
    RecipeCustomCell *cell;
    
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSArray *array = [NSArray array];
    
    if (tableView == self.tableView) {
        
        NSString *sectionTitle = self.sectionTitles[indexPath.section];
        array = (self.recipeDictionary)[sectionTitle];
        
    } else {
        
        NSString *sectionTitle = self.searchSectionTitles[indexPath.section];
        array = (self.searchRecipeDict)[sectionTitle];
    }
    
    // Zellenhintergrund mit Farbverlauf füllen
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
    
    cell.recipeImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.recipeImageView.layer.borderWidth = 1;
    cell.recipeImageView.layer.cornerRadius = 5;
    cell.recipeImageView.clipsToBounds = YES;
    
    cell.recipeNameLabel.text = array[indexPath.row];
    NSString *imageString = [array[indexPath.row] stringByReplacingOccurrencesOfString:@"ü" withString:@"ue"];
    imageString = [imageString stringByReplacingOccurrencesOfString:@"ä" withString:@"ae"];
    cell.recipeImageView.image = [UIImage imageNamed:imageString];
    cell.recipeNameLabel.font = [UIFont fontWithName:@"mywanderingheart" size:25];
    
    NSLog(@"ZutatenCell: %@",array[indexPath.row]);
    NSLog(@"ZutatenCell: %@",imageString);
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
    label.font = [UIFont fontWithName:@"mywanderingheart" size:25];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    [headerView addSubview:label];
    
    return headerView;
}

-(NSDictionary *)dictionaryAusArray:(NSArray *)array
{
    // Übergebenes Array alphabetisch sortieren
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    if ([self.searchController isActive]) {
        self.searchSectionTitles = [NSMutableArray new];
        
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
        
        if (![self.searchController isActive]) {
            
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
            
            if (![self.searchSectionTitles containsObject:character]) {
                
                [self.searchSectionTitles addObject:character];
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
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

- (IBAction)searchButtonPressed:(id)sender
{
    if (self.tableView.tableHeaderView == nil) {
        
        self.tableView.tableHeaderView = self.searchBar;
        
        [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
        
        [UIView animateWithDuration:0.25f animations:^{
            [self.tableView setContentOffset:CGPointZero];
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
        } completion:^(BOOL finished) {
            [self.tableView setContentOffset:CGPointZero];
            self.tableView.tableHeaderView = nil;
        }];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"recipeSegue" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recipeSegue"]) {
        
        RecipeDetailVC *dvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = sender;
        
        NSArray *array = [NSArray array];
        
        if ([self.searchController isActive]) {
            NSString *sectionTitle = self.searchSectionTitles[indexPath.section];
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
                dvc.recipe = [zutatenArray objectAtIndex:0];
            }

            
        }
    }
}


@end
