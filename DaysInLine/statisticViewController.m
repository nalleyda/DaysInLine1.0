//
//  statisticViewController.m
//  DaysInLine
//
//  Created by 张力 on 14-1-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "statisticViewController.h"

@interface statisticViewController ()


@end

@implementation statisticViewController

double moodAverage;
double growthAverage;
double work_life[2];
double incomeAll;
double expendAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        moodAverage = 0.0f;
        growthAverage = 0.0f;
        work_life[0] = 0.0f;
        work_life[1] = 0.0f;
        incomeAll = 0.0f;
        expendAll = 0.0f;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建或打开数据库
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
    NSLog(@"$$$$$$ %@ , %@$$$$$$",self.startDate,self.endDate);
    

    int days = 0;
    
    sqlite3_stmt *statement_event;
    sqlite3_stmt *statement_days;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,income,expend,startTime,endTime from event where DATE>=\"%@\" AND DATE<=\"%@\"",self.startDate,self.endDate];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement_event, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement_event)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement_event, 0)];
                NSNumber *income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,1)];
                NSNumber *expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,2)];
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,3)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,4)];
                
                incomeAll+=[income doubleValue];
                expendAll+=[expend doubleValue];
                work_life[ [evtType intValue] ]+=([endTm doubleValue]-[startTm doubleValue]);
               
            }
            
        }
        
        sqlite3_finalize(statement_event);
        
        //在day表中查询心情和成长指数
        
      
        NSString *queryDayButton = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE>=\"%@\" AND DATE<=\"%@\"",self.startDate,self.endDate];
        const char *queryDaystatement = [queryDayButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryDaystatement, -1, &statement_days, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement_days)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                
                NSNumber *mood = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement_days, 0)];
                NSNumber *growth = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_days,1)];
                
                moodAverage+=[mood doubleValue];
                growthAverage+=[growth doubleValue];
                days++;
                
            }
            
        }
        
        sqlite3_finalize(statement_days);
        
        
    }else {
        NSLog(@"数据库打开失败aaaa啊啊啊");
        
    }
    
    
    
    
    sqlite3_close(dataBase);
    
    NSLog(@"{%.2f,%.2f,%.2f,%.2f}",incomeAll,expendAll,work_life[0],work_life[1]);
    NSLog(@"{-----%.2f,%.2f-----}",moodAverage,growthAverage);
  /*
   moodAverage/=days;
    growthAverage/=days;
    NSLog(@"{+++++%.2f,%.2f+++++}",moodAverage,growthAverage);
   */
    //填充每一个label，显示数值。
    self.brifeLabel.text = [NSString stringWithFormat:@"本阶段共有%d天的纪录，各项数据为：",days];
    self.moodScore.text = [NSString stringWithFormat:@"%d分",(int)(100*moodAverage/(5*days))];
    self.growthScore.text = [NSString stringWithFormat:@"%d分",(int)(100*growthAverage/(5*days))];
    self.workTime.text = [NSString stringWithFormat:@"%d小时%d分钟",(int)work_life[0]/60,(int)work_life[0]%60];
    self.lifeTime.text = [NSString stringWithFormat:@"%d小时%d分钟",(int)work_life[1]/60,(int)work_life[1]%60];

    self.incomeTotal.text = [NSString stringWithFormat:@"%.2f元",incomeAll];
    self.expendTotal.text = [NSString stringWithFormat:@"%.2f元",expendAll];




    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
