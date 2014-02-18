//
//  checkPhotoController.m
//  DaysInLine
//
//  Created by 张力 on 14-2-9.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "checkPhotoController.h"

@interface checkPhotoController ()

@end

@implementation checkPhotoController

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
    // Do any additional setup after loading the view from its nib.
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [backImage setImage:[UIImage imageNamed:@"照片背景.png"]];
    
    [self.view addSubview:backImage];
    [self.view sendSubviewToBack:backImage];
    
    
   // self.fullPhoto.backgroundColor = [UIColor blackColor];
    self.fullPhoto.ContentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToEdit:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
