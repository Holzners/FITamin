//
//  RecipeApiController.m
//  FITamin
//
//  Created by Holzner on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "RecipeApiController.h"

#define baseUrlString @"http://food2fork.com/"

@implementation RecipeApiController

// Singleton
+ (instancetype)instanceShared{
    static RecipeApiController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[RecipeApiController alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
        controller.responseSerializer.acceptableContentTypes = [controller.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    return controller;
}

// Suchanfrage nach Such Parameter "searchValue"
- (void) searchWithValue:(NSString *)searchValue Page:(NSNumber *)page SortBy:(SortingBy)sortBy withBlock:(void (^)(SearchModel *, NSError *))block{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"716702179612f8c59d250f68d3cab5ea" forKey:@"key"];
    [parameter setValue:searchValue forKey:@"q"];
    switch (sortBy) {
        case SortingByRating:
            [parameter setValue:@"r" forKey:@"sort"];
            break;
        case SortingByTranding:
            [parameter setValue:@"t" forKey:@"sort"];
            break;
        case SortingByNon:
        default:
            break;
    }
    [parameter setValue:page forKey:@"page"];
    
    [[RecipeApiController instanceShared] POST:@"api/search/" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block([[SearchModel alloc] initWithDictionary:responseObject error:nil], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

// Get Request für ein bestimmtes Rezept
- (void)getReceipeWithID:(NSString *)rID withBlock:(void (^)(GetRequestModel *, NSError *))block{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:rID forKey:@"rId"];
    [parameter setValue:@"716702179612f8c59d250f68d3cab5ea" forKey:@"key"];
    
    [[RecipeApiController instanceShared] POST:@"api/get/" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block([[GetRequestModel alloc] initWithDictionary:responseObject error:nil], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}


@end
