//
//  RecipeApiController.h
//  FITamin
//
//  Created by Holzner on 27.06.15.
//
//Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//
#import "AFHTTPSessionManager.h"
#import "SearchModel.h"
#import "GetRequestModel.h"

typedef enum : NSUInteger {
    SortingByRating,
    SortingByTranding,
    SortingByNon
} SortingBy;

@interface RecipeApiController : AFHTTPSessionManager

+ (instancetype) instanceShared;

- (void) searchWithValue:(NSString*)text Page:(NSNumber*)page SortBy:(SortingBy)sortBy withBlock:(void (^)(SearchModel *response, NSError *error))block;

- (void) getReceipeWithID:(NSString*)rID withBlock:(void (^)(GetRequestModel *response, NSError *error))block;

@end
