//
//  MuskelgruppeVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "MuskelgruppeVC.h"
#import "StandortVC.h"

@implementation MuskelgruppeVC

@synthesize batman;
@synthesize turnButton;

bool  front=true;
UIButton *button;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.confirmButton.enabled=false;
    
}

- (IBAction)chooseArms:(id)sender {
    if (front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeArm.png"];
    self.confirmButton.enabled=true;
    self.selectedMuscleGroup = @"MuskelgruppeArm";
    }
    
}

-(IBAction)chooseBauch:(id)sender {
    if(front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBauch.png"];
    self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBauch";
    }
}

-(IBAction)chooseBeine:(id)sender {
    if (front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBein.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBein";
    }
}

-(IBAction)chooseBrust:(id)sender {
    if(front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBrust.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBrust";
    }
}
- (IBAction)turnBatman:(id)sender {
    if (front == true){
        batman.image = [UIImage imageNamed: @"MuskelgruppenBack.png"];
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(chooseBack:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat center = screenWidth/2 -80;
        button.frame = CGRectMake(center, 140.0, 160.0, 180.0);
        [self.view addSubview:button];
        front = false;
    } else{
        batman.image = [UIImage imageNamed: @"MuskelgruppenBatman.png"];
        button.hidden=YES;
        front = true;
        
    }
}
- (void)chooseBack:(UIButton *) button{
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppenRuecken.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppenRuecken.png";
    }
}
- (IBAction)choosePo:(id)sender {
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppePo.png"];
        self.confirmButton.enabled=true;
        
        self.selectedMuscleGroup = @"MuskelgruppenPo.png";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (self.selectedMuscleGroup != nil){
        StandortVC *dest = [segue destinationViewController];
        dest.selectedMuscleGroup = self.selectedMuscleGroup;
      
    }
}
@end
