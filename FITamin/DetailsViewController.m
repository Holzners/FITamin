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
    
    // Do any additional setup after loading the view.
//    PFObject *z1;
//    z1 = [self getZutat:self.zutatenName];
//    
//    if(z1!=NULL){
//        self.zutatenNameLabel.text = z1[@"title"];
     //   self.zutatImage = z1[@"image"];
//    }
    
   // self.zutatImage.image = self.zutatenImage2;
   // self.countryNameLabel.text = self.countryName;
    
    
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



-(PFObject  *)getZutat:(NSString *)name{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Zutaten"];
    [query whereKey:@"title" equalTo:name];
    PFObject *z1 = [query getFirstObject];

    return  z1;
}

/// Convert to JPEG with 50% quality
//NSData* data = UIImageJPEGRepresentation(imageView.image, 0.5f);
//PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
//
//// Save the image to Parse
//
//[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    if (!error) {
//        // The image has now been uploaded to Parse. Associate it with a new object
//        PFObject* newPhotoObject = [PFObject objectWithClassName:@"PhotoObject"];
//        [newPhotoObject setObject:imageFile forKey:@"image"];
//        
//        [newPhotoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//                NSLog(@"Saved");
//            }
//            else{
//                // Error
//                NSLog(@"Error: %@ %@", error, [error userInfo]);
//            }
//        }];
//    }
//}];
@end
