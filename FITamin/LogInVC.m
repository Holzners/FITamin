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


@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"erdbeere.jpg"]];
    self.logInView.logo = logoView; // logo can be any UIView
}
@end
