//
//  NeuWorkoutVC.m
//  FITamin
//
//  Created by admin on 15.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "NeuWorkoutVC.h"
#import <Parse/Parse.h>

@implementation NeuWorkoutVC

NSString *currentMode;

- (IBAction)startWorkout:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
             [alert show];
            
            
            currentMode = mode[@"title"];
            
            if ([currentMode  isEqual: @"Fettverbrennung"]){
                
                NSLog(@"Muskelgruppe: %@", currentMode);
                    [self performSegueWithIdentifier:@"fettverbrennungSegue" sender:self];

                
            } else if ([currentMode  isEqual: @"Muskelaufbau"]){
                NSLog(@"Muskelgruppe: %@", currentMode);
                    [self performSegueWithIdentifier:@"muskelaufbauSegue" sender:self];

            }
            
            
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];



}


@end
