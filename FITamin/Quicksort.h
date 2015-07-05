//
//  Quicksort.h
//  FITamin
//
//  Created by admin on 05.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quicksort : NSObject {

}
    +(void) quickSort:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort;
    
    +(NSInteger) quickSortHelper:(NSInteger)left withRight:(NSInteger)right forArray:(NSMutableArray*)arrayToSort;
    
@end
