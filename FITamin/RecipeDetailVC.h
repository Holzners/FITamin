//
//  RecipeDetailVC.h
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeModel.h"
#import <Parse/Parse.h>
#import "RecipeCustomCell.h"

@interface RecipeDetailVC : UIViewController

@property (strong, nonatomic) NSString *recipeName;

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@property (weak, nonatomic) IBOutlet UITextView *recipeText;

@property (strong, nonatomic) RecipeModel *recipe;

@end
