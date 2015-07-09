//
//  Datahandler.m
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "DataPlist.h"

@implementation DataPlist


+(NSString*)getFilePath
{
    //Pfad zu data.plist bauen
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsPath stringByAppendingPathComponent:@"data.plist"];
    
}



+(void)createFile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:@"firstRun"]) {
        
        NSError *error = nil;
        
        NSString *filePath = [DataPlist getFilePath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        
        [fileManager copyItemAtPath:defaultFilePath toPath:filePath error:&error];
        
        if (!error) {
            [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"firstRun"];
            [userDefaults synchronize];
        } else {
            NSLog(@"Fehler: %@", error.localizedDescription);
        }
    }
}

+(NSArray *)loadData
{
    return [NSArray arrayWithContentsOfFile:[DataPlist getFilePath]];
}

+(BOOL)saveData:(NSArray *)array
{
    if (![array writeToFile:[DataPlist getFilePath] atomically:YES]) {
        return NO;
    }
    return YES;
}

@end
