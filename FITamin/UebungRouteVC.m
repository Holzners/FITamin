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
    NSString *workoutFinished;
    
}

@synthesize targetReached;

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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(workoutFinished){
        [self performSegueWithIdentifier:workoutFinished sender:self];
        NSLog(@"ID %@", workoutFinished);
        workoutFinished = nil;
        
        // return;
    }
    
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








#pragma mark - CLLocationManagerDelegate

//called for each location update Location Manager receives
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    _currentLocation = newLocation;
    
    //Wurden Distances initial schon berechnet??
    if(distancesCalculated){
        
        //Distanzen wurden berechnet, jetzt nur noch dieser Fall
        NSLog(@"didUpdateToLocation: %@", newLocation);
        
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
        
    }
    else{
        
        //Setze Fokus auf aktuellen Standort
        CLLocationCoordinate2D zoomLocation;
        zoomLocation =_currentLocation.coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                           0.5*5000, 0.5*5000);
        [_mapView setRegion:viewRegion animated:YES];

        //Die Route wurde noch nicht berechnet
        [self calculateInitialRoute];
        // falls keine übungen gefunden werden gibts hier ne NPE
        
        //Das heißt die Route wurde berechnet, setze erstes Target an Stelle 0 im Location array
        if([self.selectedLocationsWithDistancesAndExercises count]>0){
        _targetLocation = [[self.selectedLocationsWithDistancesAndExercises objectAtIndex:0]objectForKey:@"location"];
            
            [self calculateRouteFromCurrentToDestination:_targetLocation];

        }
        
                [_mapView addAnnotations:[self createAnnotations:self.selectedLocationsWithDistancesAndExercises]];
        distancesCalculated = true;
        
        }
    
}


-(void) calculateInitialRoute{
    
    //Die Distanzen müssen berechnet werden
    self.selectedLocationsWithDistancesAndExercises = [[NSMutableArray alloc]init];
    
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
            [point setObject:[[NSNumber alloc] initWithInt:i+1] forKey:@"number"];
            [tmpLocationDistances addObject:point];
            
        }
        
        //Finde Minimum Distanz aller Locations (tmpLocationDistance ist Array von Dictionarys)
        
        
        NSLog(@"Next Distances: %d" , i);
        for(NSMutableDictionary *dict in tmpLocationDistances){
            NSNumber *dist = [dict objectForKey:@"distance"];
            NSLog(@"Distance: %@" , dist);
        }
        
        
        //Füge jetzt diese Location zu Location-Exercise Array hinzu
        [self.selectedLocationsWithDistancesAndExercises addObject:[
            tmpLocationDistances objectAtIndex:[self getMinDistanceIndex:tmpLocationDistances]]];
        
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
    
}

- (NSInteger) getMinDistanceIndex : (NSMutableArray*) array{
    NSInteger result = 0;
    NSNumber *maxVal = [NSNumber numberWithInt:INT16_MAX];
   
    for(NSMutableDictionary *dict in array){
        if([dict objectForKey:@"distance"] < maxVal){
            maxVal = [dict objectForKey:@"distance"];
            result = [array indexOfObject:dict];
        }
    }
    return result;
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
    //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:(destinationLocation.coordinate) addressDictionary:nil];
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
    //[self quickSort:0 withRight:(arrayToSort.count-1) forArray:arrayToSort];
    [Quicksort quickSort:0 withRight:(arrayToSort.count-1) forArray:arrayToSort];
    
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

//This method is used to create cutom annotations for
// our locations
- (NSMutableArray *)createAnnotations:(NSArray *)locations{
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row in locations) {
        
        PFObject *exercise = [row objectForKey:@"exercise"];
        CLLocation *pfObj = [row objectForKey:@"location"];
        NSNumber *number = [row objectForKey:@"number"];
        
        //Create coordinates from the latitude and longitude values
        MapViewExerciseAnnotation *annotation = [[MapViewExerciseAnnotation alloc]initWithTitle:exercise[@"title"] AndCoordinate:pfObj.coordinate AndNumber:number];
        
        [annotations addObject:annotation];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"mapToDescription"]){
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if (self.exercises != nil){
            UebungAnleitungVC *dest = [segue destinationViewController];
            dest.currentExercise = [_exercises objectAtIndex:_currentExercise];
        
        }
    }
    else{
        NSLog(@"Segue performed %@",segue.identifier);
    }
    
}

-(IBAction)simulateTargetReached:(id)sender {
    //Get next Location
    
    
    if(_currentExercise >= [_exercises count]){
         [self performSegueWithIdentifier:@"workoutFinished" sender:self];
    }
    else {
        _currentLocation = [self.selectedLocationsWithDistancesAndExercises objectAtIndex:_currentExercise];
        [self performSegueWithIdentifier:@"mapToDescription" sender:self];
    }
    
    
}

-(IBAction)unwindToUebungRouteVC:(UIStoryboardSegue *)unwindSegue{
    
    _currentExercise += 1;
    
    
    if(_currentExercise >= [_exercises count]){
  //      unwindSegue.destinationViewController;
        workoutFinished = @"workoutFinished";
        [self.locationManager stopUpdatingLocation];
    //    [targetReached setAlpha:0];
    }else{
    
       /** UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workout Finished" message:[NSString stringWithFormat:@"%@", @"Well Done"] delegate:nil cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
        [alert show]; */
     UIViewController* sourceViewController = unwindSegue.sourceViewController;
    [_locationManager startUpdatingLocation];
    
    if ([sourceViewController isKindOfClass:[UebungAnleitungVC class]])
    {
        NSLog(@"Coming from UebungAnleitungVC!");
    }
    }
}
@end
