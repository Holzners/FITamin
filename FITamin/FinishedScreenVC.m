//
//  FinishedScreenVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "FinishedScreenVC.h"

@implementation FinishedScreenVC

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([[self navigationController] isNavigationBarHidden])
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
}


- (IBAction)backToMenu:(id)sender {
    [self performSegueWithIdentifier:@"backToMenu" sender:self];
}

@end
