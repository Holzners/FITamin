//
//  SearchModel.h
//  FITamin
//
//  Created by Holzner on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//
#import "JSONModel.h"
#import "RecipeListModel.h"

@interface SearchModel : JSONModel

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, strong) NSArray<RecipeListModel, Optional> * recipes;

@end
