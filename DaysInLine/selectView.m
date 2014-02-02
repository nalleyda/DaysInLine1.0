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
        self.selectMode = [[UISegmentedControl alloc] initWithItems:selectModeText];
        
        [self.selectMode setFrame:CGRectMake(self.frame.size.width/2-100, frame.origin.y+10, 200, 35)];
        self.selectMode.selectedSegmentIndex= 0;
        [self.selectMode addTarget:self action:@selector(selectValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.selectMode];
        
        self.goInThatDay= [UIButton buttonWithType:UIButtonTypeCustom];
        self.goInThatDay.frame = CGRectMake((self.frame.size.width-20)/2-60, self.frame.size.height-100, 120, 30);
        [self.goInThatDay setTitle:@"回顾当日" forState:UIControlStateNormal];
        
        self.goInThatDay.layer.borderColor = [UIColor blackColor].CGColor;
        self.goInThatDay.layer.borderWidth = 1.0;
        [self.goInThatDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        

        //按日期查询视图
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(10,frame.origin.y+55,self.frame.size.width-20, self.frame.size.height-55)];

        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(10,frame.origin.y+55,self.frame.size.width-20, self.frame.size.height-55)];
       // self.tagView.backgroundColor = [UIColor grayColor];
        
        self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
        self.calendar.frame = CGRectMake(0, 0, self.frame.size.width-20, (self.frame.size.height-150)/2);
        [self.dateView addSubview:self.calendar];

        self.backgroundColor = [UIColor whiteColor];
      
        self.eventsTable =[[UITableView alloc] initWithFrame: CGRectMake(0, (self.frame.size.height)/2-15, self.frame.size.width-20, (self.frame.size.height-150)/2-20)];

        self.eventsTable.rowHeight = 34;
        self.eventsTable.tag = 0;
        NSLog(@"frame:%f",self.eventsTable.frame.origin.y);
        [self.eventsTable setEditing:NO];
      //  self.eventsTable.backgroundColor = [UIColor grayColor];
        [self.dateView addSubview:self.eventsTable];
        
        
        //按标签查询视图
        self.alltagTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width-30, self.frame.size.height-170)];
      //  [self.alltagTable setIndicatorStyle:UIScrollViewIndicatorStyleBlack];

        self.alltagTable.tag = 1;
               // self.alltagTable.rowHeight = 34;
        self.eventInTagTable= [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width-30, self.frame.size.height-170)];
        self.eventInTagTable.tag = 2;
       // self.alltagTable.backgroundColor = [UIColor yellowColor];
        [self.tagView addSubview:self.alltagTable];

        self.returnToTags= [UIButton buttonWithType:UIButtonTypeCustom];
        self.returnToTags.frame = CGRectMake((self.frame.size.width-20)/2-60, self.frame.size.height-120, 120, 30);
        [self.returnToTags setTitle:@"重选标签" forState:UIControlStateNormal];
        
        self.returnToTags.layer.borderColor = [UIColor blackColor].CGColor;
        self.returnToTags.layer.borderWidth = 1.0;
        [self.returnToTags setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        

        [self.tagView addSubview:self.returnToTags];
        [self.tagView addSubview:self.eventInTagTable];
        [self.eventInTagTable setHidden:YES];
        [self.returnToTags setHidden:YES];
        [self.dateView addSubview:self.goInThatDay];
        [self addSubview:self.dateView];
        
    
        // Initialization code
    }
    return self;
}


-(void)selectValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    NSLog(@"!!!!!!%d",myUISegmentedControl.selectedSegmentIndex);
    [self.alltagTable reloadData];
    
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
