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
#import "UebungRouteVC.h"

@implementation MuskelgruppeVC

@synthesize batman;
@synthesize turnButton;

bool  front=true;
UIButton *button;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Code um Beziehungen zu generieren (Standardmäßig auskommentiert)
    //[self createRelations];
    
    
    self.confirmButton.enabled=false;
    self.muscles = [[NSMutableArray alloc] init];
    
}

- (IBAction)chooseArms:(id)sender {
    if (front == true){
        batman.image = [UIImage imageNamed: @"MuskelgruppeArm.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeArm";

        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Arms"];
        
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Arms" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Arms";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                
                NSLog(@"Error: %@", error);
            }
            
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }
        }];
        
        
    }
    
}

-(IBAction)chooseBauch:(id)sender {
    if(front == true){
        batman.image = [UIImage imageNamed: @"MuskelgruppeBauch.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBauch";
        
        //Muscle Stomach in Array einfügen
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Stomach"];
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Stomach" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Stomach";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                
                NSLog(@"Error: %@", error);
            }
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }
        }];
    }
}

-(IBAction)chooseBeine:(id)sender {
    if (front == true){
        batman.image = [UIImage imageNamed: @"MuskelgruppeBein.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBein";
        
        //Muscle Legs in Array einfügen
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Legs"];
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Legs" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Legs";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                
                                NSLog(@"Error: %@", error);
            }
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }

        }];
    }
}

-(IBAction)chooseBrust:(id)sender {
    if(front == true){
        batman.image = [UIImage imageNamed: @"MuskelgruppeBrust.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppeBrust";
        
        //Muscle Breast in Array einfügen
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Breast"];
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Breast" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Breast";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                

                NSLog(@"Error: %@", error);
            }
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }
        }];
    }
}

- (void)chooseBack:(UIButton *) button{
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppenRuecken.png"];
        self.confirmButton.enabled=true;
        self.selectedMuscleGroup = @"MuskelgruppenRuecken.png";
        
        //Muscle Back in Array einfügen
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Back"];
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Back" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Back";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                

                NSLog(@"Error: %@", error);
            }
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }
        }];
    }
}
- (IBAction)choosePo:(id)sender {
    if(front == false){
        batman.image = [UIImage imageNamed: @"MuskelgruppePo.png"];
        self.confirmButton.enabled=true;
        
        self.selectedMuscleGroup = @"MuskelgruppenPo.png";
        
        //Muscle Bottom in Array einfügen
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Bottom"];
        
        //[query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * muscle, NSError *error) {
            if (!error) {
                // Found UserStats
                [muscle setObject:@"Bottom" forKey:@"title"];
                
                // Save
                [muscle saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                //Muscle Arms in Array einfügen
                PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
                muscle[@"title"]  = @"Bottom";
                muscle[@"user"] = [PFUser currentUser];
                [muscle save];
                
                
                NSLog(@"Error: %@", error);
            }
            if(muscle != NULL){
                [self.muscles addObject:muscle];
            }
        }];
        
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
        button.frame = CGRectMake(center, 115.0, 160.0, 160.0);
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
        
        //hier muss jetzt noch geprüft werden
        // welche Exercises noch geladen werden müssen (Videos)
    }
    
    if (self.selectedMuscleGroup != nil){
        UebungRouteVC *dest = [segue destinationViewController];
        dest.exercises = [[NSMutableArray alloc] initWithArray:exercises];
        
        
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
            PFObject *e1 = [query getFirstObject];
            if(e1 != NULL){
                [exercises addObject:e1];
                
            }
            //                            InBackgroundWithBlock:^(PFObject *e1, NSError *error) {
            //
            //                if (!e1) {
            //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldnt Get Exercise" message:@"Exercise Query was not successful" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
            //                    [alert show];
            //                }
            //                else {
            //                    // The find succeeded.
            //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exercise Found" message:[NSString stringWithFormat:@"%@/%@", @"Exercise Name:", e1[@"title"]] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
            //                    [alert show];
            //                    [exercises addObject:e1];
            //                }
            //            }];
        }
    }
    
    
    NSDate *now = [NSDate date];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d.M.yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [string stringByAppendingString: [dateFormatter stringFromDate:now]];
    
    PFObject *workout = [PFObject objectWithClassName:@"Workout"];
    workout[@"exercises"] = exercises;
    
    workout[@"title"] = [[NSString alloc] initWithFormat: @" Workout from %@", string];
    workout[@"user"] = [PFUser currentUser];
    [workout save];
    
    return exercises;
    
}


-(void)loadExerciseRessources:(PFObject *)exercise{
    //hier muss jetzt geprüft werden welche Ressource noch von
    //Parse geladen müssen
    //Lade video zur Exericse
    PFFile *theFile = [exercise objectForKey:@"video"];
    NSLog(@"%@",theFile.url); // the .url property contains the URL for the file (video or otherwise)..
    // If you want to download the data:
    [theFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // data contains the full file... this block will run when it is downloaded.
        // use it inside this block.
    }];
    
}

-(void)createRelations{
    
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Exercise"];
    [query1 whereKey:@"title" equalTo:@"BodyWeightRow"];
    PFObject *e1 = [query1 getFirstObject];
    
    //Dann erste Exercise holen, die auf diesen Muskeltyp zeigt
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"title" equalTo:@"l6"];
    PFObject *l1 = [query getFirstObject];
    
    if(l1 != NULL && e1 != NULL){
        
        
        PFRelation *relation = [l1 relationForKey:@"exercises"];
        [relation addObject:e1];
        
        // now save the exercise object
        [l1 save];
    }

    
    
}

@end
