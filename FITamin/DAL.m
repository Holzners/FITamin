//
//  DAL.m
//  FITamin
//
//  Created by admin on 17.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAL.h"
#import <Parse/Parse.h>

@implementation DAL


PFObject * getExerciseByName(NSString *name){
    //hier werden dann Queries ausgeführt die
    // anschließend das jeweilige PFObject zurückgebgen
    return [PFObject objectWithClassName:@"Exercise"];
}

PFObject * getExerciseByMuscle(PFObject *muscle){
    //hier werden dann Queries ausgeführt die
    // anschließend das jeweilige PFObject zurückgebgen
    return [PFObject objectWithClassName:@"Exercise"];
}

PFObject * getLocationByExercise(PFObject *exercise){
    //hier werden dann Queries ausgeführt die
    // anschließend das jeweilige PFObject zurückgebgen
    return [PFObject objectWithClassName:@"Location"];
}


- (void)someClassFunction {
    

//Location anlegen
PFObject *location = [PFObject objectWithClassName:@"Location"];
location[@"id"] = @1;
PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:40.0 	longitude:-30.0];
location[@"location"] = point;
location[@"title"] = @"Some nice little spot";

//Location_Photo anlegen
UIImage *image = [UIImage imageNamed:@"Stern.png"];
NSData *imageData = UIImagePNGRepresentation(image);
PFFile *imageFile = [PFFile fileWithName:@"stern.png" data:imageData];
PFObject *locationPhoto = [PFObject objectWithClassName:@"Location_Photo"];
locationPhoto[@"id"] = @1;
locationPhoto[@"imageName"] = @"Star!";
locationPhoto[@"imageFile"] = imageFile;

//Exercise anlegen
PFObject *exercise = [PFObject objectWithClassName:@"Exercise"];
exercise[@"id"] = @1;
//[exercise addUniqueObjectsFromArray:@[@"breast", @"arms"] forKey:@"tags"];
exercise[@"title"] = @"PushUp";

//Muscle anlegen
PFObject *muscle = [PFObject objectWithClassName:@"Muscle"];
muscle[@"id"] = @1;
muscle[@"title"]  = @"Breast";

//Save before create Relation
[location save];
[locationPhoto save];
[exercise save];
[muscle save];

//Relation für Exercise-Muscle hinzufügen
PFRelation *relationExerciseMuscle = [exercise relationForKey:@"muscles"];
[relationExerciseMuscle addObject:muscle];

//Relation für Location-Exercise hinzufügen
PFRelation *relationLocationExercise = [location relationForKey:@"exercises"];
[relationLocationExercise addObject:exercise];

//Relation für Location-Photo hinzufügen
PFRelation *relationLocationPhoto = [location relationForKey:@"photos"];
[relationLocationPhoto addObject:locationPhoto];


//location nochmal speichern
[location saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
        // The object has been saved.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Success" message:@"Location Upload was successfully" delegate:nil cancelButtonTitle:@"Proceed"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // There was a problem, check error.description
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[NSString stringWithFormat:@"%@/%@", @"Location Upload was faulty" , error.description] delegate:nil cancelButtonTitle:@"Proceed"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}];

//Fragen: wie wird so eine query gestaltet, wie kann ich filter bedingungen setzen, was ist der Rückgabewert
PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
//query[@"title"] =
}

@end

