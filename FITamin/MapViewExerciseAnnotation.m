//
//  MapViewExerciseAnnotation.m
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "MapViewExerciseAnnotation.h"

@implementation MapViewExerciseAnnotation

@synthesize coordinate=_coordinate;

@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate AndNumber:(NSNumber *) number
{
    self = [super init];
    _title = [NSString stringWithFormat:@"%d %@", [number intValue], title];
    _coordinate = coordinate;
    return self;
}

-(MKAnnotationView *)annotationView{
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapViewExerciseAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"erdbeere.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}

@end
