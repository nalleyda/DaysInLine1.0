//
//  settingView.h
//  DaysInLine
//
//  Created by 张力 on 14-2-23.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"

@interface settingView : UIView

@property (strong , nonatomic) SevenSwitch *soundSwitch ;
//@property (strong , nonatomic) SevenSwitch *icloudSwitch ;
@property (strong , nonatomic) SevenSwitch *daySwitch ;
@property (strong , nonatomic) UITableView *settingTable;
@end
