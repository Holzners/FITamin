//
//  ChooseMode.m
//  FITamin
//
//  Created by Julia Kinshofer on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "ChooseMode.h"

@implementation ChooseMode

@synthesize modeImage;

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)chooseMuscle:(id)sender {
    modeImage.image = [UIImage imageNamed: @"ModusScreenMuskel.png"];
    [self performSegueWithIdentifier:@"StartScreenSegue" sender:self];
    
}
- (IBAction)chooseFat:(id)sender {
    modeImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
    [self performSegueWithIdentifier:@"StartScreenSegue" sender:self];
}

@end
