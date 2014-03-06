//
//  checkPhotoController.h
//  DaysInLine
//
//  Created by 张力 on 14-2-9.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Frontia/Frontia.h>
#import <iAd/iAd.h>



@interface checkPhotoController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fullPhoto;
- (IBAction)backToEdit:(UIButton *)sender;


@property (strong, nonatomic) ADBannerView *adView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@end
