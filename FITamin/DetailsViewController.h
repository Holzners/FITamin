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

//@property (weak, nonatomic) IBOutlet UILabel *zutatenNameLabel;
@property (strong, nonatomic) NSString *zutatenName;
//@property (strong , nonatomic) NSMutableArray *zutatenDetails;

@property (weak, nonatomic) IBOutlet UIImageView *zutatenFoto;

@property (weak, nonatomic) IBOutlet UITextView *zutatenText;

@property (nonatomic, strong) Zutat *zutat;

-(PFObject *) getZutat:(NSString *)name;

@end
