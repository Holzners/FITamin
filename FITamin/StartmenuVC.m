//
//  StartmenuVC.m
//  FITamin
//
//  Created by Holzner on 10.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "StartmenuVC.h"

@interface StartmenuVC ()

@end

@implementation StartmenuVC

- (void)viewDidLoad {
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"HorstNeu"] = @"Köhler";
    
    [testObject saveInBackground];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
