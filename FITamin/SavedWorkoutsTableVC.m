//
//  SavedWorkoutsTableVC.m
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "SavedWorkoutsTableVC.h"

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
    [query1 whereKey:@"User" equalTo:[PFUser currentUser]];
    //PFObject *mm1 = [query1 getFirstObject];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.savedWorkouts = [NSArray arrayWithArray:objects];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedWorkoutCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"savedWorkoutCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    PFObject *object =[self.savedWorkouts objectAtIndex:indexPath.item];
    
    UILabel *labelVal = [[UILabel alloc] initWithFrame:CGRectMake(218, 40, 30, 23)];
    
    labelVal.text = object[@"title"];
    
    labelVal.tag=100;
    
    [cell.contentView addSubview:labelVal];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
