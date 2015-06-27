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
    
    self.title = recipe.recipeDetailName;
    self.recipeImage.image = [UIImage imageNamed:recipe.recipeDetailImage];
    
    self.recipeText.text = recipe.recipeDetailText;
    
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
