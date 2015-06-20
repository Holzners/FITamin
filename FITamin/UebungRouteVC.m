//
//  UebungRouteVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "UebungRouteVC.h"
#import "UebungAnleitungVC.h"

@import CoreLocation;

@interface UebungRouteVC ()

@end

@implementation UebungRouteVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"gewählter Ort: %@", self.destinationString);
    
    //init Location Manager
    _locationManager = [[CLLocationManager alloc] init];

    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //Draw User Location on map
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    [_locationManager startUpdatingLocation];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    // zoom on Oettingenstraße 67
    CLLocationCoordinate2D zoomLocation;
    zoomLocation =_currentLocation.coordinate;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                       0.5*5000, 0.5*5000);
    [_mapView setRegion:viewRegion animated:YES];
    
    [self calculateRouteFromCurrentToDestination:_targetLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//If Location Manager fails to get Location create PopUp
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - CLLocationManagerDelegate

//called for each location update Location Manager receives
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    _currentLocation = newLocation;
    
    if (_currentLocation != nil) {
        
        if (_targetLocation != nil) {
            CLLocationDistance distanceToTarget =[self calculateDistanceToLocation:_targetLocation];
            if([NSNumber numberWithDouble:distanceToTarget].doubleValue < 15){
                [self nextView:self];
            }
        }
    } else{
        NSLog(@"current Location = nil!");
    }
}

//calculates Distance beetween currentLocation and otherLocation
- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation{
    if(_currentLocation!= nil){
        return[_currentLocation distanceFromLocation:otherLocation];
    }else{
        [_locationManager startUpdatingLocation];
        return[_currentLocation distanceFromLocation:otherLocation];
    }
}

//start calculating route from current location to destination
- (void) calculateRouteFromCurrentToDestination:(CLLocation * )destinationLocation{
    
    //Convert CLLocation to MKMapItem
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:(destinationLocation.coordinate) addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    //Init MKDirectionRequest
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //Set requests transport type to walk
    [request setTransportType:MKDirectionsTransportTypeWalking];
    //start = currentLocation
    request.source = [MKMapItem mapItemForCurrentLocation];
    //set destination
    request.destination = destination;
    
    request.requestsAlternateRoutes = YES;
    
    //init Directions (points of Interesst) for route
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    //calculate Directions
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             
         } else {
             //Print route as Overlay on MKMapView
             [self showRoute:response];
         }
     }];
}

//Prints Overlay on MKMapView
-(void)showRoute:(MKDirectionsResponse *)response
{
    //add overlay polyline step by step for all points of interest
    for (MKRoute *route in response.routes)
    {
        [_mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        //additonaly print navigation command in Log
        /* for (MKRouteStep *step in route.steps)
         {
         NSLog(@"%@", step.instructions);
         } */
    }
}

//Override the rendererForOverlay method from MapView Delegate for custon line color and stroke
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

- (IBAction) nextView:(id)sender{
    [_locationManager stopUpdatingLocation]; 
    [self performSegueWithIdentifier:@"mapToDescription" sender:sender];
}


@end
