//
//  rightTranslate.m
//  DaysInLine
//
//  Created by 张力 on 14-3-15.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "rightTranslate.h"

@implementation rightTranslate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int y = 0;
    int height = 0;
    if (screenBounds.size.height == 568) {
        y += 17;
        
        
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        height-=5;
     }
    UIButton *todayTanslate = [[UIButton alloc] initWithFrame:CGRectMake(10, 48+2*y+height, 217, 50)];
    [todayTanslate setUserInteractionEnabled:NO];
    [todayTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [todayTanslate setTitle:@"掌控自我，一切从今天开始" forState:UIControlStateNormal];
    [todayTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    todayTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:todayTanslate];
    
    UIButton *selectTanslate = [[UIButton alloc] initWithFrame:CGRectMake(10, 121+3*y+height, 217, 50)];
    [selectTanslate setUserInteractionEnabled:NO];
    [selectTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [selectTanslate setTitle:@"多角度精准定位每条记录" forState:UIControlStateNormal];
    [selectTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:selectTanslate];
    
    UIButton *collectTanslate = [[UIButton alloc] initWithFrame:CGRectMake(10, 194+4*y+height, 217, 50)];
    [collectTanslate setUserInteractionEnabled:NO];
    [collectTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [collectTanslate setTitle:@"收录重点事项，支持加密功能" forState:UIControlStateNormal];
    [collectTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    collectTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:collectTanslate];

    UIButton *analyseTanslate = [[UIButton alloc] initWithFrame:CGRectMake(10, 267+5*y+height, 217, 50)];
    [analyseTanslate setUserInteractionEnabled:NO];
    [analyseTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [analyseTanslate setTitle:@"根据所选时段，统计各项数据" forState:UIControlStateNormal];
    [analyseTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    analyseTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:analyseTanslate];
    
    UIButton *settingTanslate = [[UIButton alloc] initWithFrame:CGRectMake(10, 340+6*y+height, 217, 50)];
    [settingTanslate setUserInteractionEnabled:NO];
    [settingTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [settingTanslate setTitle:@"声音、加密、教程及反馈" forState:UIControlStateNormal];
    [settingTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    settingTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:settingTanslate];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
