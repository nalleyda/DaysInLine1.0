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
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
        
        

        self.backgroundColor = [UIColor clearColor];

        self.settingTable = [[UITableView alloc] initWithFrame:CGRectMake(2,300,self.frame.size.width-10, 110) style:UITableViewStylePlain];
        
        self.settingTable.tag = 5;
        self.settingTable.rowHeight = 38;
        self.settingTable.backgroundColor = [UIColor clearColor];

        
        [self addSubview:self.settingTable];
       
        
        UILabel *soundLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+78, 40, 30)];
        soundLabel.text = @"音效";
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
        
        /*
         
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
        */
        UILabel *firstDay = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+128, 100, 30)];
        firstDay.text = @"收藏夹密码";
        firstDay.font = [UIFont systemFontOfSize:16.0];
        firstDay.backgroundColor = [UIColor clearColor];
        
        [self addSubview:firstDay];
       
        
        self.remindSoundSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(130, self.frame.origin.y+130, 60, 25)];
        
        self.remindSoundSwitch.backgroundColor = [UIColor clearColor]; // 设置背景色
        self.remindSoundSwitch.alpha = 1.0;
        //self.daySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.remindSoundSwitch.thumbTintColor = [UIColor blueColor];
        //[self.daySwitch setOn:YES animated:YES];
        
        self.remindSoundSwitch.offImage = [UIImage imageNamed:@"cross.png"];
        self.remindSoundSwitch.onImage = [UIImage imageNamed:@"check.png"];
        [self addSubview:self.remindSoundSwitch];
        
        self.tipsView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+160, 190, 50)];
        
        self.tips = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 50, 30)];
        [self.tips setTitle:@"提示" forState:UIControlStateNormal ];
        [self.tips setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.tips.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.tips.layer.borderWidth = 0.0f;
        self.tips.backgroundColor = [UIColor clearColor];
        
        self.tipText = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 120, 30)];
        self.tipText.textAlignment = NSTextAlignmentRight;
        self.tipText.font = [UIFont systemFontOfSize:16.0];
       // tipText.text = userTips;
       self. tipText.backgroundColor = [UIColor clearColor];
        
        [self.tipsView addSubview:self.tipText];
        [self.tipsView addSubview:self.tips];
        
        self.passwordView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.origin.y+160, 190, 140)];
        
        
        UILabel *passwordText = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 70, 30)];
        passwordText.font = [UIFont systemFontOfSize:14.0];
        passwordText.text = @"设置密码:";
        passwordText.backgroundColor = [UIColor clearColor];
        
        UILabel *passwordAgain = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 70, 30)];
        passwordAgain.font = [UIFont systemFontOfSize:14.0];
        passwordAgain.text = @"再次输入:";
        passwordAgain.backgroundColor = [UIColor clearColor];
        
        UILabel *setTipsText = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, 70, 30)];
        setTipsText.font = [UIFont systemFontOfSize:14.0];
        setTipsText.text = @"密码提示:";
        setTipsText.backgroundColor = [UIColor clearColor];

        self.password = [[UITextField alloc] initWithFrame:CGRectMake(75, 13, 100, 25)];
        self.password.secureTextEntry = YES;
        self.password.keyboardType = UIKeyboardTypeNumberPad;
        self.password.layer.borderWidth = 0.8f;
        self.password.layer.borderColor = [UIColor grayColor].CGColor;
        self.password2 = [[UITextField alloc] initWithFrame:CGRectMake(75, 46, 100, 25)];
        self.password2.secureTextEntry = YES;
        self.password2.keyboardType = UIKeyboardTypeNumberPad;

        self.password2.layer.borderWidth = 0.8f;
        self.password2.layer.borderColor = [UIColor grayColor].CGColor;

        self.userTip =  [[UITextField alloc] initWithFrame:CGRectMake(75, 81, 100, 25)];
        self.userTip.layer.borderWidth = 0.8f;
        self.userTip.layer.borderColor = [UIColor grayColor].CGColor;
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 113, 40, 25)];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal ];
        [self.confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.confirmButton.layer.borderWidth = 0.0f;
        self.confirmButton.backgroundColor = [UIColor clearColor];
        
        [self.passwordView addSubview:passwordText];
        [self.passwordView addSubview:passwordAgain];
        [self.passwordView addSubview:setTipsText];
        [self.passwordView addSubview:self.password];
        [self.passwordView addSubview:self.password2];
        [self.passwordView addSubview:self.userTip];
        [self.passwordView addSubview:self.confirmButton];



        [self addSubview:self.passwordView];
        [self addSubview:self.tipsView];
        
        [self.tipsView setHidden:YES];
        [self.passwordView setHidden:YES];

        


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
    
   /*
    CGContextMoveToPoint(context,10, self.frame.origin.y+210);
    CGContextAddLineToPoint(context, self.frame.size.width-20, self.frame.origin.y+210);
    CGContextStrokePath(context);
    */
   
    
    //  CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
}


-(void)dismissKeyboard {
    
        NSArray *subviews = [self.passwordView subviews];
        for (id objInput in subviews) {
            if ([objInput isKindOfClass:[UITextField class]]) {
                UITextField *theTextField = objInput;
                if ([objInput isFirstResponder]) {
                    [theTextField resignFirstResponder];
                }
            }
            
        }

    
}

@end
