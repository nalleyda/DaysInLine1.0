//
//  checkPhotoController.h
//  DaysInLine
//
//  Created by 张力 on 14-2-9.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Frontia/Frontia.h>

@interface checkPhotoController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fullPhoto;
- (IBAction)backToEdit:(UIButton *)sender;

@end
