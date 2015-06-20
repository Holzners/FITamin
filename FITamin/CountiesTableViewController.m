//
//  CountiesTableTableViewController.m
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "CountiesTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"
#import "DetailsViewController.h"
#import "Datahandler.h"

@interface CountiesTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *zutatenArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *zutatenDictionary;

@property (strong, nonatomic) NSArray *searchZutatenArray;
@property (strong, nonatomic) NSMutableArray *searchSectionTitles;
@property (strong, nonatomic) NSDictionary *searchZutatenDict;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDC;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonPressed:(id)sender;

@end

@implementation CountiesTableViewController

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
    
    UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
    
    // Schnellindex anpassen
    [self.tableView setSectionIndexColor:[UIColor blueColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    // SearchBar erzeugen
    self.searchBar = [[UISearchBar alloc] init];
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    [self.searchBar sizeToFit];
    
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.zutatenArray = [Datahandler loadData];
    self.zutatenDictionary = [self dictionaryAusArray:self.zutatenArray];
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
    self.searchZutatenArray = [self.zutatenArray filteredArrayUsingPredicate:resultPredicate];
    self.searchZutatenDict = [self dictionaryAusArray:self.searchZutatenArray];
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
        NSArray *array = [self.zutatenDictionary valueForKey:self.sectionTitles[section]];
        return [array count];
    } else { // (tableView == self.searchDisplayController.searchResultsTableView)
        NSArray *array = [self.searchZutatenDict valueForKey:self.searchSectionTitles[section]];
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
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell;
    
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSArray *array = [NSArray array];
    
    if (tableView == self.tableView) {
        
        NSString *sectionTitle = self.sectionTitles[indexPath.section];
        array = (self.zutatenDictionary)[sectionTitle];
        
    } else {
        
        NSString *sectionTitle = self.searchSectionTitles[indexPath.section];
        array = (self.searchZutatenDict)[sectionTitle];
    }
    
    // Zellenhintergrund mit Farbverlauf füllen
    cell.backgroundColor = [UIColor clearColor];
    
    // Farben für Farbverlauf
    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *lightGreyColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = cell.bounds;
    farbverlauf.colors = @[(id)whiteColor.CGColor, (id)lightGreyColor.CGColor];
    
    UIView *background = [[UIView alloc] initWithFrame:cell.bounds];
    [background.layer insertSublayer:farbverlauf atIndex:0];
    cell.backgroundView = background;
    
    cell.flagImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    cell.flagImageView.layer.borderWidth = 1;
    cell.flagImageView.layer.cornerRadius = 5;
    cell.flagImageView.clipsToBounds = YES;
    
    cell.zutatenNameLabel.text = array[indexPath.row];
    cell.flagImageView.image = [UIImage imageNamed:array[indexPath.row]];
    
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
    
    UIColor *color1 = [UIColor colorWithRed:242.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:216.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:181.0/255.0 green:198.0/255.0 blue:208.0/255.0 alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:224.0/255.0 green:239.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = headerView.frame;
    
    farbverlauf.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor, (id)color4.CGColor];
    
    farbverlauf.locations =@[@0.0f, @0.5f, @0.51f, @1.0f];
    
    [headerView.layer insertSublayer:farbverlauf atIndex:0];
    
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    
    [headerView addSubview:label];
    
    return headerView;
}

-(NSDictionary *)dictionaryAusArray:(NSArray *)array
{
    // Übergebenes Array alphabetisch sortieren
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    if ([self.searchDisplayController isActive]) {
        self.searchSectionTitles = [NSMutableArray new];
    } else {
        self.sectionTitles = [NSMutableArray new];
    }
    
    // Dictionary, welches zurück gegeben werden soll, initialisieren
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (NSString *string in sortedArray) {
        
        unichar c = [string characterAtIndex:0];
        
        NSString *character = [NSString stringWithCharacters:&c length:1];
        
        if (![self.searchDisplayController isActive]) {
            
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
    [self performSegueWithIdentifier:@"detailsSegue" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        DetailsViewController *dvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = sender;
        
        NSArray *array = [NSArray array];
        
        if ([self.searchDisplayController isActive]) {
            NSString *sectionTitle = self.searchSectionTitles[indexPath.section];
            array = (self.searchZutatenDict)[sectionTitle];
            dvc.zutatenName = array[indexPath.row];
        } else{
            NSString *sectionTitle = self.sectionTitles[indexPath.section];
            array = (self.zutatenDictionary)[sectionTitle];
            dvc.zutatenName = array[indexPath.row];
        }
    }
}

@end
