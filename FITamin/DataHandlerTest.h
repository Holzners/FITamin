//
//  DataHandlerTest.h
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandlerTest : NSObject
+(void)createFile;
+(NSArray *)loadData;
+(BOOL)saveData:(NSArray *)array;

@end
