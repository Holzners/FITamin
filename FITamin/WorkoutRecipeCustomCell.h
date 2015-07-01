//
//  WorkoutRecipeCustomCell.h
//  FITamin
//
//  Created by Julia Kinshofer on 01.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RateView.h>

@interface WorkoutRecipeCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *WorkoutRecipeImage;
@property (weak, nonatomic) IBOutlet RateView *WorkoutRecipeRating;
@property (weak, nonatomic) IBOutlet UILabel *WorkoutRecipeLabel;

@end
