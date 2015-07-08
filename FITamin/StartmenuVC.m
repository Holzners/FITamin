//
//  StartmenuVC.m
//  FITamin
//
//  Created by Holzner on 10.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "StartmenuVC.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LogInVC.h"

//Implementieren
#import "StartmenuView.h"

@interface StartmenuVC ()

@end

@implementation StartmenuVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //damit Tab Bar die View nicht überlappt
    self.tabBarController.tabBar.translucent = NO;
    [self.tabBarController setDelegate:self];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
     if(viewController == tabBarController.moreNavigationController){
        tabBarController.moreNavigationController.delegate = self;
            }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(navigationController == self.tabBarController.moreNavigationController){
        if([viewController.title  isEqual: @"LogoutVC"]){
        
            [self dismissViewControllerAnimated:YES completion:NULL];
            LogInVC *livc = [LogInVC new];
            [livc logOutUser];
            [self.navigationController popToViewController:livc animated:YES];
            }
    }
}

@end
