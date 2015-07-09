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
            self.savedWorkouts = [[NSMutableArray alloc ]init];
            for(PFObject *p in objects){
                [self.savedWorkouts addObject:p[@"title"]];
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
        return [self.savedWorkouts count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WorkoutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *string =[self.savedWorkouts objectAtIndex:indexPath.item];

    
    [cell.textLabel setText:string];
    
    return cell;
}


@end
