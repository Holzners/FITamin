//
//  UebungRouteVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UebungRouteVC : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) MKMapItem *destination;

- (IBAction) getCurrentLocation:(id)sender;

- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation;

- (void) calculateRouteFromCurrentToDestination:(CLLocation * ) destinationLocation;

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay;

-(void)showRoute:(MKDirectionsResponse *)response;

-(void)nextView:(id)sender;

@end
