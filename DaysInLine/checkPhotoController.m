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
    self.fullPhoto.backgroundColor = [UIColor blackColor];
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
