//
//  LogInVC.h
//  FITamin
//
//  Created by admin on 16.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/PFLogInViewController.h>
#import <ParseUI/PFSignUpViewController.h>
#import "StartmenuVC.h"

// Implement both delegates
@interface LogInVC :UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

-(BOOL) logInViewController:(PFLogInViewController * __nonnull)logInController shouldBeginLogInWithUsername:(NSString * __nonnull)username password:(NSString * __nonnull)password;
-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didFailToLogInWithError:(nullable NSError *)error;
-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user;
-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController;

-(void)showLoginController;

-(void) logOutUser;

@end