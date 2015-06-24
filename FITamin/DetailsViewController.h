//
//  DetailsViewController.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *zutatenNameLabel;
@property (strong, nonatomic) NSString *zutatenName;
@property (strong , nonatomic) NSMutableArray *zutatenDetails;
@property (weak, nonatomic) IBOutlet UIImageView *zutatImage;


-(PFObject *) getZutat:(NSString *)name;

@end
