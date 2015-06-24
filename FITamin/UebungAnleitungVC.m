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

    NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Training" ofType:@"mp4"]];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, 320)];
    [self.moviePlayer play];
    [self.view addSubview:self.moviePlayer.view];
    
}

@end
