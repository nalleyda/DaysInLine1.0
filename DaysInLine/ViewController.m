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
#import "collectionView.h"
#import "globalVars.h"


@interface ViewController ()<CKCalendarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) daylineView *my_selectDay ;
@property (nonatomic,strong) dayLineScoller *my_scoller;
@property (nonatomic,strong) dayLineScoller *my_selectScoller;
@property (nonatomic,strong) selectView *my_select ;
@property (nonatomic,strong) collectionView *my_collect;
@property (nonatomic,strong) NSString *today;
@property (nonatomic,strong) NSMutableArray *allTags;
@property(nonatomic, strong) NSMutableArray *HasEventsDates;

@property(nonatomic, strong) NSMutableArray *tableLeft;
@property(nonatomic, strong) NSMutableArray *tableRight;
@property(nonatomic, strong) NSMutableArray *EventsInTag;
@property(nonatomic, strong) NSMutableArray *EventsIDInTag;
@property(nonatomic, strong) NSString *dateToSelect;

@property(nonatomic, strong) NSMutableArray *collectEvent;
@property(nonatomic, strong) NSMutableArray *collectEventTitle;
@property(nonatomic, strong) NSMutableArray *collectEventTag;
@property(nonatomic, strong) NSMutableArray *collectEventDate;
@property(nonatomic, strong) NSMutableArray *collectEventStart;
@property(nonatomic, strong) NSMutableArray *collectEventEnd;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellinCollection;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.allTags = [[NSMutableArray alloc] init];
    self.EventsInTag = [[NSMutableArray alloc] init];
    self.EventsIDInTag = [[NSMutableArray alloc] init];
    self.collectEvent = [[NSMutableArray alloc] init];
      self.collectEventTitle = [[NSMutableArray alloc] init];
      self.collectEventTag = [[NSMutableArray alloc] init];
      self.collectEventDate = [[NSMutableArray alloc] init];
      self.collectEventStart = [[NSMutableArray alloc] init];
      self.collectEventEnd = [[NSMutableArray alloc] init];
    
    homeView *my_homeView = [[homeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:my_homeView];
    self.homePage = my_homeView;
    
    [my_homeView.todayButton addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.selectButton addTarget:self action:@selector(selectTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.treasureButton addTarget:self action:@selector(treasureTapped) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(85,0, self.view.bounds.size.width-85, self.view.bounds.size.height );
    self.my_dayline = [[daylineView alloc] initWithFrame:frame];
    self.my_selectDay = [[daylineView alloc] initWithFrame:frame];
    self.my_select = [[selectView alloc] initWithFrame:frame];
    self.my_collect = [[collectionView alloc] initWithFrame:frame];
    self.my_select.calendar.delegate = self;
    self.my_select.eventsTable.delegate = self;
    self.my_select.eventsTable.dataSource = self;
    self.my_select.alltagTable.delegate = self;
    self.my_select.alltagTable.dataSource = self;
    self.my_select.eventInTagTable.delegate = self;
    self.my_select.eventInTagTable.dataSource = self;
    self.my_collect.collectionTable.delegate = self;
    self.my_collect.collectionTable.dataSource = self;
    [self.homePage addSubview:self.my_dayline];
    [self.homePage addSubview:self.my_select];
    [self.homePage addSubview:self.my_selectDay];
    [self.homePage addSubview:self.my_collect];
    
    
    
    [self.my_dayline setHidden:YES];
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_collect setHidden:YES];
    
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
        NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime REAL,endTime REAL,distance TEXT,label TEXT,remind TEXT,startArea INTEGER,photoDir TEXT)";
        //      NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";
        NSString *createTag = @"CREATE TABLE IF NOT EXISTS TAG (tagID INTEGER PRIMARY KEY AUTOINCREMENT,tagName TEXT UNIQUE)";
        
        NSString *createCollect = @"CREATE TABLE IF NOT EXISTS collection (collectionID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER)";
        
        [self execSql:createDayable];
        [self execSql:createEvent];
        [self execSql:createTag];
        [self execSql:createCollect];
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
        
        
       // NSLog(@"%@",self.HasEventsDates);
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

    for (int i=0; i<36; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_collect setHidden:YES];
    
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
        self.my_dayline.dateNow.text = modifyDate;
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
    [self.my_collect setHidden:YES];
    
    if (self.my_select.hidden) {
               // [self.my_select.alltagTable reloadData];
        [self.my_select setHidden: NO];
    }
    self.tableLeft = [[NSMutableArray alloc] init];
    self.tableRight = [[NSMutableArray alloc] init];
    
    [self.my_select.goInThatDay addTarget:self action:@selector(goInThatDayTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_select.returnToTags addTarget:self action:@selector(returnToTagsTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.my_select.alltagTable setHidden:NO];
    [self.my_select.eventInTagTable setHidden:YES];
    [self.my_select.returnToTags setHidden:YES];
}

-(void)returnToTagsTapped
{
    [self.my_select.alltagTable setHidden:NO];
    [self.my_select.eventInTagTable setHidden:YES];
    [self.my_select.returnToTags setHidden:YES];
}

-(void)goInThatDayTapped
{
    for (int i=0; i<36; i++) {
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
    self.my_selectDay.dateNow.text = modifyDate;
    
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


-(void)treasureTapped
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    sqlite3_stmt *stateQueryEvent;
    NSNumber *collectEventID;
    
    NSString *eventTittle;
    NSString *eventDate;
    NSString *eventStart;
    NSString *eventEnd;
    NSString *eventTag;
    
    [self.my_select setHidden:YES];
    [self.my_dayline setHidden:YES];
    [self.my_selectDay setHidden:YES];
  
    
    [self.collectEvent removeAllObjects];
    [self.collectEventTitle removeAllObjects];
    [self.collectEventTag removeAllObjects];
    [self.collectEventDate removeAllObjects];
    [self.collectEventStart removeAllObjects];
    [self.collectEventEnd removeAllObjects];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventId = [NSString stringWithFormat:@"SELECT eventID from collection"];
        const char *queryEventIdstatment = [queryEventId UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventIdstatment, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //找到收藏的事件ID，存入collectEvent数组。
                
                collectEventID = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                
                [self.collectEvent addObject:collectEventID];
                
            }
            
        }
        else{
            NSLog(@"查询不OK啊啊啊");
        }
        sqlite3_finalize(statement);
        
        
        for (int i = 0; i<self.collectEvent.count; i++) {
            NSString *queryEventId = [NSString stringWithFormat:@"SELECT title,date,startTime,endTime,label from event where eventID=\"%d\"",[(NSNumber *)self.collectEvent[i] intValue]];

            const char *queryEventIdstatment = [queryEventId UTF8String];
            
            if  (sqlite3_prepare_v2(dataBase, queryEventIdstatment, -1, &stateQueryEvent, NULL)==SQLITE_OK) {
                if   (sqlite3_step(stateQueryEvent)==SQLITE_ROW) {
                    //找到要查询的事件，取出数据。
                    
                    char *ttl_mdfy = (char *)sqlite3_column_text(stateQueryEvent, 0);
                    NSLog(@"char_eventTittle is %s",ttl_mdfy);
                    if (ttl_mdfy == nil) {
                        eventTittle = @"";
                    }else {
                        eventTittle = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                        NSLog(@"nsstring_eventTittle  is %@",eventTittle);
                    }
                    [self.collectEventTitle addObject:eventTittle];
                    
                    
                    char *date_mdfy = (char *)sqlite3_column_text(stateQueryEvent, 1);
                    NSLog(@"date_mdfy is %s",date_mdfy);
                    if (date_mdfy == nil) {
                        eventDate = @"";
                    }else {
                        eventDate = [[NSString alloc] initWithUTF8String:date_mdfy];
                        NSLog(@"nsstring_date  is %@",eventDate);
                    }
                    [self.collectEventDate addObject:eventDate];
                    

                    
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(stateQueryEvent,2)];
                    int start = [startTm intValue]+360;
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(stateQueryEvent,3)];
                    int end = [endTm intValue]+360;
                    if (start%60<10) {
                        eventStart = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];
                        
                    }else{
                        eventStart = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                    }
                    if (end%60<10) {
                        eventEnd = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                        
                    }else{
                        eventEnd = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                    }
                    
                    [self.collectEventStart addObject:eventStart];
                    [self.collectEventEnd addObject:eventEnd];
                    
        //            NSLog(@"start time is:%@",startTime);
                    
                   
                    char *EvtTag = (char *)sqlite3_column_text(stateQueryEvent, 4);
                    if (EvtTag == nil) {
                        eventTag = @"";
                    }else {
                        eventTag = [[NSString alloc] initWithUTF8String:EvtTag];
                        
                        NSLog(@"nsstring_old labels  is %@",eventTag);
                    }
                    
                    [self.collectEventTag addObject:eventTag];
                    
                   
                }
                
            }
            else{
                NSLog(@"wwwwwwwwwwww!!!!!2");
            }
            sqlite3_finalize(stateQueryEvent);
        }

        
        
        
    }
    else {
        NSLog(@"数据库打开失败啊啊啊");
        
    }
    sqlite3_close(dataBase);
    
     NSLog(@"%@,%@,%@,%@,%@",self.collectEvent,self.collectEventTitle,self.collectEventTag,self.collectEventDate,self.collectEventStart);
    
    [self.my_collect.collectionTable reloadData];
    
    if (self.my_collect.hidden==YES) {
        [self.my_collect setHidden:NO];
    }
   
    
    
    NSLog(@"%d",self.my_collect.collectionTable.tag);
  }


-(void)seizeArea:(NSString *)date
{
    
    for (int i=0; i<36; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,startTime,endTime from event where DATE=\"%@\"",date];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
              
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                
                
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
        
    }else {
        NSLog(@"数据库打开失败aaaa啊啊啊");
        
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
    my_modifyViewController.reloadDelegate = self;
    if(self.my_dayline.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_scoller;
    }else if (self.my_selectDay.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_selectScoller;
    }

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
    NSInteger tableRows ;
    //  NSLog(@"count:%d",[currentAlbumData[@"titles"] count]);
    switch (tableView.tag) {
        case 0:
            tableRows = self.tableRight.count;
            break;
        case 1:
            tableRows = self.allTags.count;
            break;
        case 2:
            tableRows = self.EventsInTag.count;
                NSLog(@"~~~~~~~~~%d~~~~~~~~~",tableRows);
            break;
        case 3:
            tableRows = self.collectEvent.count;
             NSLog(@"^^^^^^^^^%d^^^^^^^^^",tableRows);
            break;
            
        default: tableRows = 0;
            break;
    }

    return tableRows;
    
}

// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:@"selectEvent"];
    UITableViewCell *cell_2 = [tableView dequeueReusableCellWithIdentifier:@"selectTags"];
    UITableViewCell *cell_3 = [tableView dequeueReusableCellWithIdentifier:@"selectEventsInTag"];
    UITableViewCell *cell_4 = [tableView dequeueReusableCellWithIdentifier:@"CustomXibCellIdentifier"];
    switch (tableView.tag) {
        case 0:
            
            if (!cell_1)
            {
                cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEvent"];
            }
            NSUInteger row1=[indexPath row];
            [cell_1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            //设置文本
            if (row1<self.tableRight.count) {
                cell_1.textLabel.text = self.tableLeft[row1];
                
                cell_1.detailTextLabel.text = self.tableRight[row1];
            }
            cell = cell_1;

            break;
        case 1:
            if (!cell_2)
            {
                cell_2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectTags"];
                [cell_2 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
                NSUInteger row2=[indexPath row];
            
            
                //设置文本
            if (row2<self.allTags.count) {
                cell_2.textLabel.text = self.allTags[row2];
                NSLog(@"%@",self.allTags);
                
            }
            cell = cell_2;

            break;
        
        case 2:
            
            if (!cell_3)
            {
                cell_3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEventsInTag"];
                [cell_3 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
            
                NSUInteger row3=[indexPath row];
            //设置文本
            if (row3<self.EventsInTag.count) {
                cell_3.textLabel.text = self.EventsInTag[row3];
                NSLog(@"%@",self.EventsInTag[row3]);
                
            }
            cell = cell_3;
   
            
            break;
        
        case 3:

            if(cell_4==nil){
                cell_4 = [[[NSBundle mainBundle]loadNibNamed:@"collectCell" owner:self options:nil] lastObject];//加载nib文件
                
            }
            
         
            NSUInteger row4=[indexPath row];
            //设置文本
            if (row4<self.collectEvent.count) {
                NSLog(@"%@,%@,%@,%@",self.collectEventTitle[row4],self.collectEventTag[row4],self.collectEventDate[row4],self.collectEventStart[row4]);
                ((UILabel *)[cell_4.contentView viewWithTag:1]).text = self.collectEventTitle[row4];
                //NSLog(@"%@",self.collectEventTitle[row4]);
                ((UILabel *)[cell_4.contentView viewWithTag:2]).text = self.collectEventTag[row4];
                ((UILabel *)[cell_4.contentView viewWithTag:3]).text = self.collectEventDate[row4];
                ((UILabel *)[cell_4.contentView viewWithTag:4]).text =[NSString stringWithFormat:@"%@-%@",self.collectEventStart[row4],self.collectEventEnd[row4]];
                
            }
            
            cell = cell_4;
            break;
            
        default: cell = nil;
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *evtTitle;
    NSNumber *evtID;
    NSUInteger row=[indexPath row];
    sqlite3_stmt *statement;
    
    
    NSString *title_mdfy;
    NSString *mainTxt_mdfy;
    NSNumber *evtID_mdfy;
    NSNumber *evtType_mdfy;
    
    NSString *dateGoesIn;
    NSString *dateInCollect;
    NSString *startTime;
    NSString *endTime;
    
    NSNumber *income;
    NSNumber *expend;
    NSString *remind;
    NSString *oldLabel;
    
    const char *dbpath = [databasePath UTF8String];

    
   // tag:0为按日期查询界面中的列表，1为查询界面中的tag列表，2为点击某一tag之后的所有事件列表，3为收藏中的列表
    switch (tableView.tag) {
        case 0:
            
            break;
        case 1:
  
            [self.EventsIDInTag removeAllObjects];
            [self.EventsInTag removeAllObjects];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT title,eventID from event where label like'%%%@%%'",self.allTags[row]];
                const char *queryEventstatment = [queryEvent UTF8String];
                if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件主题，取出数据。
  
                        char *ttl_mdfy = (char *)sqlite3_column_text(statement, 0);
                        if (ttl_mdfy == nil) {
                            evtTitle = @"空";
                        }else {
                            evtTitle = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                            
                        }
                        
                        evtID = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                        
                        [self.EventsInTag addObject:evtTitle];
                        [self.EventsIDInTag addObject:evtID];
                    }
                    
                }
                else{
                    NSLog(@"查询不OK");
                }
                sqlite3_finalize(statement);
               

            }
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self.my_select.eventInTagTable reloadData];
            
            [self.my_select.alltagTable setHidden:YES];
            [self.my_select.eventInTagTable setHidden:NO];
            [self.my_select.returnToTags setHidden:NO];
    

            break;
        case 2:
        {
            modifying = 1;
            int eventid = [self.EventsIDInTag[row] intValue];
            
            sqlite3_stmt *statement;
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,date,startTime,endTime,income,expend,label,remind from event where eventID=\"%d\"",eventid];
                const char *queryEventstatment = [queryEvent UTF8String];
                if  (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while  (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件，取出数据。
                        
                        
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
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 4);
                        NSLog(@"date_mdfy is %s",date_mdfy);
                        if (date_mdfy == nil) {
                            dateGoesIn = @"";
                        }else {
                            dateGoesIn = [[NSString alloc] initWithUTF8String:date_mdfy];
                            NSLog(@"nsstring_dateGoesIn  is %@",dateGoesIn);
                        }
                        
                        [self seizeArea:dateGoesIn];
                        NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
                        int start = [startTm intValue]+360;
                        NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
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
                        
                        income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                        expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,8)];
                        
                        char *oldTags = (char *)sqlite3_column_text(statement, 9);
                        if (oldTags == nil) {
                            oldLabel = @"";
                        }else {
                            oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                            
                            NSLog(@"nsstring_old labels  is %@",oldLabel);
                        }
                        
                        
                        char *remind_mdfy = (char *)sqlite3_column_text(statement, 10);
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
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            editingViewController *my_selectEvent = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
            self.drawLabelDelegate = my_selectEvent;
            my_selectEvent.reloadDelegate = self;
            if(self.my_dayline.hidden == NO){
                my_selectEvent.drawBtnDelegate = self.my_scoller;
            }else if (self.my_selectDay.hidden == NO){
                my_selectEvent.drawBtnDelegate = self.my_selectScoller;
            }
            //  my_modifyViewController.addTagDataDelegate = self;
            my_selectEvent.tags = self.allTags;
            
                        
            
            //将该事件还原现使出来
            my_selectEvent.eventType = evtType_mdfy;
            [(UITextField*)[my_selectEvent.view viewWithTag:105] setText:title_mdfy] ;
            [(UITextView*)[my_selectEvent.view viewWithTag:106] setText:mainTxt_mdfy];
            [(UILabel*)[my_selectEvent.view viewWithTag:103] setText:startTime];
            [(UILabel*)[my_selectEvent.view viewWithTag:104] setText:endTime];
            [(UIButton*)[my_selectEvent.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
            [(UIButton*)[my_selectEvent.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
            my_selectEvent.incomeFinal = [income doubleValue];
            my_selectEvent.expendFinal = [expend doubleValue];
            [self.drawLabelDelegate drawTag:oldLabel];

            my_selectEvent.remindData = remind;
            
            modifyEventId = [evtID_mdfy intValue];
            my_selectEvent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:my_selectEvent animated:YES completion:Nil ];
            
        }
            break;
            
        case 3:
        {
            NSLog(@"colletcell tapped");
            
            modifying = 1;
            int collectEventid = [self.collectEvent[row] intValue];
            
            sqlite3_stmt *statement;
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,date,startTime,endTime,income,expend,label,remind from event where eventID=\"%d\"",collectEventid];
                const char *queryEventstatment = [queryEvent UTF8String];
                if  (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while  (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件，取出数据。
                        
                        
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
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 4);
                        NSLog(@"date_mdfy is %s",date_mdfy);
                        if (date_mdfy == nil) {
                            dateInCollect = @"";
                        }else {
                            dateInCollect = [[NSString alloc] initWithUTF8String:date_mdfy];
                            NSLog(@"nsstring_dateGoesIn  is %@",dateInCollect);
                        }
                        
                        [self seizeArea:dateInCollect];
                        
                        NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
                        int start = [startTm intValue]+360;
                        NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
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
                        
                        income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                        expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,8)];
                        
                        char *oldTags = (char *)sqlite3_column_text(statement, 9);
                        if (oldTags == nil) {
                            oldLabel = @"";
                        }else {
                            oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                            
                            NSLog(@"nsstring_old labels  is %@",oldLabel);
                        }
                        
                        
                        char *remind_mdfy = (char *)sqlite3_column_text(statement, 10);
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
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            editingViewController *my_collectEvent = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
            self.drawLabelDelegate = my_collectEvent;
            my_collectEvent.reloadDelegate = self;
            if(self.my_dayline.hidden == NO){
                my_collectEvent.drawBtnDelegate = self.my_scoller;
            }else if (self.my_selectDay.hidden == NO){
                my_collectEvent.drawBtnDelegate = self.my_selectScoller;
            }
            //  my_modifyViewController.addTagDataDelegate = self;
            my_collectEvent.tags = self.allTags;
            
            
            
            
            
            
            //将该事件还原现使出来
            my_collectEvent.eventType = evtType_mdfy;
            [(UITextField*)[my_collectEvent.view viewWithTag:105] setText:title_mdfy] ;
            [(UITextView*)[my_collectEvent.view viewWithTag:106] setText:mainTxt_mdfy];
            [(UILabel*)[my_collectEvent.view viewWithTag:103] setText:startTime];
            [(UILabel*)[my_collectEvent.view viewWithTag:104] setText:endTime];
            [(UIButton*)[my_collectEvent.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
            [(UIButton*)[my_collectEvent.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
            my_collectEvent.incomeFinal = [income doubleValue];
            my_collectEvent.expendFinal = [expend doubleValue];
            [self.drawLabelDelegate drawTag:oldLabel];
            
            my_collectEvent.remindData = remind;
            
            modifyEventId = [evtID_mdfy intValue];
            my_collectEvent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:my_collectEvent animated:YES completion:Nil ];
            
    }

            
            
            break;
        default:
            
            break;
    }
    
}
- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (tableView.tag ==3) {
        return UITableViewCellEditingStyleDelete;
    }
    else
        return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //使收藏夹可删除
    if (tableView.tag == 3) {
        
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                
                // 删除某一收藏
                NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM collection WHERE eventID=?"];
                
                const char *deletestement = [deleteSql UTF8String];
                sqlite3_prepare_v2(dataBase, deletestement, -1, &statement, NULL);
                sqlite3_bind_int(statement, 1, [[self.collectEvent objectAtIndex:indexPath.row] intValue]);

              
                if (sqlite3_step(statement)==SQLITE_DONE) {
                    NSLog(@"delete collection ok");
                    [self.collectEvent removeObjectAtIndex:indexPath.row];
                }
                else {
                    NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                    
                }
                sqlite3_finalize(statement);
            }
            
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            // Delete the row from the data source.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self.tagTable setEditing:NO animated:YES];
            
            
        }
    }
    else
        return;
    
}


#pragma mark reloadTable delegate
-(void)reloadTable
{
    if (self.my_collect.hidden == NO) {
        [self treasureTapped];
    }
    if (self.my_select.hidden ==NO){
        
        NSLog(@"alltags:::%@",self.allTags);
        [self.my_select.eventsTable reloadData];
        [self.my_select.alltagTable reloadData];
        
        [self.my_select.alltagTable setHidden:NO];
        [self.my_select.eventInTagTable setHidden:YES];
        [self.my_select.returnToTags setHidden:YES];


        
    }
    
}


@end
