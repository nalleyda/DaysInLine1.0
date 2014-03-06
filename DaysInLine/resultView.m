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
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-130, 97, 30)];
        self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(175, y+73, 50, 50)];

        }else
        {
            y-=10;
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-90, 97, 30)];
        self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(175, y+83, 50, 50)];

        }
        
        self.continueButton.backgroundColor = [UIColor clearColor];
        [self.continueButton setBackgroundImage:[UIImage imageNamed: @"继续努力.png"] forState:UIControlStateNormal];
        //[self.continueButton setTitle:@"继续努力" forState:UIControlStateNormal];
      //  self.continueButton.titleLabel.text = @"继续努力";
      //  self.continueButton.titleLabel.textColor = [UIColor blueColor];
        [self addSubview:self.continueButton];

        
       // self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(175, y+73, 50, 50)];
        self.daysCount.backgroundColor = [UIColor clearColor];
        self.daysCount.textAlignment = NSTextAlignmentCenter;
        self.daysCount.textColor = [UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f];
        self.daysCount.font = [UIFont systemFontOfSize:20.0];
        [self addSubview:self.daysCount];

        
        UIImageView *workImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +133, 260    , 30)];
        [workImage setImage:[UIImage imageNamed:@"工作生活.png"]];
        
        self.workingLong = [[UILabel alloc] init];
        self.workingLong.backgroundColor = [UIColor colorWithRed:97/255.0f green:197/255.0f blue:185/255.0f alpha:1.0f];
        self.workingTime = [[UILabel alloc] initWithFrame:CGRectMake(80,y +133, 100 , 16)];
        self.workingTime.backgroundColor = [UIColor clearColor];
        self.workingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        self.lifeLong = [[UILabel alloc] init];
        self.lifeLong.backgroundColor = [UIColor colorWithRed:246/255.0f green:235/255.0f blue:127/255.0f alpha:1.0f];
        self.lifingTime = [[UILabel alloc] initWithFrame:CGRectMake(141,y +133, 100 , 16)];
        self.lifingTime.backgroundColor = [UIColor clearColor];
        self.lifingTime.textAlignment = NSTextAlignmentRight;
        self.lifingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.lifeLong];
        [self addSubview:self.lifingTime];
        [self addSubview:self.workingLong];
        [self addSubview:self.workingTime];
        [self addSubview:workImage];
        
        UIImageView *moodImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +195, 260    , 30)];
        [moodImage setImage:[UIImage imageNamed:@"心情.png"]];

        
        self.moodLong = [[UILabel alloc] init];
        self.moodLong.backgroundColor = [UIColor colorWithRed:241/255.0f green:99/255.0f blue:105/255.0f alpha:1.0f];
        self.mood = [[UILabel alloc] init];
        self.mood.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.mood.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.mood];
        [self addSubview:self.moodLong];
     
        
        [self addSubview:moodImage];
        
        UIImageView *growImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +240, 260    , 30)];
        [growImage setImage:[UIImage imageNamed:@"成长.png"]];
        
        self.growLong = [[UILabel alloc] init];
        self.growLong.backgroundColor = [UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f];
        self.grow = [[UILabel alloc] init];
        self.grow.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.grow.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.grow];
        [self addSubview:self.growLong];
        
        [self addSubview:growImage];
        
        UIImageView *incomeImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +290, 260    , 30)];
        [incomeImage setImage:[UIImage imageNamed:@"收入.png"]];
        
        self.incomingLong = [[UILabel alloc] init];
        self.incomingLong.backgroundColor = [UIColor colorWithRed:151/255.0f green:204/255.0f blue:114/255.0f alpha:1.0f];
        self.incoming = [[UILabel alloc] init];
        self.incoming.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.incoming.font = [UIFont systemFontOfSize:10.0];
        
        [self addSubview:self.incoming];
        [self addSubview:self.incomingLong];
        [self addSubview:incomeImage];
        
        UIImageView *expendImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +335, 260    , 30)];
        [expendImage setImage:[UIImage imageNamed:@"支出.png"]];
        
        self.expendingLong = [[UILabel alloc] init];
        self.expendingLong.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:64/255.0f alpha:1.0f];
       // [self bringSubviewToFront:self.expendingLong];
        self.expending = [[UILabel alloc] init];
        self.expending.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.expending.font = [UIFont systemFontOfSize:10.0];
        
        [self addSubview:self.expending];
        [self addSubview:self.expendingLong];
        
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
