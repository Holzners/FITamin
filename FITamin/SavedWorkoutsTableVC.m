//
//  SavedWorkoutsTableVC.m
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "SavedWorkoutsTableVC.h"
#import "SavedWorkoutsCell.h"
#import <Parse/Parse.h>
#import "UebungRouteVC.h"

@interface SavedWorkoutsTableVC (){
    BOOL workoutsLoad;
}

@end

@implementation SavedWorkoutsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    workoutsLoad = NO;
    //Erst Muskelobjekt holen
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Workout"];
    [query1 whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.savedWorkoutsAsPFObjects = [NSMutableArray arrayWithArray:objects];
            self.savedWorkoutsAsStrings = [[NSMutableArray alloc ]init];
            for(PFObject *p in objects){
                [self.savedWorkoutsAsStrings addObject:p[@"title"]];
            }
            workoutsLoad = YES;
            [self.tableView reloadData];
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(workoutsLoad){
        return [self.savedWorkoutsAsStrings count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WorkoutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *string =[self.savedWorkoutsAsStrings objectAtIndex:indexPath.item];

    
    [cell.textLabel setText:string];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       self.selectedWorkoutAsPFObject = [self.savedWorkoutsAsPFObjects objectAtIndex:indexPath.item];
        //[self dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"workoutSelected" sender:self];
        
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // id workoutSelected
    if([segue.identifier  isEqual: @"workoutSelected"]){
        
        NSMutableArray *array = [[NSMutableArray alloc]
                          initWithArray:self.selectedWorkoutAsPFObject[@"exercises"]];
        
        UebungRouteVC *routeViewController = segue.destinationViewController;
        routeViewController.hidesBottomBarWhenPushed = YES;
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        routeViewController.exercises = array;
        
    }
    
    
}


@end
