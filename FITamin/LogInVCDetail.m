//
//  LogInVCDetail.m
//  FITamin
//
//  Created by admin on 09.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "LogInVCDetail.h"
#import <ParseUI/PFLogInViewController.h>
#import <Parse/Parse.h>
#import <ParseUI/PFTextField.h>


//Subclass von LogInVC für Details am LogIn Screen

@interface LogInVCDetail ()

@end

@implementation LogInVCDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Logo");
    //Creating own logo and background
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LogInScreen-1.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogInScreenSchrift.png"]]];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(35.0f, 260.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
