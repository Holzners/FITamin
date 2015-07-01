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

@synthesize moviePlayer;
@synthesize exerciseCounterLabel;

int intExerciseSeconds, intPauseSeconds, intTimerSeconds, intNumberOfRepetitions, intCounter;
bool blnPause;
NSMutableArray *lbls;


-(void)viewDidLoad {

    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current Exercise" message:[NSString stringWithFormat:@"%@/%@", @"Exercise Name:", _currentExercise[@"title"]] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
       // [alert show];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    //Load video and add Player
    PFFile *theFile = [_currentExercise objectForKey:@"video"];
    NSLog(@"%@",theFile.url); // the .url property contains the URL for the file (video or otherwise)..
    NSURL *urlString = [NSURL URLWithString:theFile.url];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString ];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, 320)];
    [self.moviePlayer play];
    [self.view addSubview:self.moviePlayer.view];

    //Counter
    exerciseCounterLabel  = [[UILabel alloc] initWithFrame:CGRectMake(150,350, self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    exerciseCounterLabel.textColor = [UIColor blueColor];
    [exerciseCounterLabel setText:@"Let's get started!"];
    exerciseCounterLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:exerciseCounterLabel];
    
    //ToDo: Die exercise und pause Zeit muss noch aus dem Exercise objekt geholt werden und
    //erstmal angelegt werden (Exercise Objekt erweitern)
    intExerciseSeconds = 20;
    intPauseSeconds = 10;
    intNumberOfRepetitions = [_currentExercise[@"repetition"] intValue];
    intTimerSeconds = intPauseSeconds;
    blnPause = YES;
    
    //Add circles for each Repetition
//    lbls = [NSMutableArray new];
//    for (int i = 0; i < intNumberOfRepetitions; i++)
//    {
//        CGPoint center = CGPointMake(self.view.frame.size.width, self.view.frame.size.height / 2);
//        
//        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(50+(i*100),250, self.view.frame.size.width / 2 +(i*100), self.view.frame.size.height / 2)];
//        label.text = [NSString stringWithFormat:@"%@%d", @"Round ", i+1];
//        [label setBackgroundColor:[UIColor yellowColor]];
//        [self.view addSubview:label];
//        [lbls addObject:label];
//
//    }
    
    //Add Circles for each Repetition
    CGRect bigRect = CGRectMake(0, 320, self.view.frame.size.width, 100);
    self.exerciseCheckView = [[ExerciseCheckView alloc ] initWithFrame:bigRect];
    self.exerciseCheckView.intNumberOfRepetitions = intNumberOfRepetitions;
    self.exerciseCheckView.colors = [[NSMutableArray alloc]initWithCapacity:intNumberOfRepetitions];
    
    for(int i=0; i<intNumberOfRepetitions; i++){
        [self.exerciseCheckView.colors addObject:[[NSNumber alloc]initWithDouble:0.0]];
    }
    
    [self.exerciseCheckView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.exerciseCheckView];
    
}

- (IBAction)confirmExercise:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
        [alert show];
    
}


-(void)startTimer
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}

-(void)timerFired
{
    if(intCounter < intNumberOfRepetitions){
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
        [exerciseCounterLabel setText:@"You're Done!"];
    }

}
- (IBAction)startExercise:(id)sender {
    [self startTimer];
}

@end
