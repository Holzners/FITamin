//
//  DataHandlerTest.m
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "DataHandlerTest.h"

@implementation DataHandlerTest



+(NSString*)getFilePath
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsPath stringByAppendingPathComponent:@"data.plist"];
    //mit listArray einen anderen Pfad bauen -> es sucht im falschen Verzeichnis und holt sich somit das falsche File
    
}



+(void)createFile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:@"firstRun"]) {
        
        NSError *error = nil;
        
        NSString *filePath = [DataHandlerTest getFilePath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        
        [fileManager copyItemAtPath:defaultFilePath toPath:filePath error:&error];
        
        if (!error) {
            [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"firstRun"];
            [userDefaults synchronize];
        } else {
            NSLog(@"Fehler beim Erstellen der Plist aufgetreten: %@", error.localizedDescription);
        }
    }
}

+(NSArray *)loadData
{
    return [NSArray arrayWithContentsOfFile:[DataHandlerTest getFilePath]];
}

+(BOOL)saveData:(NSArray *)array
{
    if (![array writeToFile:[DataHandlerTest getFilePath] atomically:YES]) {
        return NO;
    }
    return YES;
}

@end
