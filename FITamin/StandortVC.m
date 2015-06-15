//
//  StandortVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "StandortVC.h"

@import CoreLocation;

@interface StandortVC ()

@end

@implementation StandortVC {
    CLLocationManager *locationManager;
    CLLocation *location_ENGLISCHER_GARTEN;
    CLLocation *location_OLYMPIAPARK;
    CLLocation *location_LUITPOLDPARK;
    CLLocation *currentLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init Location Manager
    locationManager = [[CLLocationManager alloc] init];
    
    //set Coordinates for "Englischer Garten"
    location_ENGLISCHER_GARTEN = [[CLLocation alloc] initWithLatitude:48.149925 longitude:11.586658];
    //set Coordinates for "Olympiapark
    location_OLYMPIAPARK =[[CLLocation alloc] initWithLatitude:48.174394 longitude:11.559760];
    //Set Coordinates for Luitpoldpark
    location_LUITPOLDPARK =[[CLLocation alloc] initWithLatitude:48.172892 longitude:11.572442];
    
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    //Draw User Location on map
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    // zoom on Oettingenstraße 67
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 48.150184;
    zoomLocation.longitude= 11.594540;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                       0.5*5000, 0.5*5000);
    [_mapView setRegion:viewRegion animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)getCurrentLocation:(id)sender{
    //stop existing request (if exists)
    [locationManager stopUpdatingLocation];
    
    locationManager.delegate = self;
    //set high accuracy cause each m matters ;)
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //start new location update request
    [locationManager startUpdatingLocation];
    
    //Placeholder: show route to Englsicher Garten
    [self calculateRouteFromCurrentToDestination:location_ENGLISCHER_GARTEN];
    
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
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        //zoom in current location
        MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
                                           2000, 2000);
        [_mapView setRegion:region animated:NO];
        
        /*  NSLog([NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude], "Longitude");
         NSLog([NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude], "Latitude");
         
         
         CLLocationDistance distanceEG = [self calculateDistanceToLocation:location_ENGLISCHER_GARTEN];
         CLLocationDistance distanceLP = [self calculateDistanceToLocation:location_LUITPOLDPARK];
         CLLocationDistance distanceOP = [self calculateDistanceToLocation:location_OLYMPIAPARK];
         
         //CLLocationDistance ist kein Objective C Objekt um die Entfernungen in einem Dictonairy zu Speichern:
         NSNumber *numberDistanceEG = [ NSNumber numberWithDouble:distanceEG];
         NSNumber *numberDistanceOP = [ NSNumber numberWithDouble:distanceLP];
         NSNumber *numberDistanceLP = [ NSNumber numberWithDouble:distanceOP];
         
         NSMutableDictionary *dict = [NSMutableDictionary
         dictionaryWithObjects:@[numberDistanceEG,numberDistanceLP,numberDistanceOP]
         forKeys:@[@"Englischer Garten",@"Luitpoldpark",@"Olympiapark"]];
         
         [dict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
         NSLog(@"%@ => %@", key, value);
         }];
         */
    } else{
        NSLog(@"current Location = nil!");
    }
}

//calculates Distance beetween currentLocation and otherLocation
- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation{
    if(currentLocation!= nil){
        return[currentLocation distanceFromLocation:otherLocation];
    }else{
        [locationManager startUpdatingLocation];
        return[currentLocation distanceFromLocation:otherLocation];
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
    renderer.lineWidth = 5.0;
    return renderer;
}


@end
