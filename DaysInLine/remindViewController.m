//
//  remindViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-12-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "remindViewController.h"

@interface remindViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UIView *viewDate;
@property (strong,nonatomic) UIView *viewInterval;

@end

@implementation remindViewController
UITextField *daysInterval;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  self.view.backgroundColor = [UIColor clearColor];
    self.viewDate = [[UIView alloc] initWithFrame:CGRectMake(0,70,self.view.frame.size.width, self.view.frame.size.height-150)];
    self.viewInterval = [[UIView alloc] initWithFrame:CGRectMake(0,70,self.view.frame.size.width, self.view.frame.size.height-150)];
    //按日期设置提醒时间的视图
    
    //self.viewDate.backgroundColor = [UIColor greenColor];
    UIDatePicker *remindDatePicker = [[UIDatePicker alloc] init] ;
    UIDatePicker *remindTimePicker = [[UIDatePicker alloc] init] ;
    UIDatePicker *remindTimePicker2 = [[UIDatePicker alloc] init] ;
    
    remindDatePicker.datePickerMode = UIDatePickerModeDate;
    remindDatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 30);
    remindDatePicker.center = CGPointMake(self.view.frame.size.width/2, 75);
    [self.viewDate addSubview:remindDatePicker];
    
    remindTimePicker.datePickerMode = UIDatePickerModeTime;
    remindTimePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 30);
    remindTimePicker.center = CGPointMake(self.view.frame.size.width/2, 240);
     [self.viewDate addSubview:remindTimePicker];
    
    
    [self.remindMode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.remindMode.selectedSegmentIndex= 0;
    [self.view addSubview:self.viewDate];

    //按间隔设置提醒时间的视图
    daysInterval = [[UITextField alloc] init];
    daysInterval.frame = CGRectMake(0, 0, 70, 30);
    daysInterval.center = CGPointMake(self.view.frame.size.width/2-25, 60);
    daysInterval.font = [UIFont fontWithName:@"Courier-BoldOblique" size:24.0];
    daysInterval.textAlignment = NSTextAlignmentCenter;
    daysInterval.keyboardType = UIKeyboardTypeNumberPad;
    daysInterval.backgroundColor = [UIColor whiteColor];
    daysInterval.delegate = self;
    UILabel *dayslabel = [[UILabel alloc] init];
    dayslabel.frame = CGRectMake(0, 0, 60, 40);
    dayslabel.center = CGPointMake(self.view.frame.size.width/2+45, 60);
    dayslabel.text = @"天后";
    dayslabel.textColor = [UIColor purpleColor];
    dayslabel.backgroundColor = [UIColor clearColor];
    dayslabel.textAlignment = NSTextAlignmentCenter;
    dayslabel.layer.borderColor = [UIColor clearColor].CGColor;
    dayslabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:24.0];
    [self.viewInterval addSubview:daysInterval];
    [self.viewInterval addSubview:dayslabel];
    remindTimePicker2.datePickerMode = UIDatePickerModeTime;
    remindTimePicker2.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 30);
    remindTimePicker2.center = CGPointMake(self.view.frame.size.width/2, 220);
    [self.viewInterval addSubview:remindTimePicker2];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)valueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    NSLog(@"!!!!!!%d",myUISegmentedControl.selectedSegmentIndex);
    if (myUISegmentedControl.selectedSegmentIndex == 0) {
        if (self.viewInterval) {
            [self.viewInterval removeFromSuperview];
            [self.view addSubview:self.viewDate];


        }
        else if(self.viewDate){
        
            return;
        }
    
        
    }
    else if(myUISegmentedControl.selectedSegmentIndex == 1){
        
        if (self.viewDate) {
            [self.viewDate removeFromSuperview];
            [self.view addSubview:self.viewInterval];
            
            
        }
        else if(self.viewInterval){
            
            return;
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [daysInterval resignFirstResponder];
}

@end
