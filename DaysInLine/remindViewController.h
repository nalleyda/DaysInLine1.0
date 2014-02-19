//
//  remindViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-12-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remindDataDelegate.h"

@interface remindViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *remindMode;

@property (strong, nonatomic)  UIButton *returnButton;
@property (strong, nonatomic)  UIButton *okButton;

@property (strong, nonatomic) NSString *remindDate;
@property (strong, nonatomic) NSString *remindTime;

@property (weak, nonatomic) NSObject <remindDataDelegate> *setRemindDelegate;
@end
