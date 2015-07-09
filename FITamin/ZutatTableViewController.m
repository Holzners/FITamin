//
//  ZutatTableTableViewController.m
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "ZutatTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"
#import "DetailsViewController.h"
#import "DataPlist.h"

@interface ZutatTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *zutatenArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *zutatenDictionary;

@property (strong, nonatomic) NSArray *searchZutatenArray;
@property (strong, nonatomic) NSMutableArray *searchSectionTitles;
@property (strong, nonatomic) NSDictionary *searchZutatenDict;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonPressed:(id)sender;

@end

@implementation ZutatTableViewController

CustomCell *cell;
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
    
    UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
    
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
    
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    //Zutaten anlegen
    
//    if(cell.selected @"Avocado"){
//        
//    }
    
    Zutat *zutat1 = [Zutat new];
    zutat1.zutatDetailName = cell.zutatenNameLabel.text;
    zutat1.zutatDetailImage = @"Avocado.jpg";
    
//    zutat1.zutatenDetailText = [UIFont fontWithName:@"mywanderingheart" size:25];
    zutat1.zutatDetailText = @"Die Avocado enthält viele gesunde Fettsäuren und ist deshalb gut für den Muskelaufbau und die allgemeine Fitness.";
    
    Zutat *zutat2 = [Zutat new];
    zutat2.zutatDetailName = cell.zutatenNameLabel.text;
    zutat2.zutatDetailImage = @"Erbsen.jpg";
    zutat2.zutatDetailText = @"Erbsen enthalten weihverzweigte Aminosäuren und Glutamin und sind deshalb wichtig für Muskelaufbau und Verdauung.";
    
    Zutat *zutat3 = [Zutat new];
    zutat3.zutatDetailName = cell.zutatenNameLabel.text;
    zutat3.zutatDetailImage = @"Brokkoli.jpg";
    zutat3.zutatDetailText = @"Brokkoli ist ein guter Radikalfänger und entgiftet den Körper auf positive Weise.";
    
    Zutat *zutat4 = [Zutat new];
    zutat4.zutatDetailName = cell.zutatenNameLabel.text;
    zutat4.zutatDetailImage = @"Kaffee.jpg";
    zutat4.zutatDetailText = @"Regt die Leistungsfähigkeit an und steigert somit den Kalorienverbrauch.";
    
    Zutat *zutat5 = [Zutat new];
    zutat5.zutatDetailName = cell.zutatenNameLabel.text;
    zutat5.zutatDetailImage = @"Milch.jpg";
    zutat5.zutatDetailText = @"Das Vitamin Nicotinamid-Ribosid in der Milch verhindert, dass Fett eingelagert wird. Noch dazu enthält Milch viel Eiweiß.";

    Zutat *zutat6 = [Zutat new];
    zutat6.zutatDetailName = cell.zutatenNameLabel.text;
    zutat6.zutatDetailImage = @"Mandeln.jpg";
    zutat6.zutatDetailText = @"Mandeln enthalten reichlich Ballaststoffe, Eiweiß, Mineralstoffe und Vitamine.";
    
    Zutat *zutat7 = [Zutat new];
    zutat7.zutatDetailName = cell.zutatenNameLabel.text;
    zutat7.zutatDetailImage = @"Feigen.jpg";
    zutat7.zutatDetailText = @"Die B-Vitamine und das Kalium in Feigen stärken das Nervensystem und liefern wichtige Ballaststoffe.";
    
    Zutat *zutat8 = [Zutat new];
    zutat8.zutatDetailName = cell.zutatenNameLabel.text;
    zutat8.zutatDetailImage = @"Walnuesse.jpg";
    zutat8.zutatDetailText = @"Eine Hand voll Walnüsse am Tag senkt das Risiko an Krebs zu erkranken und ist gut für die Zufuhr von wichtigen Fettsäuren. ";
    
    Zutat *zutat9 = [Zutat new];
    zutat9.zutatDetailName = cell.zutatenNameLabel.text;
    zutat9.zutatDetailImage = @"Quark.jpg";
    zutat9.zutatDetailText = @"Verhindert Fetteinlagerung und liefert wichtiges Eiweiß. ";
    
    Zutat *zutat10 = [Zutat new];
    zutat10.zutatDetailName = cell.zutatenNameLabel.text;
    zutat10.zutatDetailImage = @"Kurkuma.jpg";
    zutat10.zutatDetailText = @"Kurkuma macht die Zellen widerstandsfähiger. Man fühlt sich fitter und weniger oft krank.";
    
    Zutat *zutat11 = [Zutat new];
    zutat11.zutatDetailName = cell.zutatenNameLabel.text;
    zutat11.zutatDetailImage = @"Quinoa.jpg";
    zutat11.zutatDetailText = @"Quinoa enthält mehr Proteine, Zink und Magnesium als Natur-Reis und hat doppelt so viele Balaststoffe.";
    
    Zutat *zutat12 = [Zutat new];
    zutat12.zutatDetailName = cell.zutatenNameLabel.text;
    zutat12.zutatDetailImage = @"Joghurt.jpg";
    zutat12.zutatDetailText = @"Enthält sehr viel wichtiges Eiweiß und ist gut für die Darmflora.";
    
    Zutat *zutat13 = [Zutat new];
    zutat13.zutatDetailName = cell.zutatenNameLabel.text;
    zutat13.zutatDetailImage = @"Himbeeren.jpg";
    zutat13.zutatDetailText = @"Die Himbeere hilft dir beim Entschlacken im Verdauungstrakt und somit fühlt man sich rundum fit.";
    
    Zutat *zutat14 = [Zutat new];
    zutat14.zutatDetailName = cell.zutatenNameLabel.text;
    zutat14.zutatDetailImage = @"Ingwer.jpg";
    zutat14.zutatDetailText = @"Beim Verzehr von Ingwer steigt die Körpertemperatur und es werden somit mehr Kalorien verbrannt.";
    
    Zutat *zutat15 = [Zutat new];
    zutat15.zutatDetailName = cell.zutatenNameLabel.text;
    zutat15.zutatDetailImage = @"Chili.jpg";
    zutat15.zutatDetailText = @"Chili erhöht den Kalorienverbrauch um bis zu 25 Prozent und steigert die Fettverbrennung.";
    
    Zutat *zutat16 = [Zutat new];
    zutat16.zutatDetailName = cell.zutatenNameLabel.text;
    zutat16.zutatDetailImage = @"Blaubeeren.jpg";
    zutat16.zutatDetailText = @"Die darin enthaltenen Polyphenole können die Entstehung von neuen Fettzellen hemmen. ";
    
    Zutat *zutat17 = [Zutat new];
    zutat17.zutatDetailName = cell.zutatenNameLabel.text;
    zutat17.zutatDetailImage = @"Haferflocken.jpg";
    zutat17.zutatDetailText = @"Haferflocken beinhalten einen hohen Magnesium-Anteil, der die Fettverbrennung fördert. ";

    Zutat *zutat18 = [Zutat new];
    zutat18.zutatDetailName = cell.zutatenNameLabel.text;
    zutat18.zutatDetailImage = @"Huelsenfruechte.jpg";
    zutat18.zutatDetailText = @"Ein Muss für jeden Sportler, denn sie enthalten zwischen 50 und 70 Prozent Kohlennhydrate und dies liefert lang anhaltende Energie.";
    
    Zutat *zutat19 = [Zutat new];
    zutat19.zutatDetailName = cell.zutatenNameLabel.text;
    zutat19.zutatDetailImage = @"Hüttenkäse.jpg";
    zutat19.zutatDetailText = @"Liefert viele Proteine und Eiweiße. Der perfekte Zusatz zum Frühstück.";
    
    Zutat *zutat20 = [Zutat new];
    zutat20.zutatDetailName = cell.zutatenNameLabel.text;
    zutat20.zutatDetailImage = @"Eier.jpg";
    zutat20.zutatDetailText = @"Top-Eiweißgehalt von 12,8 Gramm pro 100 Gramm Eiermenge. ";
    
    Zutat *zutat21 = [Zutat new];
    zutat21.zutatDetailName = cell.zutatenNameLabel.text;
    zutat21.zutatDetailImage = @"Putenfleisch.jpg";
    zutat21.zutatDetailText = @"Eine sehr gute Protein-Quelle und noch dazu fettarm.";
    
    Zutat *zutat22 = [Zutat new];
    zutat22.zutatDetailName = cell.zutatenNameLabel.text;
    zutat22.zutatDetailImage = @"Thunfisch.jpg";
    zutat22.zutatDetailText = @"Enthält wichtige Proteine für den Muskelaufbau.";
    
    Zutat *zutat23 = [Zutat new];
    zutat23.zutatDetailName = cell.zutatenNameLabel.text;
    zutat23.zutatDetailImage = @"Grüner Tee.jpg";
    zutat23.zutatDetailText = @"Die hohe Konzentration an Katechinen regt den Stoffwechsel an und fördert somit die Fettverbrennung.";
    
    
    zutatenArray = [NSArray arrayWithObjects:zutat1, zutat2, zutat3, zutat4, zutat5, zutat6, zutat7, zutat8, zutat9, zutat10, zutat11, zutat12, zutat13, zutat14, zutat15, zutat16, zutat17, zutat18, zutat19, zutat20, zutat21, zutat22, zutat23, nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.zutatenArray = [DataPlist loadData];
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

    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    // Farben für Farbverlauf
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = cell.bounds;
    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    UIView *background = [[UIView alloc] initWithFrame:cell.bounds];
    [background.layer insertSublayer:farbverlauf atIndex:0];
    cell.backgroundView = background;
    
    cell.zutatenNameLabel.text = array[indexPath.row];
    NSString *imageString = [array[indexPath.row] stringByReplacingOccurrencesOfString:@"ü" withString:@"ue"];
    imageString = [imageString stringByReplacingOccurrencesOfString:@"ä" withString:@"ae"];
    cell.zutatenImageView.image = [UIImage imageNamed:imageString];
    cell.zutatenNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:25];
    
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
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect headerFrame = CGRectMake(0, 0, tableView.bounds.size.width, 20);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    CAGradientLayer *farbverlauf = [CAGradientLayer layer];
    
    farbverlauf.frame = headerView.frame;
    
    farbverlauf.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    farbverlauf.locations =@[@0.0f, @0.5f, @0.51f, @1.0f];
    
    [headerView.layer insertSublayer:farbverlauf atIndex:0];
    
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 20)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:@"Avenir Next" size:15];
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
                NSMutableArray *zutatenStringArray = [NSMutableArray new];
                [zutatenStringArray addObject:string];
                dict[character] = zutatenStringArray;
                
            } else {
                
                NSMutableArray *zutatenArray = [NSMutableArray new];
                zutatenArray = dict[character];
                [zutatenArray addObject:string];
                dict[character] = zutatenArray;
                
            }
            
        } else {
            
            if (![self.searchSectionTitles containsObject:character]) {
                
                [self.searchSectionTitles addObject:character];
                NSMutableArray *zutatenStringArray = [NSMutableArray new];
                [zutatenStringArray addObject:string];
                dict[character] = zutatenStringArray;
                
            } else {
                
                NSMutableArray *zutatenArray = [NSMutableArray new];
                zutatenArray = dict[character];
                [zutatenArray addObject:string];
                dict[character] = zutatenArray;
                
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
    [self performSegueWithIdentifier:@"detailsSegue" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        
        DetailsViewController *dvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = sender;
        
        NSArray *array = [NSArray array];
        
        if ([self.searchController isActive]) {
            NSString *sectionTitle = self.searchSectionTitles[indexPath.section];
            array = (self.searchZutatenDict)[sectionTitle];
           // dvc.zutat = [zutatenArray objectAtIndex:indexPath.row];
           dvc.zutatenName = array[indexPath.row];
        } else{
            NSString *sectionTitle = self.sectionTitles[indexPath.section];
            array = (self.zutatenDictionary)[sectionTitle];
            //dvc.zutat = [zutatenArray objectAtIndex:indexPath.row];
            dvc.zutatenName = array[indexPath.row];
            
            if([dvc.zutatenName isEqual:@"Avocado"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:0];
            }
            if([dvc.zutatenName isEqual:@"Erbsen"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:1];
            }
            if([dvc.zutatenName isEqual:@"Brokkoli"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:2];
            }
            if([dvc.zutatenName isEqual:@"Kaffee"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:3];
            }
            if([dvc.zutatenName isEqual:@"Milch"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:4];
            }
            if([dvc.zutatenName isEqual:@"Mandeln"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:5];
            }
            if([dvc.zutatenName isEqual:@"Feigen"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:6];
            }
            if([dvc.zutatenName isEqual:@"Walnüsse"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:7];
            }
            if([dvc.zutatenName isEqual:@"Quark"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:8];
            }
            if([dvc.zutatenName isEqual:@"Kurkuma"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:9];
            }
            if([dvc.zutatenName isEqual:@"Quinoa"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:10];
            }
            if([dvc.zutatenName isEqual:@"Joghurt"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:11];
            }
            if([dvc.zutatenName isEqual:@"Himbeeren"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:12];
            }
            if([dvc.zutatenName isEqual:@"Ingwer"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:13];
            }
            if([dvc.zutatenName isEqual:@"Chili"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:14];
            }
            if([dvc.zutatenName isEqual:@"Blaubeeren"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:15];
            }
            if([dvc.zutatenName isEqual:@"Haferflocken"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:16];
            }
            if([dvc.zutatenName isEqual:@"Hülsenfrüchte"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:17];
            }
            if([dvc.zutatenName isEqual:@"Hüttenkäse"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:18];
            }
            if([dvc.zutatenName isEqual:@"Eier"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:19];
            }
            if([dvc.zutatenName isEqual:@"Putenfleisch"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:20];
            }
            if([dvc.zutatenName isEqual:@"Thunfisch"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:21];
            }
            if([dvc.zutatenName isEqual:@"Grüner Tee"]){
                NSLog(@"blblblblblblb");
                dvc.zutat = [zutatenArray objectAtIndex:22];
            }
            
        }
    }
}

@end
