//
//  selectView.h
//  DaysInLine
//
//  Created by 张力 on 14-1-4.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@interface selectView : UIView
@property (strong ,nonatomic) CKCalendarView *calendar ;
@property (strong ,nonatomic) UITableView *eventsTable;
@property (strong ,nonatomic) UITableView *alltagTable;
@property (strong ,nonatomic) UITableView *eventInTagTable;
@property (strong ,nonatomic)  UISegmentedControl *selectMode;

@property (strong,nonatomic) UIView *dateView;
@property (strong,nonatomic) UIView *tagView;
@property (strong,nonatomic) UIButton *goInThatDay;
@property (strong,nonatomic) UIButton *returnToTags;

@end
