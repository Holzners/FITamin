//
//  ChangeModusVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "ChangeModusVC.h"
#import <Parse/Parse.h>

@implementation ChangeModusVC

NSString *chosenMode;
@synthesize modusImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            
            chosenMode = mode[@"title"];
            
            if ([chosenMode  isEqual: @"Fettverbrennung"]){
                
                NSLog(@"Muskelgruppe: %@", chosenMode);
                modusImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
                
            } else if ([chosenMode  isEqual: @"Muskelaufbau"]){
                NSLog(@"Muskelgruppe: %@", chosenMode);
                modusImage.image = [UIImage imageNamed: @"ModusScreenMuskel.png"];
            }

            
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];
    
     NSLog(@"Muskelgruppe: %@", chosenMode);
    
}

- (IBAction)chooseMuscle:(id)sender {
    modusImage.image = [UIImage imageNamed: @"ModusScreenMuskel.png"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            [mode setObject:@"Muskelaufbau" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            // Did not find any UserStats for the current user
            //Muscle Arms in Array einfügen
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Muskelaufbau";
            mode[@"user"] = [PFUser currentUser];
            [mode save];
            
            NSLog(@"Error: %@", error);
        }
    }];

}
- (IBAction)chooseFat:(id)sender {
    modusImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            
            [mode setObject:@"Fettverbrennung" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            // Did not find any UserStats for the current user
            //Muscle Arms in Array einfügen
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Fettverbrennung";
            mode[@"user"] = [PFUser currentUser];
            [mode save];
            
            NSLog(@"Error: %@", error);
        }
    }];

}

@end
