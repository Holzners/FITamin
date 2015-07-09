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

-(void) viewDidLoad{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
}

- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex+1] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(selectedIndex+1 > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft  :
                                UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = selectedIndex+1;
                        }
                    }];
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex-1] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(selectedIndex-1 > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft  :
                                UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = selectedIndex-1;
                        }
                    }];
}

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
