//
//  Datahandler.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPlist : NSObject


//müssen public sein, da es private nicht akzeptiert

//Methoden zum Plist File erstellen, laden und speichern
//Speicherung, damit ich immer darauf zugreifen kann

+ (void)createFile;

+ (NSArray *)loadData;

+ (BOOL)saveData:(NSArray *)array;

@end
