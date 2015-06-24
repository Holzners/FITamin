//
//  UebungRouteVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "UebungRouteVC.h"
#import "UebungAnleitungVC.h"
#import <Parse/Parse.h>
@import CoreLocation;

@interface UebungRouteVC ()

@end

@implementation UebungRouteVC{
    NSMutableArray *locationPoints;
    NSMutableArray *locationDistances;
    Boolean distancesCalculated;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    distancesCalculated = false;
    
    //init Location Manager
    _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
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
    if(distancesCalculated){
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
        
    }else{
        
        _currentLocation = newLocation;
        self.selectedLocationsWithDistancesAndExercises = [[NSMutableArray alloc]init];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation =_currentLocation.coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                           0.5*5000, 0.5*5000);
        [_mapView setRegion:viewRegion animated:YES];
        
        PFGeoPoint *tmpCurrentLoc
        = [PFGeoPoint geoPointWithLocation:_currentLocation];
        
        for(int i = 0 ; i < [_excersices count] ; i++){
            
            PFQuery *query;
            query = [PFQuery queryWithClassName:@"Location"];
            [query whereKey:@"exercises" equalTo:[_excersices objectAtIndex:i]];
        
            NSArray *locationsFromQuery = [query findObjects];
            NSMutableArray *tmpLocationDistances = [[NSMutableArray alloc] init];
            
            for (PFObject *p in locationsFromQuery){
                
                PFGeoPoint *target = p[@"location"];
                double distanceToCurrent = [target distanceInKilometersTo:tmpCurrentLoc];
                CLLocation *tmpTarget = [[CLLocation alloc]initWithLatitude:target.latitude longitude:target.longitude];
                NSMutableDictionary *point = [[NSMutableDictionary alloc] init];
                [point setObject:tmpTarget forKey:@"location"];
                [point setObject:[_excersices objectAtIndex:i] forKey:@"exercise"];
                [point setObject:[[NSNumber alloc] initWithDouble:distanceToCurrent] forKey:@"distance"];
                [tmpLocationDistances addObject:point];
                
            }
            [self sortByDistance:tmpLocationDistances];
            
            NSLog(@"Next Distances: %d" , i);
            for(NSMutableDictionary *dict in tmpLocationDistances){
                NSNumber *dist = [dict objectForKey:@"distance"];
                NSLog(@"Distance: %@" , dist);
            }
            
            
            NSMutableDictionary *listEntry = [[NSMutableDictionary alloc]init];
            [listEntry setDictionary:[tmpLocationDistances firstObject]];
            
            [self.selectedLocationsWithDistancesAndExercises addObject:listEntry];
            tmpCurrentLoc = [PFGeoPoint geoPointWithLocation:[listEntry objectForKey:@"location"]];
            
        }
        for (NSMutableDictionary *entry in _selectedLocationsWithDistancesAndExercises){
            PFObject *pfObj = [entry objectForKey:@"exercise"];
            NSNumber *dist = [entry objectForKey:@"distance"];
            NSLog(@"Übung Name: %@" , pfObj[@"title"]);
            NSLog(@"Distanz zur vorherigen %@" , dist);
        }
        _targetLocation = [[self.selectedLocationsWithDistancesAndExercises objectAtIndex:0]objectForKey:@"location"];
        [self calculateRouteFromCurrentToDestination:_targetLocation];
        distancesCalculated = true;
        
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

-(void) sortByDistance:(NSMutableArray*)arrayToSort{
    [self quickSort:0 withRight:(arrayToSort.count-1) forArray:arrayToSort];
    
}

- (void) quickSort:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort{
    if(left < right){
        NSInteger pivot;
        pivot = [self quickSortHelper:left withRight:right forArray:arrayToSort];
        [self quickSort:left withRight:(pivot-1) forArray:arrayToSort];
        [self quickSort:(pivot+1) withRight:right forArray:arrayToSort];
    }
}

-(NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort{
    
    NSInteger i = left;
    NSInteger j = right-1;
    NSMutableDictionary *pivot = [arrayToSort objectAtIndex:right];
    
    while(i < j){
        
        for(i = left ; i < right && ([[arrayToSort objectAtIndex:i] objectForKey:@"distance"]<= [pivot objectForKey:@"distance"]); i++){
            
        }
        for(j = right-1 ; j > left && ([[arrayToSort objectAtIndex:j] objectForKey:@"distance"]>= [pivot objectForKey:@"distance"]); j--){
            
        }
        if(i < j){
            NSMutableDictionary *tmp = [arrayToSort objectAtIndex:i];
            
            [arrayToSort setObject:[arrayToSort objectAtIndex:j] atIndexedSubscript:i];
            [arrayToSort setObject:tmp atIndexedSubscript:j];
        }
    }
    
    if ([[arrayToSort objectAtIndex:i] objectForKey:@"distance"] > [pivot objectForKey:@"distance"]){
        NSMutableDictionary *tmp = [arrayToSort objectAtIndex:i];
        
        [arrayToSort setObject:[arrayToSort objectAtIndex:right] atIndexedSubscript:i];
        [arrayToSort setObject:tmp atIndexedSubscript:right];
        return i;
    }
    
    return right;
}

@end
