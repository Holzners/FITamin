//
//  TabBarStart.m
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "TabBarStart.h"
#import <ParseUI/PFLoginViewController.h>
#import <Parse/Parse.h>

@interface TabBarStart ()

@end

@implementation TabBarStart

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)tabBarController:(UITabBarController *)tabBarController
// didSelectViewController:(UIViewController *)viewController{
//     NSLog(@"LogoutTest1");
//    if(viewController == tabBarController.moreNavigationController){
//        tabBarController.moreNavigationController.delegate = self;
//       
//    }
//
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(navigationController == self.tabBarController.moreNavigationController){
//        
//        if([viewController.title  isEqual: @"Logout"]){
//            [PFUser logOut];
//            [self dismissModalViewControllerAnimated:YES];
//            NSLog(@"Logout");
//        }
//    }
//}

@end
