//
//  UebungAnleitungVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "UebungAnleitungVC.h"
#import "ExerciseCheckView.h"

@import MediaPlayer;



@implementation UebungAnleitungVC

@synthesize currentExercise;
@synthesize moviePlayer;
@synthesize exerciseCounterLabel;
@synthesize btnStart;
@synthesize strExerciseType;

int intExerciseSeconds, intRecreationSeconds, intTimerSeconds, intNumberOfSets,intNumberOfRepetitions, intSetCounter;
bool blnRecreation, blnWorkoutFinished;


-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Load video and add Player
    PFFile *theFile = [currentExercise objectForKey:@"video"];
    NSLog(@"%@",theFile.url); // the .url property contains the URL for the file (video or otherwise)..
    NSURL *urlString = [NSURL URLWithString:theFile.url];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString ];
    [self.moviePlayer prepareToPlay];
    CGRect videoRect = CGRectMake(0, 0, self.view.frame.size.width, 250);
    [self.moviePlayer.view setFrame:videoRect];
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
    
    //Counter
    [exerciseCounterLabel setText:@"Let's get started!"];
    
    //hole die exercise spezifischen Attribute für den Timer
    intNumberOfSets = [currentExercise[@"set"] intValue];
    intExerciseSeconds = [currentExercise[@"duration"] intValue];
    intNumberOfRepetitions = [currentExercise[@"repetition"] intValue];
    strExerciseType = [[NSString alloc ] initWithString:currentExercise[@"exerciseType"]];
    intRecreationSeconds = 10;
    intTimerSeconds = intRecreationSeconds;
    blnRecreation = YES;
    blnWorkoutFinished = NO;
    
    //Initialize TapRecognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    //Initialize LongPressRecognizer
    if([strExerciseType isEqualToString:@"rep"]){
    
        //Longpress wird nur aktiviert wenn es sich um repetition exercises handelt
        UILongPressGestureRecognizer *longPressGestureRecognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
        longPressGestureRecognize.minimumPressDuration = 1;
        [self.view addGestureRecognizer:longPressGestureRecognize];
        longPressGestureRecognize.delegate = self;
    
    }
    
    //Create view and that contains Circles for each Set
    CGRect bigRect = CGRectMake(0, moviePlayer.view.bounds.origin.y + moviePlayer.view.bounds.size.height + 50, self.view.frame.size.width, 100);
    self.exerciseCheckView = [[ExerciseCheckView alloc ] initWithFrame:bigRect];
    self.exerciseCheckView.intNumberOfSets = intNumberOfSets;
    self.exerciseCheckView.colors = [[NSMutableArray alloc]initWithCapacity:intNumberOfSets];
    self.exerciseCheckView.intCurrentSet = 0;
    
    for(int i=0; i<intNumberOfSets; i++){
        
        //Für jeden Kreis wird ein Array mit den drei Farbendefinitionen angelegt -> initial [0.0,0.0,0.0] also weiss
        NSArray *circle = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithDouble:0.0],[[NSNumber alloc] initWithDouble:0.0],[[NSNumber alloc ]initWithDouble:1.0] ,nil];
        [self.exerciseCheckView.colors addObject:circle];
    }
    
    [self.view addSubview:self.exerciseCheckView];
    
}

- (IBAction)startExercise:(id)sender {
    
    if([strExerciseType isEqualToString:@"dur"]){
        //duration-exercise
        [self startDurationExerciseTimer];
    }
    else{
        //repetition-exercise
        [self startRepetitionExerciseTimer];
        
    }
    
    [btnStart setAlpha:0];
    
}


-(void)startRepetitionExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionTimer) userInfo:nil repeats:YES];
}

-(void)startDurationExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(durationTimer) userInfo:nil repeats:YES];
}



//Dieser Timer wird verwendet, wenn eine Exercise nach Zeit abgearbeitet wird
-(void)durationTimer
{
    if(intSetCounter < intNumberOfSets){
    //Es sind noch nicht alle Sets durch
    if(intTimerSeconds > 0 ){
        //Zähle Timer runter
        intTimerSeconds -=1 ;
    }
    //Timer ist abgelaufen
    else{
        if(blnRecreation)
        {
            //Recreation -> Exercise
            intTimerSeconds = intExerciseSeconds;
            blnRecreation = NO;
            
            }
        else
        {
            //Exercise -> Recreation
            intTimerSeconds = intRecreationSeconds;
            blnRecreation = YES;
            
            //Der Kreis der das Set repräsentiert wird schwarz eingefärbt
            [self.exerciseCheckView.colors replaceObjectAtIndex:intSetCounter withObject:[[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:1.0],nil]];
            
            self.exerciseCheckView.intCurrentSet = intSetCounter + 1;
            [self.exerciseCheckView setNeedsDisplay];
            intSetCounter += 1;
            }
    }
    //Update Timer Label
    [exerciseCounterLabel setText:[NSString stringWithFormat:@"%02d" ,intTimerSeconds]];
    }
    else {
        //Alle Sets durch -> Fertig
        [timer invalidate];
        intSetCounter = 0;
        blnWorkoutFinished = YES;
        [exerciseCounterLabel setText:@"You're Done!"];
    }

}


//Dieser Timer wird verwendet, wenn eine Exercise nach Wiederholungen abgearbeitet wird
-(void)repetitionTimer
{
    if(intSetCounter < intNumberOfSets){
        //Noch nicht alle Sets durch
        if(intTimerSeconds > 0 ){
            intTimerSeconds -=1 ;
            //Update das counter Label
            [exerciseCounterLabel setText:[NSString stringWithFormat:@"%02d" ,intTimerSeconds]];
        }
        else{
                //Hier ist Exercise Phase ohne Timer
                [timer invalidate];
                blnRecreation =  NO;
                [exerciseCounterLabel setText:@"TRAIN!"];
        }
        
    }
    else {
        //Alle Sets sind durch -> Fertig
        [timer invalidate];
        //Set counter wieder zurücksetzen
        intSetCounter = 0;
         blnWorkoutFinished = YES;
        [exerciseCounterLabel setText:@"You're Done!"];
    }
    
}


- (IBAction)confirmExercise:(id)sender {
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
    [alert show]; */
    
}

- (IBAction)confirmSingleExercise:(id)sender {
    
    intTimerSeconds = intRecreationSeconds;
    [self.exerciseCheckView.colors replaceObjectAtIndex:intSetCounter withObject:[[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:1.0],nil]];
    self.exerciseCheckView.intCurrentSet = intSetCounter +1;
    [self.exerciseCheckView setNeedsDisplay];
    intSetCounter += 1;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionTimer) userInfo:nil repeats:YES];
}


- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded && !blnWorkoutFinished)
    {
        if(!blnPause){
        // User tapped screen -> Pause Exercise
        [timer invalidate];
        blnPause = true;
            
        }
        else if(timer != NULL){
            //User tapped screen again -> continue Exercise
            if(intExerciseSeconds != 0){
                //duration-exercise
                [self startDurationExerciseTimer];
            }
            else{
                //repetition-exercise
                [self startRepetitionExerciseTimer];
                
            }
            
            blnPause = false;

        }
    }
}


-(void) handleLongPressFrom:(UILongPressGestureRecognizer *)recognizer
{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //Announce current Exercise
        if(!blnRecreation){
            
            blnRecreation = YES;
            intTimerSeconds = intRecreationSeconds;
            [self.exerciseCheckView.colors replaceObjectAtIndex:intSetCounter withObject:[[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:1.0],nil]];
            self.exerciseCheckView.intCurrentSet = intSetCounter +1;
            [self.exerciseCheckView setNeedsDisplay];
            intSetCounter += 1;
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionTimer) userInfo:nil repeats:YES];
            
            
        }
    }
    
}




@end
