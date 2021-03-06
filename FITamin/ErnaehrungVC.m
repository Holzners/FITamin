//
//  ErnaehrungVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "ErnaehrungVC.h"


@implementation ErnaehrungVC

-(void) viewDidLoad{
    [super viewDidLoad];
    
    //Swipe Effects
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
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

//durch Tabs mit swipe & flip transition navigieren
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

-(BOOL)prefersStatusBarHidden{
    return YES;
}


@end
