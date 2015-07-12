//
//  Datahandler.m
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "DataPlist.h"

@implementation DataPlist


+ (NSString*)getFilePath
{
    //Pfad zu data.plist bauen
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsPath stringByAppendingPathComponent:@"data.plist"];
    
}



+ (void)createFile
{
    //Speicherung in defaults-System, damit die Daten der Plist immer für die App verfügbar sind
    // Auch wenn App geschlossen wird, kann ich beim nächsten Öffnen wieder auf die Daten zugreifen
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //Ladet Plist beim ersten Öffnen
    if (![userDefaults objectForKey:@"erstesÖffnen"]) {
        
        NSError *error = nil;
        
        //Holt sich den Pfad
        NSString *filePath = [DataPlist getFilePath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        
        [fileManager copyItemAtPath:defaultFilePath toPath:filePath error:&error];
        
        if (!error) {
            [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"erstesÖffnen"];
            [userDefaults synchronize];
        } else {
            NSLog(@"Fehler wurde erkannt: %@", error.localizedDescription);
        }
    }
}


//Daten werden aus Plist geladen
+ (NSArray *)loadData
{
    return [NSArray arrayWithContentsOfFile:[DataPlist getFilePath]];
}

//Daten werden gespeichert
+ (BOOL)saveData:(NSArray *)array
{
    if (![array writeToFile:[DataPlist getFilePath] atomically:YES]) {
        return NO;
    }
    return YES;
}

@end
