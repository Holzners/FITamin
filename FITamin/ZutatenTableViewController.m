////
////  ZutatenTableViewController.m
////  FITamin
////
////  Created by admin on 17.06.15.
////  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
////
//
//#import "ZutatenTableViewController.h"
//#import "FitnessZutatenVC.h"
//
//@interface ZutatenTableViewController(){
//    NSArray *listArray;
//
//}
//
//@end
//
//@implementation ZutatenTableViewController
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if(self){
//        //Custom initialization
//    }
//    return self;
//}
//
//
//- (void) viewDidLoad
//{
//    
//    [super viewDidLoad];
//    
//    //pList reinladen -> liegt in mainBundle
//    //Pfad in NSString legen und holen
//    NSString *pfad = [[NSBundle mainBundle] pathForResource:@"zutatenListe" ofType:@"plist"];
//    listArray = [NSArray arrayWithContentsOfFile:pfad];
//    
//    //NSLog(@"%@", listArray);
//    
//}
//
//
//- (void) didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
////Wieviele Sektionen hat TableView
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
////Wieviele Zeilen --> Anzahl der Items im Array
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [listArray count];
//}
//
////Indexpath von Zelle --> Adresse bzw Pfad (Sektion&Zeile)
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    //Titel von der Zelle
//    cell.textLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"nameZutat"];
//    return cell;
//}
//
////Daten in detailledView holen --> Segue: zutat
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //Festlegen, was passiert, falls Segue benutzt wird
//    if([segue.identifier isEqualToString:@"detailsSegue"]){
//        FitnessZutatenVC *fvc = segue.destinationViewController;
//        
//        //Pfad selber holen --> Wenn man auf Zeile klickt, kriegt man in indexPath Pfad also Zeile zurück
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //Array auslesen und an VC weitergeben
//        fvc.nameZutat = [[listArray objectAtIndex:indexPath.row] objectForKey:@"detailsSegue"];
//        return;
//
//        
//    }
//
//
//}
//
//
//@end
