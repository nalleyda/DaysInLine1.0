//
//  remindViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-12-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "remindViewController.h"

@interface remindViewController ()

@property (strong,nonatomic) UIView *viewDate;
@property (strong,nonatomic) UIView *viewInterval;

@end

@implementation remindViewController

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
    self.viewDate.backgroundColor = [UIColor greenColor];
    UIDatePicker *remindDatePicker = [[UIDatePicker alloc] init] ;
    UIDatePicker *remindTimePicker = [[UIDatePicker alloc] init] ;

    
    remindDatePicker.datePickerMode = UIDatePickerModeDate;
    remindDatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 30);
    remindDatePicker.center = CGPointMake(self.view.frame.size.width/2, 80);
    [self.viewDate addSubview:remindDatePicker];
    
    remindTimePicker.datePickerMode = UIDatePickerModeTime;
    remindTimePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 30);
    remindTimePicker.center = CGPointMake(self.view.frame.size.width/2, 245);
     [self.viewDate addSubview:remindTimePicker];
    
    
    [self.remindMode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.remindMode.selectedSegmentIndex= 0;
    [self.view addSubview:self.viewDate];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)valueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    NSLog(@"!!!!!!%d",myUISegmentedControl.selectedSegmentIndex);
    if (myUISegmentedControl.selectedSegmentIndex ==0) {
        
        [self.viewDate removeFromSuperview];
       
    
        
    }
    else{
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
