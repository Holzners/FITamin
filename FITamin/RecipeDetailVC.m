//
//  RecipeDetailVC.m
//  FITamin
//
//  Created by admin on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import "RecipeDetailVC.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import "RecipeCustomCell.h"

@interface RecipeDetailVC ()


@end

@implementation RecipeDetailVC


@synthesize recipeImage;
@synthesize recipeText;
@synthesize recipe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.recipe title];
  
    [self.recipeImage setImageWithURL:[NSURL URLWithString:[[self.recipe image_url] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] usingProgressView:nil];
    NSString * resultConditions = [[self.recipe ingredients] componentsJoinedByString:@"\n"];
    self.recipeName = [self.recipe title];
    self.recipeText.text = resultConditions;
     [recipeText sizeToFit];
    
    self.recipeImage.layer.shadowOffset = CGSizeMake(0, 3);
    self.recipeImage.layer.shadowRadius = 5.0;
    self.recipeImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.recipeImage.layer.shadowOpacity = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setRecipeImage:nil];
    [self setRecipeText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
