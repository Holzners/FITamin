//
//  StandortVC.m
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "StandortVC.h"
#import "UebungRouteVC.h"

@implementation StandortVC{
    NSMutableArray *locationPoints;
    NSMutableArray *locationDistances;
    CLLocation *currentLocation;
    CLLocation *targetLocation;
    Boolean isDataAvailable;
    NSMutableArray *locations;
}


-(void)viewDidLoad{
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    
    NSLog(@"Gewählte Muskelgruppe: %@" , self.selectedMuscleGroup);
    
    locations = [NSMutableArray arrayWithObjects:@"Englischer Garten", @"Olympiapark", @"Luitpoldpark", nil];
    //init Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    isDataAvailable = false;
    
    //set Coordinates for "Englischer Garten"
    CLLocation *location_ENGLISCHER_GARTEN = [[CLLocation alloc] initWithLatitude:48.149925 longitude:11.586658];
    //set Coordinates for "Olympiapark
    CLLocation *location_OLYMPIAPARK =[[CLLocation alloc] initWithLatitude:48.174394 longitude:11.559760];
    //Set Coordinates for Luitpoldpark
    CLLocation *location_LUITPOLDPARK =[[CLLocation alloc] initWithLatitude:48.172892 longitude:11.572442];
    
    locationPoints = [NSMutableArray arrayWithObjects: location_ENGLISCHER_GARTEN,location_OLYMPIAPARK,location_LUITPOLDPARK, nil];
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //set high accuracy cause each m matters ;)
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSLog(@"Start loading data  %d", DEBUG);
    if(_locationManager!=nil){
        [_locationManager startUpdatingLocation];
    }else{
        NSLog(@"Failed starting locations update %d", DEBUG);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %d", DEBUG);
    currentLocation = newLocation;
    
    locationDistances = [[NSMutableArray alloc] init];
    
    if (currentLocation != nil) {
        for(int i = 0 ; i < [locationPoints count] ; i++){
            
            CLLocationDistance distance = [self calculateDistanceToLocation:[locationPoints objectAtIndex:i]];
            NSNumber *distanceAsNumber = [[NSNumber alloc] initWithInt:distance];
            
            NSMutableDictionary *point =[[NSMutableDictionary alloc]init];
            
            [point setValue: [locations objectAtIndex:i] forKey:@"name"];
            [point setValue: distanceAsNumber forKey:@"distance"];
            [point setValue: [locationPoints objectAtIndex:i] forKey:@"location"];
            
            [locationDistances addObject:point];
            NSString *distanceString = [distanceAsNumber stringValue];
            NSLog(@"Distance: %@", distanceString);
        }
        
        [self sortByDistance:locationDistances];
        isDataAvailable = true;
        [self.tableView reloadData];
        [_locationManager stopUpdatingLocation];
    } else{
        NSLog(@"current Location = nil!");
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [locationDistances count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    
    NSMutableDictionary *dict = [locationDistances objectAtIndex:indexPath.row];
    
    NSString *string = [dict objectForKey:@"name"];
    
    NSNumber *dist = [dict objectForKey:@"distance"];
    
    NSString *stringDistance = [[dist stringValue] stringByAppendingString:@" meters"];
   
    NSString *textString = [[[string stringByAppendingString:@": liegt "] stringByAppendingString:stringDistance] stringByAppendingString:@" entfernt"];
    
    cell.textLabel.text = textString;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    targetLocation = [[locationDistances objectAtIndex:indexPath.row] objectForKey:@"location"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedLocation = cell.textLabel.text;
    
    [self performSegueWithIdentifier:@"standortVCToUebungRoute" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (self.selectedLocation != nil){
        UebungRouteVC *dest = [segue destinationViewController];
        dest.targetLocation = targetLocation;
        dest.currentLocation = currentLocation;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return @"Choose your Location";
}


- (CLLocationDistance) calculateDistanceToLocation:(CLLocation*)otherLocation{
    if(currentLocation!= nil){
        return[currentLocation distanceFromLocation:otherLocation];
    }else{
        [_locationManager startUpdatingLocation];
        return[currentLocation distanceFromLocation:otherLocation];
    }
}

-(void) getMinDistance:(NSMutableDictionary*)array{
 
    }
    

- (void) quickSort:(NSInteger)left withRight:(NSInteger)right{
    if(left < right){
        NSInteger pivot;
        pivot = [self quickSortHelper:left withRight:right];
        [self quickSort:left withRight:(pivot-1)];
        [self quickSort:(pivot+1) withRight:right];
    }
}

-(NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right{
    
    NSInteger i = left;
    NSInteger j = right-1;
    NSMutableDictionary *pivot = [locationDistances objectAtIndex:right];
    
    while(i < j){
    
        for(i = left ; i < right && ([[locationDistances objectAtIndex:i] objectForKey:@"distance"]<= [pivot objectForKey:@"distance"]); i++){
        
        }
        for(j = right-1 ; j > left && ([[locationDistances objectAtIndex:j] objectForKey:@"distance"]>= [pivot objectForKey:@"distance"]); j--){
        
        }
        if(i < j){
            NSMutableDictionary *tmp = [locationDistances objectAtIndex:i];
            
            [locationDistances setObject:[locationDistances objectAtIndex:j] atIndexedSubscript:i];
            [locationDistances setObject:tmp atIndexedSubscript:j];
        }
    }
    
    if ([[locationDistances objectAtIndex:i] objectForKey:@"distance"] > [pivot objectForKey:@"distance"]){
        NSMutableDictionary *tmp = [locationDistances objectAtIndex:i];
        
        [locationDistances setObject:[locationDistances objectAtIndex:right] atIndexedSubscript:i];
        [locationDistances setObject:tmp atIndexedSubscript:right];
        return i;
    }
    
    return right;
}

@end



