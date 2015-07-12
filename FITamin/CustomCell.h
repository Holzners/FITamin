//
//  CustomCellTableViewCell.h
//  FITamin
//
//  Created by admin on 20.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>


//Custom Cell für genaueres Design der Tabelle
//XiB File

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zutatenImageView;
@property (weak, nonatomic) IBOutlet UILabel *zutatenNameLabel;

@end
