//
//  RecipeListModel.h
//  FITamin
//
//  Created by Holzner on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "JSONModel.h"

@protocol RecipeListModel

@end

@interface RecipeListModel : JSONModel

@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * f2f_url;
@property (nonatomic, retain) NSString * source_url;
@property (nonatomic, retain) NSString * recipe_id;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * social_rank;
@property (nonatomic, retain) NSString * publisher_url;
@property (nonatomic, retain) NSString * title;


@end
