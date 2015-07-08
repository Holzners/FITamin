//
//  UebungAnleitungVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ExerciseCheckView.h"

@import MediaPlayer;

@interface UebungAnleitungVC : UIViewController <UIGestureRecognizerDelegate> {

    MPMoviePlayerController *moviePlayer;
    PFObject *currentExercise;
    NSTimer *timer;
    bool blnPause;

}
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (weak, nonatomic) IBOutlet UILabel *exerciseCounterLabel;

@property (strong, nonatomic) PFObject  *currentExercise;

@property (nonatomic, retain) ExerciseCheckView *exerciseCheckView;

@end
