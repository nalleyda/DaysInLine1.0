//
//  ViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "ViewController.h"
#import "homeView.h"
#import "daylineView.h"
#import "selectView.h"
#import "dayLineScoller.h"
#import "buttonInScroll.h"
#import "editingViewController.h"
#import "globalVars.h"


@interface ViewController ()<CKCalendarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) daylineView *my_selectDay ;
@property (nonatomic,strong) dayLineScoller *my_scoller;
@property (nonatomic,strong) dayLineScoller *my_selectScoller;
@property (nonatomic,strong) selectView *my_select ;
@property (nonatomic,strong) NSString *today;
@property (nonatomic,strong) NSMutableArray *allTags;
@property(nonatomic, strong) NSMutableArray *HasEventsDates;
@property(nonatomic, strong) NSMutableArray *tableLeft;
@property(nonatomic, strong) NSMutableArray *tableRight;
@property(nonatomic, strong) NSString *dateToSelect;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.allTags = [[NSMutableArray alloc] init];
    
    homeView *my_homeView = [[homeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:my_homeView];
    self.homePage = my_homeView;
    
    [my_homeView.todayButton addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.selectButton addTarget:self action:@selector(selectTapped) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(85,0, self.view.bounds.size.width-85, self.view.bounds.size.height );
    self.my_dayline = [[daylineView alloc] initWithFrame:frame];
    self.my_selectDay = [[daylineView alloc] initWithFrame:frame];
    self.my_select = [[selectView alloc] initWithFrame:frame];
    self.my_select.calendar.delegate = self;
    self.my_select.eventsTable.delegate = self;
    self.my_select.eventsTable.dataSource = self;
    [self.homePage addSubview:self.my_dayline];
    [self.homePage addSubview:self.my_select];
    [self.homePage addSubview:self.my_selectDay];
    
    [self.my_dayline setHidden:YES];
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    
    //初始化全局数据
    for (int i=0; i<18; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    modifying = 0;

    
    
    //创建或打开数据库
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
    //   NSFileManager *filemanager = [NSFileManager defaultManager];
    
    NSLog(@"路径：%@",databasePath);
    sqlite3_stmt *statement;
    sqlite3_stmt *statement_1;
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        /*           NSString *createsql = @"CREATE TABLE IF NOT EXISTS DAYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,DATE TEXT UNIQUE,MOOD INTEGER,GROWTH INTEGER)";
         */
        NSString *createDayable = @"CREATE TABLE IF NOT EXISTS DAYTABLE (DATE TEXT PRIMARY KEY,MOOD INTEGER,GROWTH INTEGER)";
        NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime TEXT,endTime TEXT,distance TEXT,label TEXT,remind TEXT,startArea INTEGER,photoDir TEXT)";
        //      NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";
        NSString *createTag = @"CREATE TABLE IF NOT EXISTS TAG (tagID INTEGER PRIMARY KEY AUTOINCREMENT,tagName TEXT UNIQUE)";
        
        [self execSql:createDayable];
        [self execSql:createEvent];
        [self execSql:createTag];
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    self.HasEventsDates = [[NSMutableArray alloc] init];
  //  NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *queryDays = [NSString stringWithFormat:@"SELECT DATE from DAYTABLE"];
    const char *queryDaystatement = [queryDays UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryDaystatement, -1, &statement_1, NULL)==SQLITE_OK) {
        NSLog(@"select success!!!");
        while (sqlite3_step(statement_1)==SQLITE_ROW) {
            //找到存在的日期，设置日历上的有事件的日期
            NSLog(@"find something!!!!");
            char *date = (char *) sqlite3_column_text(statement_1, 0);
            NSString *dateWithEvent = [NSString stringWithUTF8String:date];
            NSLog(@"date is : %@",[dateFormatter dateFromString:dateWithEvent]);
            NSDate *dateUnconvert = [dateFormatter dateFromString:dateWithEvent];
     //      NSInteger zoneInterval = [zone secondsFromGMTForDate: dateUnconvert];
            
            [self.HasEventsDates addObject:dateUnconvert];
            //[self.HasEventsDates addObject:[dateUnconvert dateByAddingTimeInterval:zoneInterval]];
        }
        
        
        NSLog(@"%@",self.HasEventsDates);
    }else {
        NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
    }
    
    sqlite3_finalize(statement_1);
    
    
    
    
    NSString *queryStar = [NSString stringWithFormat:@"SELECT tagname from TAG"];
    const char *queryStarstatement = [queryStar UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原界面
            char *tagName = (char *) sqlite3_column_text(statement, 0);
            [self.allTags addObject:[NSString stringWithUTF8String:tagName]];
            
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement);
    
    
    sqlite3_close(dataBase);
    
    
    
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    NSLog(@"x:%f,y:%f\nwidth%f,height%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    

       
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)todayTapped
{

    for (int i=0; i<18; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    
    if (self.my_dayline.hidden) {
        [self.my_dayline setHidden:NO];
    }
  
        
        
        self.my_scoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(1,110, self.view.frame.size.width-86.3, self.view.bounds.size.height-220)];
        
        self.my_scoller.modifyEvent_delegate = self;
        self.drawBtnDelegate = self.my_scoller;
        
        
        
        [self.my_dayline addSubview:self.my_scoller];
        
        for (int i = 0; i<10; i++) {
            [[self.my_dayline.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.my_dayline.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.my_dayline.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //获取当前日期
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        
        NSDate *curDate = [NSDate date];//获取当前日期
        [formater setDateFormat:@"yyyy-MM-dd"];
        self.today= [formater stringFromDate:curDate];
        NSLog(@"!!!!!!!%@",self.today);
        sqlite3_stmt *statement;
        
        modifyDate = self.today;
        const char *dbpath = [databasePath UTF8String];
        //查看当天是否已经有数据
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryStar = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
            const char *queryStarstatement = [queryStar UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //当天数据已经存在，则取出数据还原界面
                    int moodNum = sqlite3_column_int(statement, 0);
                    for (int i = 0; i<=moodNum-1; i++) {
                        [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = moodNum; j<5; j++) {
                        [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                    
                    
                    int growthNum = sqlite3_column_int(statement, 1);
                    for (int i = 0; i<=growthNum-1; i++) {
                        [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = growthNum; j<5; j++) {
                        [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else {
                    // 插入当天的数据
                    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                    
                    //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                    const char *insertsatement = [insertSql UTF8String];
                    sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                    sqlite3_bind_text(statement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 2, 0);
                    sqlite3_bind_int(statement, 3, 0);
                    
                    
                    if (sqlite3_step(statement)==SQLITE_DONE) {
                        NSLog(@"innsert today ok");
                    }
                    else {
                        NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                    }
                    
                }
                
            }
            else{
                NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));
                
            }
            sqlite3_finalize(statement);
            
            NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,title,startTime,endTime from event where DATE=\"%@\"",modifyDate];
            const char *queryEventstatement = [queryEventButton UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    //当天已有事件存在，则取出数据还原界面
                    NSString *title;
                    NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                    char *ttl = (char *)sqlite3_column_text(statement, 1);
                    NSLog(@"char is %s",ttl);
                    if (ttl == nil) {
                        title = @"";
                    }else {
                        title = [[NSString alloc] initWithUTF8String:ttl];
                        NSLog(@"nsstring  is %@",title);
                    }
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,3)];
                    
                    [self.drawBtnDelegate redrawButton:startTm :endTm :title :evtType :NULL];
                    
                    if ([evtType intValue]==0) {
                        for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                            workArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else if([evtType intValue]==1){
                        for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                            lifeArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else{
                        NSLog(@"事件类型有误！");
                    }
                    
                }
                
            }
            
            sqlite3_finalize(statement);
            
        }
 

        
        else {
            NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
         
     
}

-(void)starTapped:(UIButton*)sender
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        if (sender.tag <100) {
            if (self.my_dayline.hidden == NO) {
                for (int i = 0; i<=sender.tag; i++) {
                    
                    
                    [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = sender.tag+1; j<5; j++) {
                    [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
            }else if(self.my_selectDay.hidden == NO){
                for (int i = 0; i<=sender.tag; i++) {
                    
                    
                    [[self.my_selectDay.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = sender.tag+1; j<5; j++) {
                    [[self.my_selectDay.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
            }
            //数据库更新
            
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set MOOD=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag+1);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            
        }
        else
        {
            if (self.my_dayline.hidden == NO) {
                for (int i = 0; i<=sender.tag-100; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = sender.tag-99; j<5; j++) {
                    [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
            }else if (self.my_selectDay.hidden ==NO){
                for (int i = 0; i<=sender.tag-100; i++) {
                    [[self.my_selectDay.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = sender.tag-99; j<5; j++) {
                    [[self.my_selectDay.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
            }
            //数据库更新
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set growth=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag-99);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
        }
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    sqlite3_close(dataBase);
    
}

-(void)eventTapped:(UIButton *)sender
{
   editingViewController *my_editingViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_editingViewController.eventType = [NSNumber numberWithInt:sender.tag];
    NSLog(@"type is:%@",my_editingViewController.eventType);
    if(self.my_dayline.hidden == NO){
        my_editingViewController.drawBtnDelegate = self.my_scoller;
    }else if (self.my_selectDay.hidden == NO){
        my_editingViewController.drawBtnDelegate = self.my_selectScoller;
    }

   // my_editingViewController.addTagDataDelegate = self;
    my_editingViewController.tags = self.allTags;

    modifying = 0;
    
    my_editingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:my_editingViewController animated:YES completion:Nil ];
    
}


-(void)selectTapped
{
    
    [self.my_selectDay setHidden:YES];
    [self.my_dayline setHidden:YES];
    if (self.my_select.hidden) {
        [self.my_select setHidden: NO];
    }
    self.tableLeft = [[NSMutableArray alloc] init];
    self.tableRight = [[NSMutableArray alloc] init];
    
    [self.my_select.goInThatDay addTarget:self action:@selector(goInThatDayTapped) forControlEvents:UIControlEventTouchUpInside];
}
-(void)goInThatDayTapped
{
    for (int i=0; i<18; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    
    [self.my_select setHidden:YES];
    [self.my_dayline setHidden:YES];
    
    if (self.my_selectDay.hidden) {
        [self.my_selectDay setHidden:NO];
    }
  
    
    self.my_selectScoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(1,110, self.view.frame.size.width-86.3, self.view.bounds.size.height-220)];
    
    self.my_selectScoller.modifyEvent_delegate = self;
    self.drawBtnDelegate = self.my_selectScoller;
    
    
    
    [self.my_selectDay addSubview:self.my_selectScoller];
    
    for (int i = 0; i<10; i++) {
        [[self.my_selectDay.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.my_selectDay.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_selectDay.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取将要查询的日期
    modifyDate = self.dateToSelect;
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    //查看当天是否已经有数据
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryStar = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
        const char *queryStarstatement = [queryStar UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //当天数据已经存在，则取出数据还原界面
                int moodNum = sqlite3_column_int(statement, 0);
                for (int i = 0; i<=moodNum-1; i++) {
                    [[self.my_selectDay.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = moodNum; j<5; j++) {
                    [[self.my_selectDay.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
                
                
                int growthNum = sqlite3_column_int(statement, 1);
                for (int i = 0; i<=growthNum-1; i++) {
                    [[self.my_selectDay.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = growthNum; j<5; j++) {
                    [[self.my_selectDay.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
                
            }
            /*   else {
             // 插入当天的数据
             NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
             
             //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
             const char *insertsatement = [insertSql UTF8String];
             sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
             sqlite3_bind_text(statement, 1, [self.dateToSelect UTF8String], -1, SQLITE_TRANSIENT);
             sqlite3_bind_int(statement, 2, 0);
             sqlite3_bind_int(statement, 3, 0);
             
             
             if (sqlite3_step(statement)==SQLITE_DONE) {
             NSLog(@"innsert today ok");
             }
             else {
             NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
             }
             
             }
             
             */
        }
        else{
            NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));
            
        }
        sqlite3_finalize(statement);
        
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,title,startTime,endTime from event where DATE=\"%@\"",modifyDate];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                NSString *title;
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                char *ttl = (char *)sqlite3_column_text(statement, 1);
                NSLog(@"char is %s",ttl);
                if (ttl == nil) {
                    title = @"";
                }else {
                    title = [[NSString alloc] initWithUTF8String:ttl];
                    NSLog(@"nsstring  is %@",title);
                }
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,3)];
                
                [self.drawBtnDelegate redrawButton:startTm :endTm :title :evtType :NULL];
                
                if ([evtType intValue]==0) {
                    for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                        workArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else if([evtType intValue]==1){
                    for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                        lifeArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else{
                    NSLog(@"事件类型有误！");
                }
                
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    
    
    else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    
    
}

//数据库操作方法
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSLog(@"数据库操作数据失败!");
    }
}

#pragma mark - modify delegation

-(void)modifyEvent:(NSNumber *)startArea;
{
    NSString *title_mdfy;
    NSString *mainTxt_mdfy;
    NSNumber *evtID_mdfy;
    NSNumber *evtType_mdfy;
  
    NSString *startTime;
    NSString *endTime;
    
    NSNumber *income;
    NSNumber *expend;
    NSString *remind;
    NSString *oldLabel;
   // NSArray *tagToDraw = [[NSArray alloc] init];
 
    modifying = 1;
    
    NSLog(@"button tag is -----%@",startArea);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,startTime,endTime,income,expend,label,remind from event where DATE=\"%@\" and startArea=\"%d\"",modifyDate,[startArea intValue]];
        const char *queryEventstatment = [queryEvent UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //找到要修改的事件，取出数据。
                
    
                evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];

                evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                NSLog(@"char_mdfy is %s",ttl_mdfy);
                if (ttl_mdfy == nil) {
                    title_mdfy = @"";
                }else {
                    title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                }
                
                char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                if (mTxt_mdfy == nil) {
                    mainTxt_mdfy = @"";
                }else {
                    mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                }
                
                
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,4)];
               int start = [startTm intValue]+360;
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
               int end = [endTm intValue]+360;
                if (start%60<10) {
                    startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];

                }else{
                    startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                }
                if (end%60<10) {
                    endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                    
                }else{
                    endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                }

                
                NSLog(@"start time is:%@",startTime);
                
                income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
                expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                
                char *oldTags = (char *)sqlite3_column_text(statement, 8);
                if (oldTags == nil) {
                    oldLabel = @"";
                }else {
                    oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                    
                    NSLog(@"nsstring_old labels  is %@",oldLabel);
                }

                
                char *remind_mdfy = (char *)sqlite3_column_text(statement, 9);
                if (remind_mdfy == nil) {
                    remind = @"";
                }else {
                    remind = [[NSString alloc] initWithUTF8String:remind_mdfy];

                    NSLog(@"nsstring_mdfy  is %@",remind);
                }
                            }
            
        }
        else{
            NSLog(@"wwwwwwwwwwww!!!!!1");
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    editingViewController *my_modifyViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    self.drawLabelDelegate = my_modifyViewController;
    if(self.my_dayline.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_scoller;
    }else if (self.my_selectDay.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_selectScoller;
    }
  //  my_modifyViewController.addTagDataDelegate = self;
    my_modifyViewController.tags = self.allTags;
    
    


    
    
    //将该事件还原现使出来
    my_modifyViewController.eventType = evtType_mdfy;
    [(UITextField*)[my_modifyViewController.view viewWithTag:105] setText:title_mdfy] ;
    [(UITextView*)[my_modifyViewController.view viewWithTag:106] setText:mainTxt_mdfy];
    [(UILabel*)[my_modifyViewController.view viewWithTag:103] setText:startTime];
    [(UILabel*)[my_modifyViewController.view viewWithTag:104] setText:endTime];
    [(UIButton*)[my_modifyViewController.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
    [(UIButton*)[my_modifyViewController.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
    my_modifyViewController.incomeFinal = [income doubleValue];
    my_modifyViewController.expendFinal = [expend doubleValue];
    [self.drawLabelDelegate drawTag:oldLabel];
  //  my_modifyViewController.oldLabel = oldLabel;
    my_modifyViewController.remindData = remind;
    
 //   [(UITextField*)[my_modifyViewController.moneyAlert viewWithTag:501] setText:[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]];
    modifyEventId = [evtID_mdfy intValue];
    NSLog(@"eventID is : %d",modifyEventId);
   // NSLog(@"income is &&&&&&: %@",[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]);
    
    
    my_modifyViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@==========%@",evtType_mdfy,my_modifyViewController.eventType);
    [self presentViewController:my_modifyViewController animated:YES completion:Nil ];
        

}

- (BOOL)dateHasEvents:(NSDate *)date {
    for (NSDate *eventDate in self.HasEventsDates) {

        if ([eventDate isEqualToDate:date]) {
            
            return YES;
        }
    }
    return NO;
}

#pragma mark CKCalender delegate
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
 
    // TODO: play with the coloring if we want to...
    if ([self dateHasEvents:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSLog(@"选中：%@",date);
    NSString *titleDetail;
    NSString *LabelIntable;

    [self.tableRight removeAllObjects];
    [self.tableLeft removeAllObjects];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    if ([self dateHasEvents:date]) {
        self.dateToSelect = [formater stringFromDate:date];
        NSLog(@"%@",self.dateToSelect);
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT title,label from event where DATE=\"%@\"",self.dateToSelect];
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {

                    //找到事件,写入tableView。
                    
                    
                    char *ttl = (char *)sqlite3_column_text(statement, 0);
                   
                    if (ttl == nil) {
                        titleDetail = @"空";
                    }else {
                        titleDetail = [[NSString alloc] initWithUTF8String:ttl];
                        NSLog(@"titleDetail  is %@",titleDetail);
                    }
                    
                    [self.tableRight addObject:titleDetail];
                    
                    char *Tag = (char *)sqlite3_column_text(statement, 1);
                    if (Tag == nil) {
                        LabelIntable = @"无标签";
                    }else {
                        LabelIntable = [[NSString alloc] initWithUTF8String:Tag];
                        
                        NSLog(@"LabelIntable   is %@",LabelIntable);
                    }
                    [self.tableLeft addObject:LabelIntable];
                    
                }
                NSLog(@"%@",self.tableRight);
                
            }
            else{
                NSLog(@"qqqqqqqq!!!!!1");
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        
    }
    [self.my_select.eventsTable reloadData];
}

#pragma mark tavleView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  NSLog(@"count:%d",[currentAlbumData[@"titles"] count]);
    return self.tableRight.count;
}

// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectEvent"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEvent"];
        
        
    }
    NSUInteger row=[indexPath row];
    
    //设置文本
    if (row<self.tableRight.count) {
        cell.textLabel.text = self.tableLeft[row];
        
        cell.detailTextLabel.text = self.tableRight[row];
        

    }
    

    
    return cell;
}



@end
