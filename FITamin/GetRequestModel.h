//
//  GetRequestModel.h
//  FITamin
//
//  Created by Holzner on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "RecipeModel.h"

@interface GetRequestModel : JSONModel

@property (nonatomic, retain) RecipeModel *recipe;

@end
