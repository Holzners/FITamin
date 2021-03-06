//
//  SavedWorkoutsTableVC.h
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SavedWorkoutsTableVC : UITableViewController 

@property (strong, nonatomic) NSMutableArray *savedWorkoutsAsStrings;

@property (strong, nonatomic) NSMutableArray *savedWorkoutsAsPFObjects;

@property (strong, nonatomic) PFObject *selectedWorkoutAsPFObject;

@end
