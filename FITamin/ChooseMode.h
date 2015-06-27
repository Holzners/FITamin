//
//  ChooseMode.h
//  FITamin
//
//  Created by Julia Kinshofer on 27.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMode : UIViewController{
    __weak IBOutlet UIImageView *modeImage;
}
@property (weak, nonatomic) IBOutlet UIButton *muscleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slimButton;
@property (weak, nonatomic) IBOutlet UIImageView *modeImage;

@end
