//
//  UebungAnleitungVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@import MediaPlayer;

@interface UebungAnleitungVC : UIViewController{

    MPMoviePlayerController *moviePlayer;
    PFObject *currentExercise;
    NSTimer *timer;
    IBOutlet UILabel *exerciseCounterLabel;
}

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) PFObject  *currentExercise;

@property (nonatomic, retain) UILabel *exerciseCounterLabel;
-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownnTimer;


@end
