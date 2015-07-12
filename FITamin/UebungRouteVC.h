//
//  UebungRouteVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface UebungRouteVC : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKMapItem *destination;

@property (strong , nonatomic) NSMutableArray *exercises;

@property int currentExercise;

@property (strong , nonatomic) NSMutableArray *selectedLocationsWithDistancesAndExercises;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) CLLocation *targetLocation;

@property (strong, nonatomic) NSString *selectedMuscleGroup;

@property (strong, nonatomic) IBOutlet UIButton *targetReached;


-(void)calculateInitialRoute;

-(void)showRoute:(MKDirectionsResponse *)response;

-(NSInteger)getMinDistanceIndex : (NSMutableArray*) array;

-(void) calculateRouteFromCurrentToDestination:(CLLocation * ) destinationLocation;

-(CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation;

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay;



@end
