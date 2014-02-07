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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
        
        UIImageView *rightBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        rightBackground.image = [UIImage imageNamed:@"rightBackground.png"];
        
        [self addSubview:rightBackground];
        [self sendSubviewToBack:rightBackground];

       
        
        NSArray *selectModeText = [[NSArray alloc] initWithObjects:@"按日期",@"按标签",@"关键字",nil];
        self.selectMode = [[UISegmentedControl alloc] initWithItems:selectModeText];
        
        [self.selectMode setFrame:CGRectMake(self.frame.size.width/2-100, frame.origin.y+10, 200, 35)];
        self.selectMode.selectedSegmentIndex= 0;
        [self.selectMode addTarget:self action:@selector(selectValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.selectMode.backgroundColor = [UIColor clearColor];
        [self addSubview:self.selectMode];
        
        self.goInThatDay= [UIButton buttonWithType:UIButtonTypeCustom];
        self.goInThatDay.frame = CGRectMake((self.frame.size.width-20)/2-60, frame.size.height-100, 120, 30);
        [self.goInThatDay setTitle:@"回顾当日" forState:UIControlStateNormal];
        
        self.goInThatDay.layer.borderColor = [UIColor blackColor].CGColor;
        self.goInThatDay.layer.borderWidth = 1.0;
        [self.goInThatDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        

        //按日期查询视图
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(10,frame.origin.y+55,self.frame.size.width-20, self.frame.size.height-55)];
         self.dateView.backgroundColor = [UIColor clearColor];

        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(10,frame.origin.y+55,self.frame.size.width-20, self.frame.size.height-55)];
       // self.tagView.backgroundColor = [UIColor grayColor];
        self.keyWordView = [[UIView alloc] initWithFrame:CGRectMake(10,frame.origin.y+55,self.frame.size.width-20, self.frame.size.height-55)];
        
        
        
        self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
        self.calendar.frame = CGRectMake(0, 0, self.frame.size.width-20, (self.frame.size.height-150)/2);
        //self.calendar.backgroundColor = [UIColor clearColor];
        [self.dateView addSubview:self.calendar];

        self.backgroundColor = [UIColor whiteColor];
      
        self.eventsTable =[[UITableView alloc] initWithFrame: CGRectMake(0, (self.frame.size.height)/2-15, self.frame.size.width-20, (self.frame.size.height-150)/2-20)];

        self.eventsTable.rowHeight = 34;
        self.eventsTable.tag = 0;
        NSLog(@"frame:%f",self.eventsTable.frame.origin.y);
        [self.eventsTable setEditing:NO];
      //  self.eventsTable.backgroundColor = [UIColor grayColor];
        self.eventsTable.backgroundColor = [UIColor clearColor];
        [self.dateView addSubview:self.eventsTable];
        
        
        //按标签查询视图
        self.alltagTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width-30, self.frame.size.height-170)];
      //  [self.alltagTable setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
        self.alltagTable.backgroundColor = [UIColor clearColor];
        self.alltagTable.tag = 1;
               // self.alltagTable.rowHeight = 34;
        self.eventInTagTable= [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width-30, self.frame.size.height-170)];
        self.eventInTagTable.tag = 2;
        self.eventInTagTable.backgroundColor = [UIColor clearColor];
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
        
    //按关键字查询视图
        
        self.my_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width-30, 40)];
        self.my_searchBar.tintColor = [UIColor clearColor];
        self.my_searchBar.barStyle = UIBarStyleDefault;
        self.my_searchBar.placeholder = @"请输入：";
        self.my_searchBar.showsCancelButton =YES;
        
        self.eventInSearchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width-30, self.frame.size.height-150)];
        self.eventInSearchTable.backgroundColor = [UIColor clearColor];
        self.eventInSearchTable.tag = 4;
        
        [self.keyWordView addSubview:self.my_searchBar];
        [self.keyWordView addSubview:self.eventInSearchTable];
        //[self addSubview:self.keyWordView];
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
        if (self.tagView ) {
            [self.tagView removeFromSuperview];
            [self addSubview:self.dateView];
            
            
        }
        if(self.keyWordView){
            [self.keyWordView removeFromSuperview];
            [self addSubview:self.dateView];
            
        }
        
        
    }
    else if(myUISegmentedControl.selectedSegmentIndex == 1){
        
        if (self.dateView) {
            [self.dateView removeFromSuperview];
            
            [self addSubview:self.tagView];
            
            
        }
        if(self.keyWordView){
            [self.keyWordView removeFromSuperview];
            
            [self addSubview:self.tagView];
            
        }
        
    }
    else if(myUISegmentedControl.selectedSegmentIndex == 2){
        if (self.dateView) {
            [self.dateView removeFromSuperview];
            
            [self addSubview:self.keyWordView];
            
            
        }
        if(self.tagView){
            [self.tagView removeFromSuperview];
            
            [self addSubview:self.keyWordView];
           
        }

        
    }
    
}

-(void)dismissKeyboard {
    NSLog(@"6666655555");
    NSArray *subviews = [self.keyWordView subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UISearchBar class]]) {
            UISearchBar *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
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
