//
//  UebungAnleitungVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "UebungAnleitungVC.h"
#import "ExerciseCheckView.h"
#import <AVFoundation/AVFoundation.h>

@import MediaPlayer;


@implementation UebungAnleitungVC

@synthesize currentExercise;
@synthesize moviePlayer;
@synthesize lblCounter;
@synthesize btnStart;
@synthesize btnTarget;
@synthesize strExerciseType;
@synthesize intSetCounter;

int intExerciseSeconds, intRecreationSeconds, intTimerSeconds, intNumberOfSets,intNumberOfRepetitions;
BOOL blnRecreation, blnWorkoutFinished;


-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self.btnTarget setAlpha:0];
     //Load video and add Player
    PFFile *theFile = [currentExercise objectForKey:@"video"];
    NSURL *urlString = [NSURL URLWithString:theFile.url];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
    [self.moviePlayer prepareToPlay];
    CGRect videoRect = CGRectMake(0, 0, self.view.frame.size.width, 250);
    [self.moviePlayer.view setFrame:videoRect];
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
    
    
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
    
    //Label exercise name
    CGRect rectExerciseName = CGRectMake(0, moviePlayer.view.bounds.origin.y + moviePlayer.view.bounds.size.height , self.view.frame.size.width, 50);
    UILabel *lblExerciseName = [[UILabel alloc] initWithFrame:rectExerciseName];
    [lblExerciseName setText:currentExercise[@"title"]];
    [lblExerciseName setTextAlignment:NSTextAlignmentCenter];
    [lblExerciseName setTextColor:[UIColor whiteColor]];
    [lblExerciseName setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lblExerciseName];
    
    //Create view  that contains Circles for each Set
    CGRect bigRect = CGRectMake(0, moviePlayer.view.bounds.origin.y + moviePlayer.view.bounds.size.height + 50, self.view.frame.size.width, 100);
    self.exerciseCheckView = [[ExerciseCheckView alloc ] initWithFrame:bigRect];
    self.exerciseCheckView.intNumberOfSets = intNumberOfSets;
    self.exerciseCheckView.colors = [[NSMutableArray alloc]initWithCapacity:intNumberOfSets];
    self.exerciseCheckView.intCurrentSet = 0;
    
    
    //Label Counter/Message Box
    CGRect rectCounter = CGRectMake(0, moviePlayer.view.bounds.origin.y + moviePlayer.view.bounds.size.height +150, self.view.frame.size.width, 50);
     self.lblCounter = [[UILabel alloc] initWithFrame:rectCounter];
    [lblCounter setTextAlignment:NSTextAlignmentCenter];
    [lblCounter setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblCounter];
    lblCounter.minimumScaleFactor = 15;
    lblCounter.numberOfLines = 0;
    //[lblCounter sizeToFit];

    
    
    for(int i=0; i<intNumberOfSets; i++){
        
        //Für jeden Kreis wird ein Array mit den drei Farbendefinitionen angelegt -> initial [0.0,0.0,0.0] also weiss
        NSArray *circle = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithDouble:0.0],[[NSNumber alloc] initWithDouble:0.0],[[NSNumber alloc ]initWithDouble:1.0] ,nil];
        [self.exerciseCheckView.colors addObject:circle];
    }
    
    [self.view addSubview:self.exerciseCheckView];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(confirmExercise:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    
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
    [self.btnTarget setAlpha:1];
}


-(void)startRepetitionExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionExerciseTimer) userInfo:nil repeats:YES];
}

-(void)startDurationExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(durationExerciseTimer) userInfo:nil repeats:YES];
}


//Dieser Timer wird verwendet, wenn eine Exercise nach Zeit abgearbeitet wird
-(void)durationExerciseTimer
{
    if(intSetCounter < intNumberOfSets){
    //Es sind noch nicht alle Sets durch
    if(intTimerSeconds > 3 ){
        //Zähle Timer runter
        intTimerSeconds -=1 ;
        //Update Timer Label
        [lblCounter setText:[NSString stringWithFormat:@"%02d\nTap to Pause" ,intTimerSeconds]];
    }
    else if(intTimerSeconds > 0){
        intTimerSeconds -=1;
        //Update Timer Label
        [lblCounter setText:[NSString stringWithFormat:@"%02d\nGet Ready!" ,intTimerSeconds]];
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
    }
    else {
        //Alle Sets durch -> Fertig
        [timer invalidate];
        blnWorkoutFinished = YES;
        [lblCounter setText:@"You're Done!"];
        //Tear down Timer
        [timer invalidate];
        blnWorkoutFinished = YES;
        timer = NULL;
    }

}


- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Wenn exercise vom Typ rep dann muss der Tap ignoriert werden wenn ich in der recreation phase bin (letzte Bedingung)
    if (recognizer.state == UIGestureRecognizerStateEnded && !blnWorkoutFinished && !(blnRecreation && [strExerciseType isEqualToString:@"rep"]))
    {
        if(!blnPause){
        // User tapped screen -> Pause Exercise
        [timer invalidate];
        blnPause = YES;
            
        }  
        else if(timer != NULL && blnPause){
            //User tapped screen again -> continue Exercise
            if([strExerciseType isEqualToString:@"dur"]){
                //duration-exercise
                [self startDurationExerciseTimer];
            }
            else{
                //repetition-exercise
                [self startRepetitionExerciseTimer];
                }
            blnPause = NO;
        }
    }
}


//Dieser Timer wird verwendet, wenn eine Exercise nach Wiederholungen abgearbeitet wird
-(void)repetitionExerciseTimer
{
    if(intSetCounter < intNumberOfSets){
        //Noch nicht alle Sets durch
        if(intTimerSeconds > 3 ){
            //Zähle Timer runter
            intTimerSeconds -=1 ;
            [self.lblCounter setText:[NSString stringWithFormat:@"%02d\nTap to Pause" ,intTimerSeconds]];
        }
        else if(intTimerSeconds > 0){
            intTimerSeconds -=1;
            [lblCounter setText:[NSString stringWithFormat:@"%02d\nGet Ready!" ,intTimerSeconds]];
        }
        else{
            //Hier ist exercise Phase ohne Timer
            [timer invalidate];
            blnRecreation =  NO;
            [lblCounter setText:@"GO GO GO!\n(LONG PRESS TO COFIRM)"];
        }
    }
    else {
        //Alle Sets sind durch -> Fertig
        [timer invalidate];
        blnWorkoutFinished = YES;
        [lblCounter setText:@"You're Done!"];
        //Tear down Timer
        [timer invalidate];
        blnWorkoutFinished = YES;
        timer = NULL;
    }
}


//Der longPress bestätigt das ein Set geschafft ist : exercise -> recreation
-(void) handleLongPressFrom:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //Announce current Exercise
        if(!blnRecreation){
            blnRecreation = YES;
            intTimerSeconds = intRecreationSeconds;
            //update die Circles
            [self.exerciseCheckView.colors replaceObjectAtIndex:intSetCounter withObject:[[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:0.0],[[NSNumber alloc]initWithDouble:1.0],nil]];
            self.exerciseCheckView.intCurrentSet = intSetCounter +1;
            [self.exerciseCheckView setNeedsDisplay];
            intSetCounter += 1;
            //starte den Timer für die recreation
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionExerciseTimer) userInfo:nil repeats:YES];
        }
    }
    
}



- (IBAction)confirmExercise:(id)sender {
    
    NSLog(@"test");
    //Tear down Timer
    [timer invalidate];
    blnWorkoutFinished = YES;
    timer = NULL;
    [self performSegueWithIdentifier:@"unwindToUebungRouteVC" sender:self];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
//     [alert show];
    
}

- (IBAction)confirmTest:(id)sender {
    
    //Tear down Timer
    [timer invalidate];
    blnWorkoutFinished = YES;
    timer = NULL;
}

@end
