//
//  customButton.m
//  DaysInLine
//
//  Created by 张力 on 14-2-12.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "customButton.h"

@implementation customButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CALayer *layer = [self layer];
        [layer setMasksToBounds:YES];
        CGFloat radius=frame.size.width/2; //设置圆角的半径为图片宽度的一半
        [layer setCornerRadius:radius];
        [layer setBorderWidth:5];//添加白色的边框
        [layer setBorderColor:[[UIColor colorWithRed:214/255.0f green:207/255.0f blue:208/255.0f alpha:1.0f] CGColor]];
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
