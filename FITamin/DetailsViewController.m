//
//  DetailsViewController.m
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "CustomCell.h"
#import "DetailsViewController.h"

@interface DetailsViewController()
@end

@implementation DetailsViewController


@synthesize zutatenFoto;
@synthesize zutatenText;
@synthesize zutat;


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
    
    self.title = zutat.zutatDetailName;
    self.zutatenFoto.image = [UIImage imageNamed:zutat.zutatDetailImage];
    
    self.zutatenText.text = zutat.zutatDetailText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setZutatenFoto:nil];
    [self setZutatenText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
