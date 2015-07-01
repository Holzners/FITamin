//
//  WorkoutRecipesTableTableViewController.h
//  FITamin
//
//  Created by Julia Kinshofer on 01.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import <MBProgressHUD.h>

@interface WorkoutRecipesTableTableViewController : UITableViewController {
    MBProgressHUD *HUD;
}

@property(strong, nonatomic)SearchModel *searchSummary;

@end
