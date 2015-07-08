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


@interface RecipeTableViewController : UITableViewController {
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;

@property(strong, nonatomic)SearchModel *searchSummary;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end