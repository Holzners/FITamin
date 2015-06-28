//
//  RecipeTableViewController.h
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import <MBProgressHUD.h>


@interface RecipeTableViewController : UITableViewController{
    MBProgressHUD *HUD;
}

@property(weak, nonatomic)SearchModel *searchSummary;

@end