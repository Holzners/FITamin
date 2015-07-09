//
//  LogoutVC.m
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "LogoutVC.h"

@interface LogoutVC ()

@end

@implementation LogoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"backToLogIn" sender:self]
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
