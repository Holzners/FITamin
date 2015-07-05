//
//  Quicksort.m
//  FITamin
//
//  Created by admin on 05.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quicksort.h"

@implementation Quicksort: NSObject

+(void) quickSort:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort{
    if(left < right){
        NSInteger pivot;
        pivot = [self quickSortHelper:left withRight:right forArray:arrayToSort];
        [self quickSort:left withRight:(pivot-1) forArray:arrayToSort];
        [self quickSort:(pivot+1) withRight:right forArray:arrayToSort];
    }
}

+(NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort{
    
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