//
//  WorkoutRecipeCustomCell.m
//  FITamin
//
//  Created by Julia Kinshofer on 01.07.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "WorkoutRecipeCustomCell.h"

@implementation WorkoutRecipeCustomCell

- (void)awakeFromNib {
    self.WorkoutRecipeRating.starFillColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
