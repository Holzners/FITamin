//
//  DetailsViewController.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Zutat.h"
#import "CustomCell.h"


@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *zutatenName;

@property (weak, nonatomic) IBOutlet UIImageView *zutatenFoto;

@property (weak, nonatomic) IBOutlet UITextView *zutatenText;

@property (nonatomic, strong) Zutat *zutat;

@end
