//
//  settingView.m
//  DaysInLine
//
//  Created by 张力 on 14-2-23.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "settingView.h"

@implementation settingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
   /*     UIImageView *rightBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        rightBackground.image = [UIImage imageNamed:@"rightBackground.png"];
        
        [self addSubview:rightBackground];
        [self sendSubviewToBack:rightBackground];
        
  */      

        self.backgroundColor = [UIColor clearColor];

        self.settingTable = [[UITableView alloc] initWithFrame:CGRectMake(10,280,self.frame.size.width-20, 100) style:UITableViewStylePlain];
        
        self.settingTable.tag = 5;
        self.settingTable.rowHeight = 48;
        self.settingTable.backgroundColor = [UIColor clearColor];

        
        [self addSubview:self.settingTable];
        
        
        UILabel *soundLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+78, 40, 30)];
        soundLabel.text = @"声音";
        soundLabel.font = [UIFont systemFontOfSize:16.0];
        soundLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:soundLabel];
        
        self.soundSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(130, self.frame.origin.y+80, 60, 25)];
        self.soundSwitch.backgroundColor = [UIColor clearColor]; // 设置背景色
        self.soundSwitch.alpha = 1.0; // 设置透明度 范围在0.0-1.0之间 0.0是完全透明
        
        //   self.soundSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        // oneSwitch.onTintColor = [UIColor redColor]; // 在oneSwitch开启的状态显示的颜色 默认是blueColor
        // oneSwitch.tintColor = [UIColor purpleColor]; // 设置关闭状态的颜色
        self.soundSwitch.thumbTintColor = [UIColor blueColor]; // 设置开关上左右滑动的小圆点的颜色
        
        // [self.soundSwitch setOn:YES animated:YES];
        self.soundSwitch.offImage = [UIImage imageNamed:@"cross.png"];
        self.soundSwitch.onImage = [UIImage imageNamed:@"check.png"];
        
        
        
        [self addSubview:self.soundSwitch];
        
        
        UILabel *icloud = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+128, 100, 30)];
        icloud.text = @"同步到iCloud";
        icloud.font = [UIFont systemFontOfSize:16.0];
        icloud.backgroundColor = [UIColor clearColor];
        
        [self addSubview:icloud];
        
        
        self.icloudSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(130, self.frame.origin.y+130, 60, 25)];
        
        self.icloudSwitch.backgroundColor = [UIColor clearColor]; // 设置背景色
        //self.icloudSwitch.onTintColor = [UIColor redColor];
        self.icloudSwitch.alpha = 1.0;
        //self.icloudSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        self.icloudSwitch.thumbTintColor = [UIColor blueColor];
        // [self.icloudSwitch setOn:YES animated:YES];
        
        
        self.icloudSwitch.offImage = [UIImage imageNamed:@"cross.png"];
        self.icloudSwitch.onImage = [UIImage imageNamed:@"check.png"];
        [self addSubview:self.icloudSwitch];
        
        UILabel *firstDay = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+178, 80, 30)];
        firstDay.text = @"周首日";
        firstDay.font = [UIFont systemFontOfSize:16.0];
        firstDay.backgroundColor = [UIColor clearColor];
        
        [self addSubview:firstDay];
        
        
        self.daySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(130, self.frame.origin.y+180, 60, 25)];
        
        self.daySwitch.backgroundColor = [UIColor clearColor]; // 设置背景色
        self.daySwitch.alpha = 1.0;
        //self.daySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.daySwitch.thumbTintColor = [UIColor blueColor];
        //[self.daySwitch setOn:YES animated:YES];
        
        self.daySwitch.offImage = [UIImage imageNamed:@"cross.png"];
        self.daySwitch.onImage = [UIImage imageNamed:@"check.png"];
        [self addSubview:self.daySwitch];
        


    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.25f); //设置线的宽度 为1个像素
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    CGContextMoveToPoint(context,10, self.frame.origin.y+110);
    CGContextAddLineToPoint(context, self.frame.size.width-20, self.frame.origin.y+110);
    CGContextStrokePath(context);
    
    NSLog(@"setting frame:y%.2f,width:%.2f",self.frame.origin.y,self.frame.size.width);
    
   
  
    
    CGContextMoveToPoint(context,10, self.frame.origin.y+160);
    CGContextAddLineToPoint(context, self.frame.size.width-20, self.frame.origin.y+160);
    CGContextStrokePath(context);
    
    
    CGContextMoveToPoint(context,10, self.frame.origin.y+210);
    CGContextAddLineToPoint(context, self.frame.size.width-20, self.frame.origin.y+210);
    CGContextStrokePath(context);
    
   
    
    //  CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
}


@end
