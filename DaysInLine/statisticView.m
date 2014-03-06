//
//  statisticView.m
//  DaysInLine
//
//  Created by 张力 on 14-1-26.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "statisticView.h"

@implementation statisticView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.origin.y+30, self.frame.size.width-20, 30) ];
        tips.text = @"请选择想要分析的时间段：";
        tips.backgroundColor = [UIColor clearColor];
        
        [self addSubview:tips];
       
        /*
        UILabel *to= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-30, 40, 40) ];
        to.text = @"到";
        to.font = [UIFont systemFontOfSize:28.0];
        to.layer.borderColor = [UIColor clearColor].CGColor;
        */
        UIImageView *to = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-19, self.frame.size.height/2-32, 47, 25) ];
        to.image = [UIImage imageNamed: @"到"];
        [self addSubview:to];

        
        self.dateStart = [[UIDatePicker alloc] init] ;
        
        self.dateStart.datePickerMode = UIDatePickerModeDate;
        self.dateStart.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-100);
        
        self.dateStart.transform = CGAffineTransformMakeScale(0.55, 0.55);
        [self addSubview:self.dateStart];
        
        
        self.dateEnd = [[UIDatePicker alloc] init] ;
        
        self.dateEnd.datePickerMode = UIDatePickerModeDate;
        self.dateEnd.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+60);
        
        self.dateEnd.transform = CGAffineTransformMakeScale(0.55, 0.55);
        [self addSubview:self.dateEnd];
        
        
             
        
        self.resultButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-100, 100, 30) ];
        [self.resultButton setBackgroundImage:[UIImage imageNamed: @"查看结果.png"] forState:UIControlStateNormal];
      //  [self.resultButton setTitle:@"查看结果" forState:UIControlStateNormal];
       // self.resultButton.layer.borderColor = [UIColor blackColor].CGColor;
       // self.resultButton.layer.borderWidth = 1.0;
       // [self.resultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        

        [self addSubview:self.resultButton];


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
