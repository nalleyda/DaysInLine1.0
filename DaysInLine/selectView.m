//
//  selectView.m
//  DaysInLine
//
//  Created by 张力 on 14-1-4.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "selectView.h"


@implementation selectView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *selectModeText = [[NSArray alloc] initWithObjects:@"按日期查询",@"按标签查询", nil];
        self.goInThatDay= [UIButton buttonWithType:UIButtonTypeCustom];
        self.goInThatDay.frame = CGRectMake(self.frame.size.width/2-60, self.frame.size.height-45, 120, 30);
        [self.goInThatDay setTitle:@"回顾当日" forState:UIControlStateNormal];
    //    self.goInThatDay.backgroundColor = [UIColor blueColor];
      
        self.goInThatDay.layer.borderColor = [UIColor blackColor].CGColor;
        self.goInThatDay.layer.borderWidth = 1.0;
        [self.goInThatDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.selectMode = [[UISegmentedControl alloc] initWithItems:selectModeText];
       // self.selectMode = [[UISegmentedControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 10, 100, 25)];
        [self.selectMode setFrame:CGRectMake(self.frame.size.width/2-100, 10, 200, 35)];
        self.selectMode.selectedSegmentIndex= 0;
        [self.selectMode addTarget:self action:@selector(selectValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.selectMode];
        
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(10,55,self.frame.size.width-20, self.frame.size.height-110)];
      //  self.dateView.backgroundColor = [UIColor grayColor];
        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(10,55,self.frame.size.width-20, self.frame.size.height-110)];
        self.tagView.backgroundColor = [UIColor grayColor];
        
        self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
        self.calendar.frame = CGRectMake(0, 0, self.frame.size.width-20, (self.frame.size.height-150)/2);
        [self.dateView addSubview:self.calendar];
      //  self.calendar.frame = CGRectMake(10, 55, self.frame.size.width-20, self.frame.size.width-50);
      //  calendar.backgroundColor = [UIColor blueColor];
      //  [self addSubview:self.calendar];
        self.backgroundColor = [UIColor whiteColor];
      
        self.eventsTable =[[UITableView alloc] initWithFrame: CGRectMake(0, (self.frame.size.height)/2-15, self.frame.size.width-20, (self.frame.size.height-150)/2-20)];

      //  self.eventsTable =[[UITableView alloc] initWithFrame: CGRectMake(10, self.calendar.frame.size.height+self.calendar.frame.origin.y+30, self.frame.size.width-20, self.frame.size.width-100)];
        self.eventsTable.rowHeight = 34;
        
        NSLog(@"frame:%f",self.eventsTable.frame.origin.y);
        self.eventsTable.backgroundColor = [UIColor yellowColor];
        [self.dateView addSubview:self.eventsTable];
        [self addSubview:self.goInThatDay];
        [self addSubview:self.dateView];
        
       // [self addSubview:self.eventsTable];
        
    
        // Initialization code
    }
    return self;
}


-(void)selectValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    NSLog(@"!!!!!!%d",myUISegmentedControl.selectedSegmentIndex);
    if (myUISegmentedControl.selectedSegmentIndex == 0) {
        if (self.tagView) {
            [self.tagView removeFromSuperview];
            [self addSubview:self.dateView];
            
            
        }
        else if(self.dateView){
            
            return;
        }
        
        
    }
    else if(myUISegmentedControl.selectedSegmentIndex == 1){
        
        if (self.dateView) {
            [self.dateView removeFromSuperview];
            [self addSubview:self.tagView];
            
            
        }
        else if(self.tagView){
            
            return;
        }
        
    }
    
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
