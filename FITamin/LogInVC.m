//
//  LogInVC.m
//  FITamin
//
//  Created by admin on 16.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LogInVC.h"
#import <ParseUI/PFLogInViewController.h>
#import "StartmenuVC.h"
#import "ChooseMode.h"
#import "LogInVCDetail.h"

@implementation LogInVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //User bereits eingeloggt
    if([PFUser currentUser] != nil)
    {
       //Modusauswahl überspringen, wenn bereits ein Modus für currentUser abgespeichert ist
        PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
            if (!error) {
                //Modusauswahl überpringen
                [self performSegueWithIdentifier:@"startMenu" sender:self];
            } else {
                //chooseModeVC anzeigen
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
            }
        }];
            }
    
     // No user logged in
        // Create the log in view controller
    else
    {
        [self showLoginController];
    }
}

-(void) showLoginController{
    LogInVCDetail *logInViewController = [[LogInVCDetail alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    logInViewController.fields = PFLogInFieldsDefault;
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}


// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];

    NSLog(@"Login: change View %@",@"ChangeView");
    
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(void) logOutUser {
    [PFUser logOutInBackground];
}


@end
