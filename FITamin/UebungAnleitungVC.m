//
//  UebungAnleitungVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "UebungAnleitungVC.h"
@import MediaPlayer;



@implementation UebungAnleitungVC
@synthesize moviePlayer;

-(void)viewDidLoad {

    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current Exercise" message:[NSString stringWithFormat:@"%@/%@", @"Exercise Name:", _currentExercise[@"title"]] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
       // [alert show];
    
    PFFile *theFile = [_currentExercise objectForKey:@"video"];
    NSLog(@"%@",theFile.url); // the .url property contains the URL for the file (video or otherwise)..
    
   // NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Training" ofType:@"mp4"]];
    NSURL *urlString = [NSURL URLWithString:theFile.url];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString ];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, 320)];
    [self.moviePlayer play];
    [self.view addSubview:self.moviePlayer.view];
    
}

- (IBAction)confirmExercise:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button press" message:@"Confirm Button pressed" delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
        [alert show];
    
}

@end
