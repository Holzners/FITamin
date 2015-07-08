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
@synthesize confirmExercise;

int intExerciseSeconds, intPauseSeconds, intTimerSeconds, intNumberOfSets,intNumberOfRepetitions, intCounter;
bool blnPause;
NSMutableArray *lbls;


-(void)viewDidLoad {

   /** UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current Exercise" message:[NSString stringWithFormat:@"%@/%@", @"Exercise Name:", currentExercise[@"title"]] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
        [alert show]; */
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    [confirmExercise setAlpha:0];
    
    //Load video and add Player
    PFFile *theFile = [currentExercise objectForKey:@"video"];
    NSLog(@"%@",theFile.url); // the .url property contains the URL for the file (video or otherwise)..
    NSURL *urlString = [NSURL URLWithString:theFile.url];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString ];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, 320)];
    [self.moviePlayer play];
    [self.view addSubview:self.moviePlayer.view];

    //Counter
   // exerciseCounterLabel  = [[UILabel alloc] initWithFrame:CGRectMake(150,350, self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    exerciseCounterLabel.textColor = [UIColor blueColor];
    [exerciseCounterLabel setText:@"Let's get started!"];
    exerciseCounterLabel.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:exerciseCounterLabel];
    
    
    //ToDo: Die exercise und pause Zeit muss noch aus dem Exercise objekt geholt werden und
    //erstmal angelegt werden (Exercise Objekt erweitern)
    intNumberOfSets = [currentExercise[@"set"] intValue];
    intExerciseSeconds = [currentExercise[@"duration"] intValue];
    intNumberOfRepetitions = [currentExercise[@"repetition"] intValue];
    intPauseSeconds = 10;
    intTimerSeconds = intPauseSeconds;
    blnPause = YES;
    
    //Add Circles for each Set
    CGRect bigRect = CGRectMake(0, 320, self.view.frame.size.width, 100);
    self.exerciseCheckView = [[ExerciseCheckView alloc ] initWithFrame:bigRect];
    self.exerciseCheckView.intNumberOfSets = intNumberOfSets;
    self.exerciseCheckView.colors = [[NSMutableArray alloc]initWithCapacity:intNumberOfSets];
    
    for(int i=0; i<intNumberOfSets; i++){
        [self.exerciseCheckView.colors addObject:[[NSNumber alloc]initWithDouble:0.0]];
    }
    
    [self.exerciseCheckView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.exerciseCheckView];
    
}

- (IBAction)startExercise:(id)sender {
    if(intExerciseSeconds != 0){
        //duration-exercise
        [self startDurationExerciseTimer];
    }
    else{
        //repetition-exercise
        [self startRepetitionExerciseTimer];
        
    }
    
    
}


-(void)startRepetitionExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionTimer) userInfo:nil repeats:YES];
}

-(void)startDurationExerciseTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(durationTimer) userInfo:nil repeats:YES];
}




-(void)durationTimer
{
    if(intCounter < intNumberOfSets){
    if(intTimerSeconds > 0 ){
        intTimerSeconds -=1 ;
    }
    else{
        if(blnPause)
        {
            [self.view setBackgroundColor:[UIColor greenColor]];
            intTimerSeconds = intExerciseSeconds;
            blnPause = NO;
            
            }
        else
        {
            [self.view setBackgroundColor:[UIColor orangeColor]];
            intTimerSeconds = intPauseSeconds;
            blnPause = YES;
            [self.exerciseCheckView.colors replaceObjectAtIndex:intCounter withObject:[[NSNumber alloc]initWithDouble:1.0]];
            [self.exerciseCheckView setNeedsDisplay];
            intCounter += 1;
            }
    }
    [exerciseCounterLabel setText:[NSString stringWithFormat:@"%02d" ,intTimerSeconds]];
    }
    else {
        [timer invalidate];
        //Set counter wieder zurücksetzen
        intCounter = 0;
        [exerciseCounterLabel setText:@"You're Done!"];
    }

}


-(void)repetitionTimer
{
    if(intCounter < intNumberOfSets){
        if(intTimerSeconds > 0 ){
            intTimerSeconds -=1 ;
            [exerciseCounterLabel setText:[NSString stringWithFormat:@"%02d" ,intTimerSeconds]];
        }
        else{
                [self.view setBackgroundColor:[UIColor greenColor]];
                [timer invalidate];
                [exerciseCounterLabel setText:@"TRAIN!"];
                [confirmExercise setAlpha:1];
        }
        
    }
    else {
        [timer invalidate];
        //Set counter wieder zurücksetzen
        intCounter = 0;
        [exerciseCounterLabel setText:@"You're Done!"];
    }
    
}

- (IBAction)confirmExercise:(id)sender {
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
    [alert show]; */
    
}
- (IBAction)confirmSingleExercise:(id)sender {
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    intTimerSeconds = intPauseSeconds;
    blnPause = YES;
    [self.exerciseCheckView.colors replaceObjectAtIndex:intCounter withObject:[[NSNumber alloc]initWithDouble:1.0]];
    [self.exerciseCheckView setNeedsDisplay];
    intCounter += 1;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repetitionTimer) userInfo:nil repeats:YES];
}





@end
