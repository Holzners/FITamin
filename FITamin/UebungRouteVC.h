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

@interface UebungRouteVC : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKMapItem *destination;

@property (strong , nonatomic) NSMutableArray *excersices;
@property (strong , nonatomic) NSMutableArray *selectedLocationsWithDistancesAndExercises;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) CLLocation *targetLocation;

@property (weak, nonatomic) NSString *selectedMuscleGroup;

- (void) sortByDistance:(NSMutableArray*)arrayToSort;

- (void) quickSort:(NSInteger)left withRight:(NSInteger)right  forArray:(NSMutableArray*)arrayToSort;

- (NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort;

- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation;

- (void) calculateRouteFromCurrentToDestination:(CLLocation * ) destinationLocation;

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay;

-(void)showRoute:(MKDirectionsResponse *)response;

-(void)nextView:(id)sender;

@end
