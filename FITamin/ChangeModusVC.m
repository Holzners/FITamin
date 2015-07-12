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
    
    //Modus in Parse für User abrufen und Bild anpassen
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            
            //Modus abrufen
            chosenMode = mode[@"title"];
            
            //Modus ist Fettverbrennung
            if ([chosenMode  isEqual: @"Fettverbrennung"]){
                
                NSLog(@"Muskelgruppe: %@", chosenMode);
                modusImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
                
            //Modus ist Muskelaufbau
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


    //GestureRecognizer um durch Tabs mir swipe zu navigieren
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
}

//neue View mit PageFlipTransition anzeigen
- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex-1] view];
    
    // Transition using a page flip.
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
}

//Modus un Muskelaufbau ändern
- (IBAction)chooseMuscle:(id)sender {
    modusImage.image = [UIImage imageNamed: @"ModusScreenMuskel.png"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            //Modus in Muskelaufbau ändern
            [mode setObject:@"Muskelaufbau" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            //kein Modus fü currentUser angelegt
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Muskelaufbau";
            mode[@"user"] = [PFUser currentUser];
            [mode save];
            
            NSLog(@"Error: %@", error);
        }
    }];

}

//Modus in Fettverbrennung ändern
- (IBAction)chooseFat:(id)sender {
    modusImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            //Modus in Fettverbrennung ändern
            [mode setObject:@"Fettverbrennung" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            //kein Modus fü currentUser angelegt
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Fettverbrennung";
            mode[@"user"] = [PFUser currentUser];
            [mode save];
            
            NSLog(@"Error: %@", error);
        }
    }];

}

//keine Statusbar anzeigen
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
