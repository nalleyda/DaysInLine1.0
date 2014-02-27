//
//  resultView.m
//  DaysInLine
//
//  Created by 张力 on 14-2-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "resultView.h"

@implementation resultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int y = self.frame.origin.y ;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            //NSLog(@"ios7!!!!");
            y += 5;

        }
        
        /* fit for 4-inch screen */
         CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            y += 50;
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-60, 80, 50)];
        }else
        {
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-100, 80, 50)];

        }
        
        self.continueButton.backgroundColor = [UIColor clearColor];
        [self.continueButton setTitle:@"继续努力" forState:UIControlStateNormal];
      //  self.continueButton.titleLabel.text = @"继续努力";
        self.continueButton.titleLabel.textColor = [UIColor blueColor];
        [self addSubview:self.continueButton];

        
        UIImageView *workImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +90, 260    , 30)];
        [workImage setImage:[UIImage imageNamed:@"工作生活.png"]];
        
        self.workingLong = [[UILabel alloc] init];
        self.workingLong.backgroundColor = [UIColor colorWithRed:97/255.0f green:197/255.0f blue:185/255.0f alpha:1.0f];
        self.workingTime = [[UILabel alloc] initWithFrame:CGRectMake(80,y +90, 50 , 16)];
        self.workingTime.backgroundColor = [UIColor clearColor];
        self.workingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        self.lifeLong = [[UILabel alloc] init];
        self.lifeLong.backgroundColor = [UIColor colorWithRed:246/255.0f green:235/255.0f blue:127/255.0f alpha:1.0f];
        self.lifingTime = [[UILabel alloc] initWithFrame:CGRectMake(190,y +90, 50 , 16)];
        self.lifingTime.backgroundColor = [UIColor clearColor];
        self.lifingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.lifeLong];
        [self addSubview:self.lifingTime];
        [self addSubview:self.workingLong];
        [self addSubview:self.workingTime];
        [self addSubview:workImage];
        
        UIImageView *moodImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +160, 260    , 30)];
        [moodImage setImage:[UIImage imageNamed:@"心情.png"]];

     
        
        [self addSubview:moodImage];
        
        UIImageView *growImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +205, 260    , 30)];
        [growImage setImage:[UIImage imageNamed:@"成长.png"]];
        
        [self addSubview:growImage];
        
        UIImageView *incomeImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +275, 260    , 30)];
        [incomeImage setImage:[UIImage imageNamed:@"收入.png"]];
        
        [self addSubview:incomeImage];
        
        UIImageView *expendImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +320, 260    , 30)];
        [expendImage setImage:[UIImage imageNamed:@"支出.png"]];
        
        [self addSubview:expendImage];
        
    }
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
