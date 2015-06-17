//
//  DAL.h
//  FITamin
//
//  Created by admin on 17.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//  Mit dem DAL (Data Acces Layer) sollen ein paar Funktionen zur
// leichteren Handhabung von Parse.com bereitgestellt werden

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface DAL: NSObject

@end


PFObject * getExerciseByName(NSString *name);

PFObject * getExerciseByMuscle(PFObject *muscle);

PFObject * getLocationByExercise(PFObject *exercise);





