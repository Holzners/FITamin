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
@synthesize colors;

-(void)drawRect:(CGRect)rect {
    
    //für jede Repetition wird jetzt ein Kreis zur View hinzugefügt
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    
    CGPoint firstCircleCenter = CGPointMake(bounds.origin.x + bounds.size.width/(intNumberOfSets+1),
                bounds.origin.y + bounds.size.height/2);
    
    float radius = hypot(bounds.size.width, bounds.size.height) / 12.0;
    
    CGContextSetLineWidth(ctx, 5);
    
    CGContextSetRGBStrokeColor(ctx, 0.3, 0.3, 0.3, 1.0);
    
    
    for(int i = 0; i< intNumberOfSets; i++){
        
        CGContextSetRGBFillColor(ctx, 0.0, [[colors objectAtIndex:i] doubleValue], 0.0, 1.0);
        
        CGContextAddArc(ctx, firstCircleCenter.x+(i*(bounds.size.width/(intNumberOfSets+1))), firstCircleCenter.y, radius, 0.0, M_PI * 2.0, YES);
        
        CGContextFillPath(ctx);
        
        CGContextStrokePath(ctx);
        
    }
    
    
    
}

@end
