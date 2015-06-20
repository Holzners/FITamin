//
//  MuskelgruppeVC.h
//  FITamin
//
//  Created by admin on 13.06.15.
//  Copyright (c) 2015 iOS-Praktikum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MuskelgruppeVC : UIViewController{
    
    __weak IBOutlet UIImageView *batman;
    __weak IBOutlet UIButton *turnButton;

}
@property (weak, nonatomic) IBOutlet UIButton *turnButton;
@property (weak, nonatomic) IBOutlet UIImageView *batman;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak , nonatomic) NSString *selectedMuscleGroup;
- (IBAction)chooseArms:(id)sender;

@end
