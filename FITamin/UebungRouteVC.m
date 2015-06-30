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
#import "MapViewExerciseAnnotation.h"

@import CoreLocation;

@interface UebungRouteVC ()

@end

@implementation UebungRouteVC {
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
                               initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@/%@",@"Failed to Get Your Location", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (self.exercises != nil){
        UebungAnleitungVC *dest = [segue destinationViewController];
        dest.currentExercise = [_exercises objectAtIndex:_currentExercise];
        
        
    }
    
}


- (NSMutableArray *)createAnnotations:(NSArray *)locations{

    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    //Read locations details from plist
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@”locations” ofType:@”plist”];
    
    //NSArray *locations = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *row in locations) {
        
        //NSNumber *latitude = [row objectForKey:@"latitude"];
        
        //NSNumber *longitude = [row objectForKey:@"longitude"];
        
        //NSString *title = [row objectForKey:@"title"];
        
        PFObject *exercise = [row objectForKey:@"exercise"];
        CLLocation *pfObj = [row objectForKey:@"location"];

        //Create coordinates from the latitude and longitude values
        MapViewExerciseAnnotation *annotation = [[MapViewExerciseAnnotation alloc]initWithTitle:exercise[@"title"] AndCoordinate:pfObj.coordinate];
        //[annotation setCoordinate:pfObj.coordinate];
        
        [annotations addObject:annotation];
    }
    return annotations;
}


#pragma mark - CLLocationManagerDelegate

//called for each location update Location Manager receives
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //Wurden Distances initial schon berechnet??
    if(distancesCalculated){
        
        //Distanzen wurden berechnet, jetzt nur noch dieser Fall
        NSLog(@"didUpdateToLocation: %@", newLocation);
        
        _currentLocation = newLocation;
        
        if (_currentLocation != nil) {
        
            if (_targetLocation != nil) {
                CLLocationDistance distanceToTarget =[self calculateDistanceToLocation:_targetLocation];
                if([NSNumber numberWithDouble:distanceToTarget].doubleValue < 15){
                    [_locationManager stopUpdatingLocation];
                    [self performSegueWithIdentifier:@"mapToDescription" sender:self];
                }
            }
        } else{
            NSLog(@"current Location = nil!");
        }
        
    }else{
        
        //Die Distanzen müssen berechnet werden
        _currentLocation = newLocation;
        self.selectedLocationsWithDistancesAndExercises = [[NSMutableArray alloc]init];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation =_currentLocation.coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                           0.5*5000, 0.5*5000);
        [_mapView setRegion:viewRegion animated:YES];
        
        PFGeoPoint *tmpCurrentLoc = [PFGeoPoint geoPointWithLocation:_currentLocation];
        
        //Gehe alle Exercises durch und hole eine Location für diese Exercise
        for(int i = 0 ; i < [_exercises count] ; i++){
            
            PFQuery *query;
            query = [PFQuery queryWithClassName:@"Location"];
            [query whereKey:@"exercises" equalTo:[_exercises objectAtIndex:i]];
        
            NSArray *locationsFromQuery = [query findObjects];
            NSMutableArray *tmpLocationDistances = [[NSMutableArray alloc] init];
            
            //Es werden alle Locations angefordert die auf diese Exercise verweisen
            //jetzt wählen wir die Exercise mit minimaler Diatanz zum aktuellen Standpunkt
            for (PFObject *p in locationsFromQuery){
                
                PFGeoPoint *target = p[@"location"];
                double distanceToCurrent = [target distanceInKilometersTo:tmpCurrentLoc];
                CLLocation *tmpTarget = [[CLLocation alloc]initWithLatitude:target.latitude longitude:target.longitude];
                
                //Hier wird ein Dictionary erstellt, das eine Location repräsentieren soll: location + exercise + Distanz zu Standpunkt
                NSMutableDictionary *point = [[NSMutableDictionary alloc] init];
                [point setObject:tmpTarget forKey:@"location"];
                [point setObject:[_exercises objectAtIndex:i] forKey:@"exercise"];
                [point setObject:[[NSNumber alloc] initWithDouble:distanceToCurrent] forKey:@"distance"];
                [tmpLocationDistances addObject:point];
                
            }
            
            //Finde Minimum Distanz aller Locations (tmpLocationDistance ist Array von Dictionarys)
            [self sortByDistance:tmpLocationDistances];
            
            NSLog(@"Next Distances: %d" , i);
            for(NSMutableDictionary *dict in tmpLocationDistances){
                NSNumber *dist = [dict objectForKey:@"distance"];
                NSLog(@"Distance: %@" , dist);
            }
            
            
            //NSMutableDictionary *listEntry = [[NSMutableDictionary alloc]init];
            //[listEntry setDictionary:[tmpLocationDistances firstObject]];
            
            //Füge jetzt diese Location zu Location-Exercise Array hinzu
            [self.selectedLocationsWithDistancesAndExercises addObject:[tmpLocationDistances firstObject]];
            
            //Setze current Location auf den aktuellen berechneten Punkt um weiter zu rechnen
            tmpCurrentLoc = [PFGeoPoint geoPointWithLocation:[[tmpLocationDistances firstObject] objectForKey:@"location"]];
            
        }
        
        //Loggin für alle gefundenen Locations
        for (NSMutableDictionary *entry in _selectedLocationsWithDistancesAndExercises){
            PFObject *pfObj = [entry objectForKey:@"exercise"];
            NSNumber *dist = [entry objectForKey:@"distance"];
            NSLog(@"Übung Name: %@" , pfObj[@"title"]);
            NSLog(@"Distanz zur vorherigen %@" , dist);
        }
        
        _targetLocation = [[self.selectedLocationsWithDistancesAndExercises objectAtIndex:0]objectForKey:@"location"];
        [self calculateRouteFromCurrentToDestination:_targetLocation];
        [_mapView addAnnotations:[self createAnnotations:self.selectedLocationsWithDistancesAndExercises]];
        distancesCalculated = true;
        
    }
}


//calculates Distance beetween currentLocation and otherLocation
-(CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation{
    if(_currentLocation!= nil){
        return[_currentLocation distanceFromLocation:otherLocation];
    }else{
        [_locationManager startUpdatingLocation];
        return[_currentLocation distanceFromLocation:otherLocation];
    }
}

//start calculating route from current location to destination
-(void) calculateRouteFromCurrentToDestination:(CLLocation * )destinationLocation{
    
    //Convert CLLocation to MKMapItem
    MKMapItem *src = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:(destinationLocation.coordinate) addressDictionary:nil];
    //MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    for (NSMutableDictionary *entry in _selectedLocationsWithDistancesAndExercises){
        
        CLLocation *pfObj = [entry objectForKey:@"location"];
        MKPlacemark *placemarkl1 = [[MKPlacemark alloc] initWithCoordinate:(pfObj.coordinate) addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemarkl1];
        
    //Init MKDirectionRequest
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //Set requests transport type to walk
    [request setTransportType:MKDirectionsTransportTypeWalking];
    //start = currentLocation
        request.source = src;
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
     
        src = destination;
    }
    
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
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

-(void) sortByDistance:(NSMutableArray*)arrayToSort{
    [self quickSort:0 withRight:(arrayToSort.count-1) forArray:arrayToSort];
    
}

-(void) quickSort:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort{
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

-(IBAction)simulateTargetReached:(id)sender {
    
//    NSArray *coords;
//    CLLocation *dest = [[CLLocation alloc]initWithLatitude:48.165013 longitude:11.601947];
//    coords = [NSArray arrayWithObjects: dest, nil];
    // [self locationManager:_locationManager  :coords];
    
    
    [_locationManager stopUpdatingLocation];
    [self performSegueWithIdentifier:@"mapToDescription" sender:self];

}

-(IBAction) nextView:(id)sender{
    [_locationManager stopUpdatingLocation];
    [self performSegueWithIdentifier:@"mapToDescription" sender:self];
}

-(IBAction)unwindToUebungRouteVC:(UIStoryboardSegue *)unwindSegue{
    
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    [_locationManager startUpdatingLocation];
    
    if ([sourceViewController isKindOfClass:[UebungAnleitungVC class]])
    {
        NSLog(@"Coming from UebungAnleitungVC!");
    }

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MapViewExerciseAnnotation class]]){
        
        MapViewExerciseAnnotation *myLocation = (MapViewExerciseAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapViewExerciseAnnotation"];
        
        if(annotation == nil){
            annotationView = myLocation.annotationView;
        }
        else{
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else {
        return nil;
    }
}

@end
