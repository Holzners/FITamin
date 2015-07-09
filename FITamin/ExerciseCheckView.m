//
//  ExerciseCheckView.m
//  FITamin
//
//  Created by admin on 01.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseCheckView.h"

@implementation ExerciseCheckView

@synthesize intNumberOfSets;
@synthesize intCurrentSet;
@synthesize colors;

-(void)drawRect:(CGRect)rect {
    
    //Dieser View soll die Sets repräsentieren und erzeugt dynamisch Kreise für jedes Set
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    
    CGPoint firstCircleCenter = CGPointMake(bounds.origin.x + bounds.size.width/(intNumberOfSets+1),
                bounds.origin.y + bounds.size.height/2);
    
    float radius = hypot(bounds.size.width, bounds.size.height) / 15.0;
    
    CGContextSetLineWidth(ctx, 5);
    
    
    //für jedes Set wird jetzt ein Kreis zur View hinzugefügt
    for(int i = 0; i< intNumberOfSets; i++){
        
        //Die Farbe für den Circle ist in dem 2-Dim Array Colors enthalten das von UebungAnleitungVC gefüllt wird
     //   CGContextSetRGBFillColor(ctx, [[[colors objectAtIndex:i] objectAtIndex:0] doubleValue], [[[colors objectAtIndex:i] objectAtIndex:1] doubleValue], [[[colors objectAtIndex:i] objectAtIndex:2] doubleValue], 1.0);
        
        CGContextAddArc(ctx, firstCircleCenter.x+(i*(bounds.size.width/(intNumberOfSets+1))), firstCircleCenter.y, radius, 0.0, M_PI * 2.0, YES);
        
        if(i < intCurrentSet){
            //Die Farbe für den Circle ist in dem 2-Dim Array Colors enthalten das von UebungAnleitungVC gefüllt wird
             CGContextSetRGBFillColor(ctx, [[[colors objectAtIndex:i] objectAtIndex:0] doubleValue], [[[colors objectAtIndex:i] objectAtIndex:1] doubleValue], [[[colors objectAtIndex:i] objectAtIndex:2] doubleValue], 1);
            //CGContextSetRGBFillColor(ctx, 1,0,0,1);
            CGContextFillPath(ctx);

        }
        
        CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
        CGContextStrokePath(ctx);
        
    }
    
    
    
}

@end
