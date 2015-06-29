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

//Implementieren
#import "StartmenuView.h"

@interface StartmenuVC ()

@end

@implementation StartmenuVC

- (void)viewDidLoad {
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"IchHabeMichEingeloggt"] = @"LogIN";
    
    [testObject saveInBackground];
    
    [super viewDidLoad];
    
    //damit Tab Bar die View nicht überlappt
    self.tabBarController.tabBar.translucent = NO;
    [self.tabBarController setDelegate:self];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    NSLog(@"LogoutTest1");
    NSLog(@"LogoutTest3 %@", tabBarController.selectedViewController.title);
    if(viewController == tabBarController.moreNavigationController){
        tabBarController.moreNavigationController.delegate = self;
        NSLog(@"LogoutTest2");
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(navigationController == self.tabBarController.moreNavigationController){
        NSLog(@"LogoutTest3 %@", viewController.title);
        if([viewController.title  isEqual: @"LogoutVC"]){
            [PFUser logOut];
            [self dismissModalViewControllerAnimated:YES];
            NSLog(@"Logout");
        }
    }
}

/*Programmatisches Erzeugen der View
- (void) loadView{
    CGRect frame = [[UIScreen mainScreen] bounds];
    StartmenuView *startmenuView = [[StartmenuView alloc] initWithFrame: frame];
    self.view = startmenuView;
}

//Benennung der Tabs
-(instancetype)init{
    self = [super init];
    if (self){
        self.tabBarItem.title = @"Hier";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
