//
//  buttonTranslate.m
//  DaysInLine
//
//  Created by 张力 on 14-3-14.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "buttonTranslate.h"

@implementation buttonTranslate

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
        y += 30;
        height +=15;
        
        
    }
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"add.png",@"searchInAlert.png",@"tagBtn.png",@"remindBtn.png",@"photoBtn.png",@"moneyBtn.png",@"collectionBtn.png",@"saveBtn.png",@"deleteBtn.png",@"returnBtn.png",nil];
    NSArray *meanningLable = [NSArray arrayWithObjects:@"添加事项",@"查看照片",@"添加标签",@"设定提醒",@"附加照片",@"收支管理",@"收藏事项",@"保存事项",@"删除事项",@"返回上级",nil];

    
    for (int i = 0; i<5; i++) {
        //按钮图片
        UIImageView *buttonImageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+50+65*i+y+height*i, 35, 35)];
        buttonImageLeft.image = [UIImage imageNamed:((NSString *)imageNames[2*i])];
        UIImageView *buttonImageRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2+12, self.frame.origin.y+50+65*i+y+height*i, 35, 35)];
        buttonImageRight.image = [UIImage imageNamed:((NSString *)imageNames[2*i+1])];
        
        //解释
        UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(50, self.frame.origin.y+50+65*i+y+height*i, 60, 35)];
        labelLeft.text = (NSString *)meanningLable[2*i];
        UILabel *labelRight =[ [UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2+52, self.frame.origin.y+50+65*i+y+height*i, 60, 35)];
        labelRight.text = (NSString *)meanningLable[2*i+1];
        
        labelLeft.font = [UIFont systemFontOfSize:14.0f];
        labelRight.font = [UIFont systemFontOfSize:14.0f];
        
        labelLeft.textColor = [UIColor darkGrayColor];
        labelRight.textColor = [UIColor darkGrayColor];

        labelLeft.backgroundColor = [UIColor clearColor];
        labelRight.backgroundColor = [UIColor clearColor];
        

        NSLog(@"height:%d",height);
        
        [self addSubview:buttonImageLeft];
        [self addSubview:buttonImageRight];
        [self addSubview:labelLeft];
        [self addSubview:labelRight];

        
    }
    
    self.returnToSetting = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-35, self.frame.size.height - 100, 83, 30)];
    [self.returnToSetting setImage:[UIImage imageNamed:@"passwordback.png"] forState:UIControlStateNormal];
   // self.returnToSetting.backgroundColor = [UIColor clearColor];
    //[self.returnToSetting setTitle:@"返回" forState:UIControlStateNormal] ;
   // [self.returnToSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // self.returnToSetting.titleLabel.font = [UIFont systemFontOfSize:14.0f];
   // self.returnToSetting.layer.borderColor = [UIColor darkGrayColor].CGColor;
   // self.returnToSetting.layer.borderWidth = 0.4f;
    
    [self addSubview:self.returnToSetting];
    
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
