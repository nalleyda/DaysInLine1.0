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
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, 60)];
        
    }
    
    self.adView.delegate = self;
    [self.adView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.adView];
    

    
   // self.fullPhoto.backgroundColor = [UIColor blackColor];
    self.fullPhoto.ContentMode = UIViewContentModeScaleAspectFit;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    //  NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    //  NSLog(@"current appear tab title %@", cName);
    [[Frontia getStatistics] pageviewStartWithName:@"photoView"];
}

-(void) viewDidDisappear:(BOOL)animated
{
    // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    // NSLog(@"current disappear tab title %@", cName);
    [[Frontia getStatistics] pageviewEndWithName:@"photoView"];
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
