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
//#import "StartmenuView.h"


//Homescreen from TabBar

@interface StartmenuVC ()

@end

@implementation StartmenuVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //damit Tab Bar die View nicht überlappt
    self.tabBarController.tabBar.translucent = NO;
    [self.tabBarController setDelegate:self];
    
    //durch Tabs mit swipe navigieren
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    
}

//durch Tabs mit swipe & flip transition navigieren
- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex+1] view];
    
    // Transition using a page flip.
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

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
     if(viewController == tabBarController.moreNavigationController){
        tabBarController.moreNavigationController.delegate = self;
            }
    
}

//Verbindung mit Logout Screen
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    UINavigationBar *morenavbar = navigationController.navigationBar;
    UINavigationItem *morenavitem = morenavbar.topItem;
    /* We don't need Edit button in More screen. */
    morenavitem.rightBarButtonItem = nil;
    
    if(navigationController == self.tabBarController.moreNavigationController){
        if([viewController.title  isEqual: @"LogoutVC"]){
            [PFUser logOut];
           // self.tabBarController.tabBar.hidden = YES;
        }
    }
}

//keine Statusbar anzeigen
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
