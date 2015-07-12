//
//  MuskelgruppeVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "MuskelgruppeVC.h"
#import <Parse/Parse.h>
#import "UebungRouteVC.h"
#include <stdio.h>

@implementation MuskelgruppeVC

@synthesize batman;
@synthesize turnButton;
@synthesize mode;

bool  front=true;
UIButton *button;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //Get mode for user
    PFQuery *queryMode = [PFQuery queryWithClassName:@"Mode"];
    [queryMode whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *pfmode = [queryMode getFirstObject];
    
    if([pfmode[@"title"] isEqualToString:@"Muskelaufbau"])
    {
        self.mode = @"mus";
    }
    else
    {
        self.mode = @"fat";
        
        //In diesem Modus werden alle Muskelgruppen automatisch gesetzt und gleich weiter gesprungen zur nächsten view
        [self chooseArms:self];
        [self chooseBauch:self];
        [self chooseBeine:self];
        [self chooseBrust:self];
        [self choosePo:self];
        
            [self performSegueWithIdentifier:@"segueToRoute" sender:self];
   

    }
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Get mode for user
    PFQuery *queryMode = [PFQuery queryWithClassName:@"Mode"];
    [queryMode whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *pfmode = [queryMode getFirstObject];
    
    if([pfmode[@"title"] isEqualToString:@"Muskelaufbau"])
    {
        self.mode = @"mus";
    }
    else
    {
        self.mode = @"fat";
        
        //In diesem Modus werden alle Muskelgruppen automatisch gesetzt und gleich weiter gesprungen zur nächsten view
        [self chooseArms:self];
        [self chooseBauch:self];
        [self chooseBeine:self];
        [self chooseBrust:self];
        [self choosePo:self];
        
        [self performSegueWithIdentifier:@"segueToRoute" sender:self];
    }
    
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
        
        PFObject *muscle =  [query getFirstObject];
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
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Stomach"];
        PFObject *muscle =  [query getFirstObject];
        
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
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Legs"];
        PFObject *muscle =  [query getFirstObject];
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
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Breast"];
        PFObject *muscle =  [query getFirstObject];
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
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Back"];
        PFObject *muscle =  [query getFirstObject];
        
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
        PFQuery *query = [PFQuery queryWithClassName:@"Muscle"];
        [query whereKey:@"title" equalTo:@"Bottom"];
        PFObject *muscle =  [query getFirstObject];
        
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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Choose Name" message:@"Choose your new workouts name!" delegate:self cancelButtonTitle:@"Give Random Name" otherButtonTitles:@"Confirm", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    //zuerst Exercises zu spezifizierten Muskelgruppen abfragen
    NSMutableArray *exercises = self.getExercises;
    
    if(exercises != NULL){

        if (self.selectedMuscleGroup != nil){
            UebungRouteVC *dest = [segue destinationViewController];
            dest.exercises = [[NSMutableArray alloc] initWithArray:exercises];
        }
    }
    
}

-(NSMutableArray *)getExercises{
    
    
    if(self.muscles != NULL){
        
      return  [self getExercisesForNumberOfMuscles:[self.muscles count]];
    }
    else {
        return NULL;
    }
}


-(NSMutableArray *)getExercisesForNumberOfMuscles:(int)musclegroups{
    
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    NSMutableArray *allExercises = [[NSMutableArray alloc] init];
    NSMutableArray *tmpExercises = [[NSMutableArray alloc] init];
    NSMutableArray *fillUpExercises = [[NSMutableArray alloc] init];
    
    for(int k = 0; k < musclegroups; k++){
        
        //Erst zu allen Muskelgruppen alle Exercises holen, die auf diesen Muskeltypen verweisen und den richtigen Modus haben
        PFQuery *query;
        query = [PFQuery queryWithClassName:@"Exercise"];
        [query whereKey:@"muscles" equalTo:[[self.muscles objectAtIndex: k] objectId]];
        [query whereKey:@"mode" equalTo:self.mode];
        tmpExercises =  [[NSMutableArray alloc] initWithArray:[query findObjects]];
        [allExercises addObject:tmpExercises];
        
    }
    
    //gehe jetzt Array von Exercise Arrays Round Robin mäßig durch und fülle damit das standard exercises array auf (immer oberstes von jedem Array)
    int h = 0;
    BOOL blnCanFindMoreExercises = YES;
    
    while(blnCanFindMoreExercises && [exercises count] < 5){
    
    for(int j = 0; j < [allExercises count]; j++){

        //erst prüfen, ob Exercises zu diesem Muskeltyp noch elemente hat
        if(h < [[allExercises objectAtIndex:j] count]){
            
            blnCanFindMoreExercises  = YES;
                //dann prüfen, ob Exercise schon enthalten
                if(![exercises containsObject:[[allExercises objectAtIndex:j] objectAtIndex:h]]){
            
                    [exercises addObject:[[allExercises objectAtIndex:j] objectAtIndex:h]];
                }
            
            }
        else{
            blnCanFindMoreExercises = NO;
        }
        h++;
        }
    }
    
    
    //Falls Workout zu wenige Exercises hat -> bis 5 auffüllen
    if([exercises count] < 5){
        int i = 0;
        PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
        [query whereKey:@"mode" equalTo:self.mode];
    
        fillUpExercises =  [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
        while ([exercises count] < 5 && i < [fillUpExercises count]){
            //hier noch prüfen, ob exercise schon enthalten
            if(![exercises containsObject:[fillUpExercises objectAtIndex:i]]){
                [exercises addObject:[fillUpExercises objectAtIndex:i]];
            }
            i++;
        }
    }
    
    return exercises;
    
}



/*
 *User kann sein Workout selber benennen Random Gottheiten als Fallback
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    NSString *titleString;
    
    if(buttonIndex == 1){
        // User bennent selbst
        titleString = alertTextField.text;
    }else{
        // User ist zu faul und wählt Random
        NSArray *array = [[NSArray alloc]init];
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"griechische_gottheiten" ofType:@"plist"];
        array = [NSArray arrayWithContentsOfFile:plistPath];
        NSUInteger randomIndex = arc4random() % [array count];
        titleString= [array objectAtIndex:randomIndex];
    }
    // DateStamp zum Titel des Workouts
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [DateFormatter stringFromDate:[NSDate date]];
    NSString *titleWithDate = [NSString stringWithFormat: @"%@ %@", titleString ,dateString];
    
    //Workout abspeichern
    PFObject *workout = [PFObject objectWithClassName:@"Workout"];
    workout[@"exercises"] = self.getExercises;
    workout[@"title"] = titleWithDate;
    workout[@"user"] = [PFUser currentUser];
    [workout save];
    
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


//Dieser Code wird nur benötigt um Objekte oder
// Relations auf Parse anzulegen, da dass über Webinterface teilweise nicht möglich ist
-(void)createRelations{
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Location"];
    [query1 whereKey:@"title" equalTo:@"l6"];
    PFObject *l = [query1 getFirstObject];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Exercise"];
    NSArray *exercises = [query2 findObjects];
    
        for(int j=0; [exercises count]; j++){
            
            PFObject *e = exercises[j];
            PFRelation *relation = [l relationForKey:@"exercises"];
            [relation addObject:e];
             [l save];
        }
}


-(void)createRelationFromClass:(NSString *) referencingObjClassName withObjTitle:(NSString *)referencingObjTitle toClass:(NSString *)targetObjClassName withObjTitle:(NSString *)targetObjTitle andRelationKey:(NSString *)keyForRelation{
    
    //RefObject
    PFQuery *query1 = [PFQuery queryWithClassName:referencingObjClassName];
    [query1 whereKey:@"title" equalTo:referencingObjTitle];
    PFObject *e1 = [query1 getFirstObject];
    
    //TargetObj
    PFQuery *query = [PFQuery queryWithClassName:targetObjClassName];
    [query whereKey:@"title" equalTo:targetObjTitle];
    PFObject *m1 = [query getFirstObject];
    
    if( m1 != NULL && e1 != NULL){
        
        PFRelation *relation = [e1 relationForKey:keyForRelation];
        [relation addObject:m1];
        
        // now save the Referencing object
        [e1 save];
    }
    
    
}


@end
