//
//  Datahandler.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datahandler : NSObject
+(void)createFile;
+(NSArray *)loadData;
+(BOOL)saveData:(NSArray *)array;
@end
