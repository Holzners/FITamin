//
//  MuskelgruppeVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "MuskelgruppeVC.h"
#import "StandortVC.h"
#import <Parse/Parse.h>

@implementation MuskelgruppeVC

@synthesize batman;
@synthesize turnButton;

bool  front=true;
UIButton *button;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.confirmButton.enabled=false;
    self.muscles = [[NSMutableArray alloc] init];
    
}

- (IBAction)chooseArms:(id)sender {
    if (front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeArm.png"];
    self.confirmButton.enabled=true;
    self.selectedMuscleGroup = @"MuskelgruppeArm";
    
    //Muscle Arms in Array einfügen
    PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
    muscle[@"title"]  = @"Arms";
        
    if(muscle != NULL){
        [self.muscles addObject:muscle];
            
        }
    }
    
}

-(IBAction)chooseBauch:(id)sender {
    if(front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBauch.png"];
    self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBauch";
        
        //Muscle Stomach in Array einfügen
        PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
        muscle[@"title"]  = @"Stomach";
        
        if(muscle != NULL){
            [self.muscles addObject:muscle];
            
        }
    }
}

-(IBAction)chooseBeine:(id)sender {
    if (front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBein.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBein";
        
        //Muscle Legs in Array einfügen
        PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
        muscle[@"title"]  = @"Legs";
        
        if(muscle != NULL){
            [self.muscles addObject:muscle];
            
        }
    }
}

-(IBAction)chooseBrust:(id)sender {
    if(front == true){
    batman.image = [UIImage imageNamed: @"MuskelgruppeBrust.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBrust";
        
        //Muscle Breast in Array einfügen
        PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
        muscle[@"title"]  = @"Breast";
        
        if(muscle != NULL){
            [self.muscles addObject:muscle];
            
        }
    }
}

- (void)chooseBack:(UIButton *) button{
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppenRuecken.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppenRuecken.png";
        
        //Muscle Back in Array einfügen
        PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
        muscle[@"title"]  = @"Back";
        
        if(muscle != NULL){
            [self.muscles addObject:muscle];
            
        }

    }
}
- (IBAction)choosePo:(id)sender {
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppePo.png"];
        self.confirmButton.enabled=true;
        
        self.selectedMuscleGroup = @"MuskelgruppenPo.png";
        
        //Muscle Bottom in Array einfügen
        PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
        muscle[@"title"]  = @"Bottom";
        
        if(muscle != NULL){
            [self.muscles addObject:muscle];
            
        }

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //zuerst Exercises zu spezifizierten Muskelgruppen abfragen
    NSMutableArray *exercises = self.getExercises;
    
    if(exercises != NULL){
        //later getWorkout

    }
    
    if (self.selectedMuscleGroup != nil){
        StandortVC *dest = [segue destinationViewController];
        dest.selectedMuscleGroup = self.selectedMuscleGroup;
      
    }
    
}

-(NSMutableArray *)getExercises{
    
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    
    if(self.muscles != NULL){
        
        PFQuery *query;
        for(int i=0;i<[self.muscles count];i++){
            
           //Erst Muskelobjekt holen
            PFQuery *query1 = [PFQuery queryWithClassName:@"Muscle"];
            [query1 whereKey:@"title" equalTo:[self.muscles objectAtIndex: i][@"title"]];
            PFObject *mm1 = [query1 getFirstObject];
            
            //Dann erste Exercise holen, die auf diesen Muskeltyp zeigt
            query = [PFQuery queryWithClassName:@"Exercise"];
            [query whereKey:@"muscles" equalTo:mm1];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *e1, NSError *error) {
                
                if (!e1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldnt Get Exercise" message:@"Exercise Query was not successful" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    // The find succeeded.
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exercise Found" message:[NSString stringWithFormat:@"%@/%@", @"Exercise Name:", e1[@"title"]] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
                    [alert show];
                    [exercises addObject:e1];
                }
            }];
        }
    }
    
    return exercises;
    
}

@end
