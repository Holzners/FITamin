//
//  StandortVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StandortVC : UITableViewController

@property(weak, nonatomic) NSString *selectedMuscleGroup;



@property (weak, nonatomic)  NSString *selectedLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void) sortByDistance:(NSMutableArray*)arrayToSort;

- (void) quickSortLeft:(NSInteger)left withRight:(NSInteger)right;

- (NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right;

- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation;

@end
