//
//  daylineView.m
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "daylineView.h"



@implementation daylineView

const int MOOD_BOTTOM_GAP = 80;
const int GROWTH_BOTTOM_GAP = 50;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.starArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.backgroundColor = [UIColor clearColor];
        [self drawlabels:frame];
        [self drawButtons:frame];
        
        
        self.my_scoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(0,110, self.frame.size.width, self.bounds.size.height-220)];
        
        
        
        [self addSubview:self.my_scoller];

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
   /* CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    float lengths[] = {10,5};
    
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(context,36+5, self.frame.origin.y+70);    //开始画线
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.origin.y+70);
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, self.frame.size.width/2+18+0.1, self.frame.origin.y+40);
    CGContextAddLineToPoint(context, self.frame.size.width/2+18+0.1, self.frame.size.height-100);
    CGContextStrokePath(context);
   */
    CGContextSetLineWidth(context, 0.25f); //设置线的宽度 为1个像素
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    CGContextMoveToPoint(context,36+5, self.frame.origin.y+70);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.origin.y+70);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 0.25f); //设置线的宽度 为1.5个像素
    CGContextMoveToPoint(context, self.frame.size.width/2+18+0.1, self.frame.origin.y+40);
    CGContextAddLineToPoint(context, self.frame.size.width/2+18+0.1, self.frame.size.height-100);
    CGContextStrokePath(context);
    
  //  CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);

  
}



-(void)drawButtons:(CGRect)frame
{
   /* self.addMoreWork = [[UIButton alloc]initWithFrame:CGRectMake(40, self.frame.size.height-220+85, 80, 35)];
    [self.addMoreWork setTitle:@"添加工作" forState:UIControlStateNormal];
    
    [self.addMoreWork setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addMoreWork.backgroundColor = [UIColor colorWithRed:0.0 green:0.85 blue:0.9 alpha:1.0];
   // self.addMoreWork.tintColor = [UIColor colorWithRed:0.0 green:0.85 blue:0.9 alpha:1.0];
    [self.addMoreWork.layer setMasksToBounds:YES];
    [self.addMoreWork.layer setCornerRadius:10.0];//设置矩形四个圆角半径
   [self.addMoreWork.layer setBorderWidth:1.0];
*/
    self.addMoreWork = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.addMoreWork setFrame:CGRectMake(70, self.frame.origin.y+75, 32, 32)];
    [self.addMoreWork setImage: [UIImage imageNamed:@"加号64.png"] forState:UIControlStateNormal];
    //[self.addMoreWork setImage: [UIImage imageNamed:@"addTapped.png"] forState:UIControlStateHighlighted];
    self.addMoreWork.tintColor = [UIColor darkGrayColor];
    self.addMoreWork.tag = 0;
    
    self.addMoreLife = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.addMoreLife setFrame:CGRectMake(172, self.frame.origin.y+75, 32, 32)];
    [self.addMoreLife setImage: [UIImage imageNamed:@"加号64.png"] forState:UIControlStateNormal];
    //[self.addMoreLife setImage: [UIImage imageNamed:@"addTapped.png"] forState:UIControlStateHighlighted];
    self.addMoreLife.tintColor = [UIColor darkGrayColor];
    self.addMoreLife.tag = 1;
    
    [self addSubview:self.addMoreWork];
    [self addSubview:self.addMoreLife];
    
    int bottom_y = frame.origin.y + frame.size.height;
    for (int i=0; i<5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [starButton setFrame:CGRectMake(65+i*30, bottom_y - MOOD_BOTTOM_GAP, 25, 25)];
        [starButton setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateHighlighted];
        starButton.tag = i;
        [self.starArray addObject:starButton];
        [self addSubview:starButton];
    }
    
    for (int i=0; i<5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [starButton setFrame:CGRectMake(65+i*30, bottom_y - GROWTH_BOTTOM_GAP, 25, 25)];
        
        [starButton setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateHighlighted];
        starButton.tag = i+100;
        [self.starArray addObject:starButton];
        [self addSubview:starButton];
        
    }
    
    self.dateNow = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-42, frame.origin.y+7, 120, 30)];
    //self.dateNow.backgroundColor = [UIColor blueColor];
   // self.dateNow.text = modifyDate;
    self.dateNow.font = [UIFont systemFontOfSize:18.0];
    self.dateNow.backgroundColor = [UIColor clearColor];
   // self.dateNow.layer.borderColor = [UIColor blackColor].CGColor;
    self.dateNow.layer.borderWidth = 1.0;
    self.dateNow.textAlignment = NSTextAlignmentCenter;
    self.dateNow.layer.borderColor = [UIColor clearColor].CGColor;
   // self.dateNow.layer.borderWidth = 2.0;
    [self addSubview:self.dateNow];
    
/*   测试这十个star是否咱顺序被创建，按顺序插入了starArray
    for (int i=0; i<10; i++) {
        UIButton *test = [self.starArray objectAtIndex:i];
        
        NSLog(@"%d",test.tag);
    }
 */
    
 /*   UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [finishButton setFrame:CGRectMake(175, 10, 45, 25)];
    
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:16.0];

    
    [self addSubview:finishButton];
  
*/  
}


-(void) drawlabels:(CGRect)frame
{
    
    UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+36, frame.origin.y+40, frame.size.width/2-40-18, 26)];
    workLabel.text = @"工作";
    workLabel.backgroundColor = [UIColor clearColor];
    workLabel.textAlignment = NSTextAlignmentCenter;
    workLabel.layer.borderColor = [UIColor clearColor].CGColor;
    workLabel.layer.borderWidth = 2.0;
    
    
    UILabel *lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+20+18, frame.origin.y+40, frame.size.width/2-40-18, 26)];
    
    lifeLabel.text = @"生活";
    lifeLabel.backgroundColor = [UIColor clearColor];
    lifeLabel.textAlignment = NSTextAlignmentCenter;
    lifeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    lifeLabel.layer.borderWidth = 2.0;
    
    
    [self addSubview:workLabel];
    [self addSubview:lifeLabel];
    
    int bottom_y = frame.origin.y + frame.size.height;
    
    UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, bottom_y - MOOD_BOTTOM_GAP, 40, 26)];
    moodLabel.text = @"心情";
    moodLabel.backgroundColor = [UIColor clearColor];
    moodLabel.font = [UIFont systemFontOfSize:14.0];
    moodLabel.textAlignment = NSTextAlignmentCenter;
    moodLabel.layer.borderColor = [UIColor clearColor].CGColor;
    moodLabel.layer.borderWidth = 2.0;
    
    UILabel *growthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, bottom_y - GROWTH_BOTTOM_GAP, 40, 26)];
    growthLabel.text = @"成长";
    growthLabel.font = [UIFont systemFontOfSize:14.0];
    growthLabel.backgroundColor = [UIColor clearColor];
    growthLabel.textAlignment = NSTextAlignmentCenter;
    growthLabel.layer.borderColor = [UIColor clearColor].CGColor;
    growthLabel.layer.borderWidth = 2.0;
 
  
    
    
    [self addSubview:workLabel];
    [self addSubview:lifeLabel];
    [self addSubview:moodLabel];
    [self addSubview:growthLabel];
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
