//
//  SavedWorkoutsVC.m
//  FITamin
//
//  Created by Julia Kinshofer on 12.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "SavedWorkoutsVC.h"

@interface SavedWorkoutsVC ()

@end

@implementation SavedWorkoutsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear: (BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
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
