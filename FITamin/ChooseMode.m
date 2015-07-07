//
//  ChooseMode.m
//  FITamin
//
//  Created by Julia Kinshofer on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "ChooseMode.h"
#import <Parse/Parse.h>

@implementation ChooseMode

@synthesize modeImage;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"StartScreenSegue" sender:self];
        } else {
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)chooseMuscle:(id)sender {
    modeImage.image = [UIImage imageNamed: @"ModusScreenMuskel.png"];
    //Muscle Bottom in Array einfügen
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            [mode setObject:@"Muskelaufbau" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            // Did not find any UserStats for the current user
            //Muscle Arms in Array einfügen
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Muskelaufbau";
            mode[@"user"] = [PFUser currentUser];
            [mode save];

            NSLog(@"Error: %@", error);
        }
    }];
   
    [self performSegueWithIdentifier:@"StartScreenSegue" sender:self];
    
}
- (IBAction)chooseFat:(id)sender {
    modeImage.image = [UIImage imageNamed: @"ModusScreenFett.png"];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mode"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * mode, NSError *error) {
        if (!error) {
            [mode setObject:@"Fettverbrennung" forKey:@"title"];
            
            // Save
            [mode saveInBackground];
        } else {
            // Did not find any UserStats for the current user
            //Muscle Arms in Array einfügen
            PFObject *mode = [PFObject objectWithClassName:@"Mode"];
            mode[@"title"]  = @"Fettverbrennung";
            mode[@"user"] = [PFUser currentUser];
            [mode save];
            
            NSLog(@"Error: %@", error);
        }
    }];
    
    [self performSegueWithIdentifier:@"StartScreenSegue" sender:self];
}

@end
