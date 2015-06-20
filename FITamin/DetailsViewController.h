//
//  DetailsViewController.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (strong, nonatomic) NSString *countryName;
@end
