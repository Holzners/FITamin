//
//  MapViewExerciseAnnotation.h
//  FITamin
//
//  Created by admin on 29.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewExerciseAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate AndNumber:(NSNumber *)number;
-(MKAnnotationView *)annotationView;
@end
