//
//  editingViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "editingViewController.h"
#import "remindViewController.h"
#import "globalVars.h"

@interface editingViewController (){
    NSMutableArray *selected;
    NSMutableArray *tagLabels;
}
@end

@implementation editingViewController


bool flag;
NSString *oldRemindDate;
bool firstInmoney;
bool moveON;
bool haveSaved;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          }
    return self;
}
/*- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
       // CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = 10;
        
        // shrink the bounds of your view to compensate for the offset
        viewBounds.size.height = viewBounds.size.height -10;
        self.view.bounds = viewBounds;
    }
}
 */
- (void)viewDidLoad
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        NSLog(@"aloha!");
    }
    [super viewDidLoad];
    

    
    //self.incomeFinal=0.0f;
    firstInmoney = NO;
    //self.remindData = nil;
    NSLog(@"<<<<<%@>>>>>",self.remindData);
    tagLabels = [[NSMutableArray alloc] init];
    self.selectedTags = [[NSMutableString alloc] init];

    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];

    
    self.startTimeButton =(UIButton *)[self.view viewWithTag:101];
    self.endTimeButton =(UIButton *)[self.view viewWithTag:102];
    self.startLabel = (UILabel *)[self.view viewWithTag:103];
    self.endLabel = (UILabel *)[self.view viewWithTag:104];
    self.theme = (UITextField *)[self.view viewWithTag:105];
    self.mainText = (UITextView *)[self.view viewWithTag:106];
    
    self.imageView = [[NSMutableArray alloc] initWithCapacity:NR_IMAGEVIEW];
    for (int i = 0; i < NR_IMAGEVIEW; i++) {
        self.imageView[i] = (UIImageView *) [self.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
    }
    self.imageViewButton = [[NSMutableArray alloc] initWithCapacity:NR_IMAGEVIEW];
    for (int j = 0; j<NR_IMAGEVIEW; j++) {
        self.imageViewButton[j] = [[UIButton alloc] initWithFrame:[[self.imageView objectAtIndex:j] frame]];
        [[self.imageViewButton objectAtIndex:j] setTag:IMAGEBUTTON_TAG_BASE+j];
        [self.view addSubview:self.imageViewButton[j]];
  
        
    }
    
    self.moneyButton = (UIButton *)[self.view viewWithTag:1004];
    
   
	// Do any additional setup after loading the view.
    [self.startTimeButton addTarget:self action:@selector(startTimeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.endTimeButton addTarget:self action:@selector(endTimeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.returnButton addTarget:self action:@selector(returnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.moneyButton addTarget:self action:@selector(moneyTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.remindButton addTarget:self action:@selector(remindTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.addTagButton addTarget:self action:@selector(addTagTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.addCollectionButton addTarget:self action:@selector(addCollectTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.startTimeButton.layer.borderWidth = 3.5;
    self.startTimeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.endTimeButton.layer.borderWidth = 3.5;
    self.endTimeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSLog(@"type is:%@ ~~~~~",self.eventType);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    

}

-(void)addTagTapped
{
    selected = [[NSMutableArray alloc] init];
   
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"tagView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width/2, 372)];
    
    tmpCustomView = [nib objectAtIndex:0];
   // NSLog(@"tag 3 is: %@",self.tags[3]);
    
   // UITableView *tagTable = (UITableView *)[tmpCustomView viewWithTag:601];
    UIButton *okButton =(UIButton *)[tmpCustomView viewWithTag:602];
    [okButton addTarget:self action:@selector(okTagTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton =(UIButton *)[tmpCustomView viewWithTag:603];
    [cancelButton addTarget:self action:@selector(cancelTagTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addButton =(UIButton *)[tmpCustomView viewWithTag:604];
    [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteButton =(UIButton *)[tmpCustomView viewWithTag:605];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finishButton =(UIButton *)[tmpCustomView viewWithTag:606];
    [finishButton addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.deleteTagButton = deleteButton;
    self.addNewTagButton = addButton;
    self.finishDeleteButton = finishButton;
    [self.finishDeleteButton setHidden:YES];
    
    self.tagTable.delegate = self;
    self.tagTable.dataSource = self;
    self.tagTable.allowsMultipleSelection = YES;
    
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 1;
    
    [alert setContainerView:tmpCustomView];
   
    self.tagAlert = alert;
    
    [alert show];

}
-(void)addButtonTapped
{
    UIAlertView* addSelection;
    
    addSelection = [[UIAlertView alloc]
                    initWithTitle:@"Add tag"
                    message:nil
                    delegate:self
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:@"确定",nil];
    
    [addSelection setAlertViewStyle:UIAlertViewStylePlainTextInput];
    addSelection.tag = 3;
    
    [addSelection show];
    
}
-(void)deleteButtonTapped
{
    [self.tagTable setEditing:YES animated:YES];
    [self.addNewTagButton setHidden:YES];
    [self.deleteTagButton setHidden:YES];
    [self.finishDeleteButton setHidden:NO];
    
}

-(void)okTagTapped
{
    
    NSMutableString *choices = [[NSMutableString alloc] init];
    NSLog(@"count is %d",tagLabels.count);
    for (int i = 0 ; i< tagLabels.count ; i++) {
        UILabel * oldTag = [tagLabels objectAtIndex:i];
        [oldTag removeFromSuperview];
      
    }
    if (selected.count > 0) {
        for (int i = 0; i < selected.count; i++) {
            [choices appendFormat:@"%@,",selected[i]];
            UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(280, 150+30*i, self.view.frame.size.width-280, 20)];
            tag.text = selected[i];
            [tagLabels addObject:tag];
            [self.view addSubview:tag];
            
        }

        self.selectedTags = [choices substringToIndex:(choices.length-1)];
        NSLog(@"OK   tapped---->:%@",self.selectedTags);

    }
    else
    {
        self.selectedTags = @"";
    }
  
    [self.tagAlert close];
}
-(void)cancelTagTapped
{
   [self.tagAlert close];
}

-(void)finishButtonTapped
{
    [self.tagTable setEditing:NO animated:YES];
    [self.addNewTagButton setHidden:NO];
    [self.deleteTagButton setHidden:NO];
    [self.finishDeleteButton setHidden:YES];
}

-(void)remindTapped
{
    remindViewController *my_remind = [[remindViewController alloc] initWithNibName:@"remindViewController" bundle:nil];
    my_remind.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    my_remind.setRemindDelegate = self;
    NSLog(@"<<<<<%@>>>>>2",self.remindData);
    oldRemindDate = self.remindData;

    [self presentViewController:my_remind animated:YES completion:Nil ];
    
}

/*
//tag=3的actionsheet
-(void)remindTapped
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    actionSheet.tag = 3;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height/2-15)];
    view1.backgroundColor = [UIColor clearColor];
 
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"按日期提醒", @"按间隔提醒"]];
    segmentedControl.frame = CGRectMake(self.view.frame.size.width/6, 20, 2*(self.view.frame.size.width/3), 35);
    
    segmentedControl.selectedSegmentIndex= 0;
    segmentedControl.backgroundColor = [UIColor clearColor];
    
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
  
    
    UIDatePicker *remindDatePicker = [[UIDatePicker alloc] init] ;
    
    remindDatePicker.datePickerMode = UIDatePickerModeDate;
    remindDatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    remindDatePicker.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/4);
    
    
	[actionSheet showInView:self.view];
    [actionSheet addSubview:remindDatePicker];
    [actionSheet addSubview:segmentedControl];
    
}
*/

-(void) photoTapped
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:@"取消"
                                    otherButtonTitles:@"拍照", @"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                            delegate:self
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"取消"
                                   otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                          stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *name = [NSString stringWithFormat:@"%@.png", UUID];
    
    [self saveImage:image withName: name];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    int index = 0;
    if ([self.imageName isEqualToString:@""] || self.imageName == nil) {
        self.imageName = name;
    } else {
        self.imageName = [NSString stringWithFormat:@"%@;%@", self.imageName, name];
        index = [[self.imageName componentsSeparatedByString:@";"] count] - 1;
    }
    [[self.imageView objectAtIndex:index] setImage:savedImage];
    //button for every imageView
    
    //[[self.imageViewButton objectAtIndex:index] setFrame:[[self.imageView objectAtIndex:index] frame]];
   // [self.view addSubview:[self.imageViewButton objectAtIndex:index]];
   // [[self.imageViewButton objectAtIndex:index] setTag:index+IMAGEBUTTON_TAG_BASE];
    NSLog(@"button tag is :%d",((UIButton *)self.imageViewButton[index]).tag );
    [[self.imageViewButton objectAtIndex:index] addTarget:self action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pictureTapped:(UIButton *)sender
{

    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"photoView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2-50,200, 100)];
    
    tmpCustomView = [nib objectAtIndex:0];
    // NSLog(@"tag 3 is: %@",self.tags[3]);
    
    // UITableView *tagTable = (UITableView *)[tmpCustomView viewWithTag:601];
    UIButton *checkButton =(UIButton *)[tmpCustomView viewWithTag:1];
    checkButton.tag = sender.tag;
    [checkButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton =(UIButton *)[tmpCustomView viewWithTag:2];
    removeButton.tag = sender.tag;
    [removeButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    //[alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 10;
    
    [alert setContainerView:tmpCustomView];
    
    self.checkAlert = alert;
    
    [alert show];

}

-(void)checkButtonTapped:(UIButton *)sender
{
    NSLog(@"查看图片");
    [self.checkAlert close];
    
    checkPhotoController *my_bigPhoto = [[checkPhotoController alloc] initWithNibName:@"checkPhotoController" bundle:nil];
    my_bigPhoto.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UIImageView *bigView = self.imageView[sender.tag-IMAGEBUTTON_TAG_BASE];
    my_bigPhoto.fullPhoto.image = bigView.image;
    
    
    
    [(UIImageView *)[my_bigPhoto.view viewWithTag:1] setImage:bigView.image ];
    

    
    [self presentViewController:my_bigPhoto animated:YES completion:Nil ];

    
    
}

-(void)removeButtonTapped:(UIButton *)sender
{
    NSLog(@"移除图片");
}

-(void)moneyTapped
{
    NSNumber *income_mdfy;
    NSNumber *expend_mdfy;
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"moneyView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height/3)];

    tmpCustomView = [nib objectAtIndex:0];
    NSLog(@"enable is : %d",tmpCustomView.userInteractionEnabled);
    [tmpCustomView setUserInteractionEnabled:YES];
    UITextField * income = (UITextField *)[tmpCustomView viewWithTag:501];
    UITextField * outcome = (UITextField *)[tmpCustomView viewWithTag:502];
    income.delegate =self;
    outcome.delegate = self;


    [income setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [outcome setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    
    if ((modifying == 1)&&(!firstInmoney)){
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT income,expend from event where eventID=\"%d\"",modifyEventId];
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //找到要修改的事件，取出数据。
                    
                    
                    income_mdfy = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement, 0)];
                    expend_mdfy = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement, 1)];
                    NSLog(@"AAAAAAA%@",income_mdfy);
                    
                    
                }
                
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        self.incomeFinal = [income_mdfy doubleValue];
        self.expendFinal = [expend_mdfy doubleValue];
        firstInmoney = YES;
        
        [income setText:[NSString stringWithFormat:@"%.2f",[income_mdfy doubleValue]]];
        [outcome setText:[NSString stringWithFormat:@"%.2f",[expend_mdfy doubleValue]]];
    }
    
    [income setText:[NSString stringWithFormat:@"%.2f",self.incomeFinal]];
    [outcome setText:[NSString stringWithFormat:@"%.2f",self.expendFinal]];

    
    UIButton *okButton =(UIButton *)[tmpCustomView viewWithTag:503];
    [okButton addTarget:self action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton =(UIButton *)[tmpCustomView viewWithTag:504];
    [cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 0;
    
    [alert setContainerView:tmpCustomView];
    
    self.moneyAlert = alert;
    
    [alert show];
}


//tag＝1的actionsheet
-(void)startTimeTapped
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    actionSheet.tag = 1;
	[actionSheet showInView:self.view];
    
	UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;

	datePicker.tag = 201;
	datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setMinuteInterval:30];
    
    /* set to 24h format */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [datePicker setLocale:locale];
    
    [actionSheet addSubview:datePicker];
}


//tag＝2的actionsheet
-(void)endTimeTapped
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    actionSheet.tag = 2;
	[actionSheet showInView:self.view];
    
	UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
	datePicker.tag = 202;
	datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setMinuteInterval:30];
    
    /* set to 24h format */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [datePicker setLocale:locale];
    
	[actionSheet addSubview:datePicker];
}

-(void)addCollectTapped
{
    //先判断当前事件是否已经保存过，如果时新增事件，先保存再加入收藏夹。
    int eventIdNow=-1;
    
    // modifying＝1时候，先查询收藏表中是否已经存在，若有，提示存在，若无，添加只收藏并提示成功。
    if (modifying == 1)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *stmtIfcollect = nil;
        sqlite3_stmt *stmtInsertCollect = nil;
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            
            NSString *queryCollectID = [NSString stringWithFormat:@"SELECT * from collection where eventID=\"%d\"",modifyEventId];
            const char *queryCollectIDstatement = [queryCollectID UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryCollectIDstatement, -1, &stmtIfcollect, NULL)==SQLITE_OK) {
                if (sqlite3_step(stmtIfcollect)==SQLITE_ROW) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message:@"收藏夹中已收录此事"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    
                    [ alert  show];
                }else{
                    
                    NSString *insertCollct = [NSString stringWithFormat:@"INSERT INTO collection(eventID) VALUES(?)"];
                    
                    const char *collectstmt = [insertCollct UTF8String];
                    sqlite3_prepare_v2(dataBase, collectstmt, -1, &stmtInsertCollect, NULL);
                    sqlite3_bind_int(stmtInsertCollect,1, modifyEventId);
                    
                    if (sqlite3_step(stmtInsertCollect)==SQLITE_DONE) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                        message:@"成功添加至收藏夹"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        
                        [ alert  show];
                        
                        NSLog(@"innsert collect ok   in modifying   collect");
                    }
                    else {
                        NSLog(@"Error while insert collect in modifying :%s",sqlite3_errmsg(dataBase));
                    }
                    
                    
                    
                }
                
                
            }else{
                NSLog(@"wwwwwwwwwwww!!!!!!!!!~~");
            }
            sqlite3_finalize(stmtIfcollect);
            sqlite3_finalize(stmtInsertCollect);
            
        } else {
            NSLog(@"数据库打开失败");
            
        }
        
        
        sqlite3_close(dataBase);
        
    }else if (modifying == 0) {
        if (([self.startLabel.text isEqualToString:@""]) || ([self.endLabel.text isEqualToString:@""])) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入事件起始和结束时间"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        
        else  {
            
            
            NSNumber *oldStartNum;
            NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
            NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
            
            double hour_0 = [startTime[0] doubleValue];
            double minite_0 = [startTime[1] doubleValue];
            double hour_1 = [endTime[0] doubleValue];
            double minite_1 = [endTime[1] doubleValue];
            
            
            
            double startNum = hour_0*60 + minite_0;
            double endNum = hour_1*60 + minite_1;
            
            if (startNum >= endNum) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"结束应该在开始之后哦"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
                return;
            }
            else{
                
                startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
                endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
                
                for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                    if([self.eventType intValue]==0 && workArea[i] == 1)
                    {
                        flag=YES;
                        break;
                    }
                    if([self.eventType intValue]==1 && lifeArea[i] == 1)
                    {
                        flag=YES;
                        break;
                    }
                }
                
                
                if (flag) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该时段已有事件存在，请修改起止时间或选择相应事件进行补充"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    alert.tag = 101;
                    [alert show];
                    
                    return;
                    
                    
                }
                else{
                    NSLog(@"the old start is :%d",[oldStartNum intValue]);
                    [self.drawBtnDelegate redrawButton:startTimeNum:endTimeNum:self.theme.text:self.eventType:oldStartNum];
                    if ([self.eventType intValue]==0) {
                        for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                            workArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else if([self.eventType intValue]==1){
                        for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                            lifeArea[i] = 1;
                            NSLog(@"seized life area is :%d",i);
                        }
                    }else{
                        NSLog(@"事件类型有误！");
                    }
                    
                    //在数据库中存储该事件
                    
                    const char *dbpath = [databasePath UTF8String];
                    sqlite3_stmt *statementInsert;
                    sqlite3_stmt *statementSelect;
                    sqlite3_stmt *statementCollect;
                    
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 插入当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO EVENT(TYPE,TITLE,mainText,income,expend,date,startTime,endTime,distance,label,remind,startArea,photoDir) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                        
                        const char *insertsatement = [insertSql UTF8String];
                        sqlite3_prepare_v2(dataBase, insertsatement, -1, &statementInsert, NULL);
                        sqlite3_bind_int(statementInsert,1, [self.eventType intValue]);
                        sqlite3_bind_text(statementInsert,2, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statementInsert,3, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                        //未添加功能的数据
                        sqlite3_bind_double(statementInsert,4, self.incomeFinal);
                        sqlite3_bind_double(statementInsert,5, self.expendFinal);
                        
                        
                        sqlite3_bind_text(statementInsert,6, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_double(statementInsert,7, [startTimeNum doubleValue]);
                        sqlite3_bind_double(statementInsert,8, [endTimeNum doubleValue]);
                        sqlite3_bind_double(statementInsert,9, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                        
                        sqlite3_bind_text(statementInsert,10, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statementInsert,11, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                        //  sqlite3_bind_int(statement,11, 0);
                        sqlite3_bind_int(statementInsert,12, [self.eventType intValue]*1000+[startTimeNum intValue]/30);
                        sqlite3_bind_text(statementInsert,13, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                        
                        if (sqlite3_step(statementInsert)==SQLITE_DONE) {
                            NSLog(@"innsert event okssssssssssscollect");
                        }
                        else {
                            NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                        }
                        
                        sqlite3_finalize(statementInsert);
                        
                        //此处添加插入收藏的数据库语句，并alert已自动保存并添加至收藏夹。
                        //先找到本次事件的eventID。
                        
                        
                        
                        NSString *queryEventID = [NSString stringWithFormat:@"SELECT eventID from event where DATE=\"%@\" and startArea=\"%d\"",modifyDate,[self.eventType intValue]*1000+[startTimeNum intValue]/30];
                        const char *queryEventIDstatement = [queryEventID UTF8String];
                        if (sqlite3_prepare_v2(dataBase, queryEventIDstatement, -1, &statementSelect, NULL)==SQLITE_OK) {
                            if (sqlite3_step(statementSelect)==SQLITE_ROW) {
                                eventIdNow = sqlite3_column_int(statementSelect, 0);
                                
                                modifying = 1;
                                modifyEventId = eventIdNow;
                                haveSaved = YES;
                            }
                        }
                        
                        else{
                            NSLog(@"wwwwwwwwwwww!!!!!1");
                        }
                        sqlite3_finalize(statementSelect);
                        
                        if (eventIdNow>0) {
                            
                            NSString *insertCollctSql = [NSString stringWithFormat:@"INSERT INTO collection(eventID) VALUES(?)"];
                            
                            const char *collectsatement = [insertCollctSql UTF8String];
                            sqlite3_prepare_v2(dataBase, collectsatement, -1, &statementCollect, NULL);
                            sqlite3_bind_int(statementCollect,1, eventIdNow);
                            
                            if (sqlite3_step(statementCollect)==SQLITE_DONE) {
                                NSLog(@"innsert collect okssssssssssscollect");
                            }
                            else {
                                NSLog(@"Error while insert collect:%s",sqlite3_errmsg(dataBase));
                            }
                            
                            sqlite3_finalize(statementCollect);
                            
                            
                        }
                        else
                        {
                            NSLog(@"未能正确录入该事件，时间ID没有正确填充！！！！！！！");
                        }
                        
                    }
                    
                    else {
                        NSLog(@"数据库打开失败");
                        
                    }
                    
                    
                    sqlite3_close(dataBase);
                }
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"该事项已自动保存并存入收藏夹"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [ alert  show];
            
        }
    }
    
}


-(void)deleteTapped
{
   
    NSLog(@"delete！！！！！！！！");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定删除该事项吗"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 4;
    
    [ alert  show];

    
}

-(void)saveTapped
{
    NSNumber *oldStartNum;
    NSLog(@"<<<<<%@>>>>>3",self.remindData);
    

    
    if (modifying == 1) {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSLog(@"before select event ID");
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
            
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //找到当前修改的事件，取出数据，并清零对应的Area。
                    NSLog(@"After select event ID");
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                    oldStartNum = startTm;
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                    
                    if ([self.eventType intValue] == 0) {
                        for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                            workArea[i] = 0;
                            NSLog(@"release work area is :%d",i);
                        }
                    }else if([self.eventType intValue] == 1){
                        for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                            lifeArea[i] = 0;
                            NSLog(@"release life area is :%d",i);
                        }
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

    
    flag=NO;

    NSLog(@"hello!");
    if (([self.startLabel.text isEqualToString:@""]) || ([self.endLabel.text isEqualToString:@""])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入事件起始和结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    else  {
        NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
        NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
        
        double hour_0 = [startTime[0] doubleValue];
        double minite_0 = [startTime[1] doubleValue];
        double hour_1 = [endTime[0] doubleValue];
        double minite_1 = [endTime[1] doubleValue];
        
        
        
        double startNum = hour_0*60 + minite_0;
        double endNum = hour_1*60 + minite_1;
        
        if (startNum >= endNum) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"结束应该在开始之后哦"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
            
            return;
        }
        else{
            
            startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
            endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
            
            for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                if([self.eventType intValue]==0 && workArea[i] == 1)
                {
                    flag=YES;
                    break;
                }
                if([self.eventType intValue]==1 && lifeArea[i] == 1)
                {
                    flag=YES;
                    break;
                }
            }
            
            
            if (flag) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该时段已有事件存在，请修改起止时间或选择相应事件进行补充"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                alert.tag = 101;
                [alert show];
               
                
                
                
                //未能成功保存，所选时间内有其他事件冲突。所以先恢复当前修改中事件的占位，防止占位清零后点击返回，造成Area错误释放。
                sqlite3_stmt *statement;
                const char *dbpath = [databasePath UTF8String];
                if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                    NSLog(@"before select event ID");
                    NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
                    
                    const char *queryEventstatment = [queryEvent UTF8String];
                    if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                        if (sqlite3_step(statement)==SQLITE_ROW) {
                            //找到当前修改的事件，取出数据，将对应的Area设置为1。
                            NSLog(@"After select event ID");
                            NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                            oldStartNum = startTm;
                            NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                            
                            if ([self.eventType intValue] == 0) {
                                for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                                    workArea[i] = 1;
                                    NSLog(@"seize work area is :%d",i);
                                }
                            }else if([self.eventType intValue] == 1){
                                for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                                    lifeArea[i] = 1;
                                    NSLog(@"seize life area is :%d",i);
                                }
                            }
                            
                        }
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                

                
                
                    return;
                
                
            }
            else{

                
                
                NSLog(@"the old start is :%d",[oldStartNum intValue]);
                [self.drawBtnDelegate redrawButton:startTimeNum:endTimeNum:self.theme.text:self.eventType:oldStartNum];
                if ([self.eventType intValue]==0) {
                    for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                        workArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else if([self.eventType intValue]==1){
                    for (int i = [startTimeNum intValue]/30; i <= [endTimeNum intValue]/30; i++) {
                        lifeArea[i] = 1;
                        NSLog(@"seized life area is :%d",i);
                    }
                }else{
                    NSLog(@"事件类型有误！");
                }
                
          
                
                if (modifying == 0) {
                    
                    //在数据库中存储该事件
                   
                    const char *dbpath = [databasePath UTF8String];
                    sqlite3_stmt *statement;
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 插入当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO EVENT(TYPE,TITLE,mainText,income,expend,date,startTime,endTime,distance,label,remind,startArea,photoDir) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                        
                        const char *insertsatement = [insertSql UTF8String];
                        sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                        sqlite3_bind_int(statement,1, [self.eventType intValue]);
                        sqlite3_bind_text(statement,2, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement,3, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                        //未添加功能的数据
                        sqlite3_bind_double(statement,4, self.incomeFinal);
                        sqlite3_bind_double(statement,5, self.expendFinal);
                        
                        
                        sqlite3_bind_text(statement,6, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_double(statement,7, [startTimeNum doubleValue]);
                        sqlite3_bind_double(statement,8, [endTimeNum doubleValue]);
                        sqlite3_bind_double(statement,9, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                        
                        sqlite3_bind_text(statement,10, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement,11, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                        //  sqlite3_bind_int(statement,11, 0);
                        sqlite3_bind_int(statement,12, [self.eventType intValue]*1000+[startTimeNum intValue]/30);
                        sqlite3_bind_text(statement,13, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                        
                            if (sqlite3_step(statement)==SQLITE_DONE) {
                            NSLog(@"innsert event okqqqqqq");
                            }
                            else {
                            NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                            }
                       
                        sqlite3_finalize(statement);
                    }
                    
                    else {
                        NSLog(@"数据库打开失败");
                        
                    }
                    sqlite3_close(dataBase);
                    
                }
                else{
                    
                    const char *dbpath = [databasePath UTF8String];
                    sqlite3_stmt *statement;
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 更新当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"UPDATE EVENT SET TITLE=?,mainText=?,income=?,expend=?,startTime=?,endTime=?,distance=?,label=?,remind=?,startArea=?,photoDir=? where eventID=?"];
                        
                        const char *updatesatement = [insertSql UTF8String];
                        if(sqlite3_prepare_v2(dataBase, updatesatement, -1, &statement, NULL)==SQLITE_OK){
                            
                            sqlite3_bind_text(statement,1, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(statement,2, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                            //未添加功能的数据
                            sqlite3_bind_double(statement,3, self.incomeFinal);
                            sqlite3_bind_double(statement,4, self.expendFinal);
                            
                            sqlite3_bind_double(statement,5, [startTimeNum doubleValue]);
                            sqlite3_bind_double(statement,6, [endTimeNum doubleValue]);
                            sqlite3_bind_double(statement,7, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                            
                            sqlite3_bind_text(statement,8, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(statement,9, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_int(statement,10, [self.eventType intValue]*1000+[startTimeNum intValue]/30);
                            sqlite3_bind_text(statement,11, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_int(statement,12, modifyEventId);
                            
                            if (sqlite3_step(statement)==SQLITE_DONE) {
                                NSLog(@"innsert event okwwwwwwww");
                            }
                            else {
                                NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                            }
                        }
                        else {
                            
                             NSLog(@"modified event44");
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    else {
                        NSLog(@"数据库打开失败");
                        
                    }
                    sqlite3_close(dataBase);

                    
                }
                
            }
        

            
        }
    }
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if (modifying == 0) {
        if (self.remindData) {
            NSArray *remindDate = [self.remindData componentsSeparatedByString:@","];
            NSString *date = remindDate[0];
            NSString *time = remindDate[1];

            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *time1 = [formatter stringFromDate:now];
            NSDate *dateNow = [formatter dateFromString:time1];

            NSDate *daysRemind = [formatter dateFromString:date];
            formatter.dateFormat = @"H:mm";
            NSDate *timeRemind = [formatter dateFromString:time];
            NSString *time2 = [formatter stringFromDate:now];
            NSDate *timeNow = [formatter dateFromString:time2];
            
            NSTimeInterval daysInterval=[daysRemind timeIntervalSinceDate:dateNow];
            NSTimeInterval timeInterval=[timeRemind timeIntervalSinceDate:timeNow];
            
            int interval = (int)(daysInterval + timeInterval);
            
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                
                //NSDate *now=[NSDate new];
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:interval];
                NSLog(@"%d",interval);
                notification.timeZone=[NSTimeZone defaultTimeZone];
             
                //notification.alertBody=@"TIME！";
                
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),self.theme.text];
                notification.userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:self.remindData,self.remindData,nil];
 
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                
                
            }

         
        }else{
            
        }
    }
    else if(modifying == 1)
    {
        NSLog(@"~~~~~~~~%@",self.remindData);
        if (![self.remindData isEqualToString:@""]) {
            
            
            NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
            
            for (UILocalNotification * localNotification in allLocalNotification) {
                NSLog(@"%@",localNotification.userInfo);
                NSString * alarmValue=[localNotification.userInfo objectForKey:oldRemindDate];
                if ([oldRemindDate isEqualToString:alarmValue]) {
                    NSLog(@"666666666666");
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                }
            }

            
            NSArray *remindDate = [self.remindData componentsSeparatedByString:@","];
            NSString *date = remindDate[0];
            NSString *time = remindDate[1];
            
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *time1 = [formatter stringFromDate:now];
            NSDate *dateNow = [formatter dateFromString:time1];
            
            NSDate *daysRemind = [formatter dateFromString:date];
            formatter.dateFormat = @"H:mm";
            NSDate *timeRemind = [formatter dateFromString:time];
            NSString *time2 = [formatter stringFromDate:now];
            NSDate *timeNow = [formatter dateFromString:time2];
            
            NSTimeInterval daysInterval=[daysRemind timeIntervalSinceDate:dateNow];
            NSTimeInterval timeInterval=[timeRemind timeIntervalSinceDate:timeNow];
            
            int interval = (int)(daysInterval + timeInterval);
            
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                
                //NSDate *now=[NSDate new];
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:interval];
                NSLog(@"%d",interval);
                notification.timeZone=[NSTimeZone defaultTimeZone];
                
                //notification.alertBody=@"TIME！";
                
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),self.theme.text];
                notification.userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:self.remindData,self.remindData,nil];
                
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
             
            }
        }
        
        
    }
    
    [self.reloadDelegate reloadTable];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)okTapped
{
    UITextField * income = (UITextField *)[self.moneyAlert viewWithTag:501];
    UITextField * outcome = (UITextField *)[self.moneyAlert viewWithTag:502];
    NSString *incomeText = income.text;
    self.incomeFinal=[incomeText doubleValue];
    NSString *outcomeText = outcome.text;
    self.expendFinal=[outcomeText doubleValue];
    NSLog(@"BBBBBBBBB%f",self.incomeFinal);
   
    [self.moneyAlert close];
    //[income resignFirstResponder];

}

-(void)cancelTapped
{
    [self.moneyAlert close];
}

-(void)returnTapped
{
    if (haveSaved) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"本次编辑内容尚未保存，确定离开吗"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 5;
        
        [ alert  show];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        
    
	UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:201];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"H:mm";
    NSString *timestart = [formatter stringFromDate:datePicker.date];
    
	[(UILabel *)[self.view viewWithTag:103] setText:timestart];
    [self.startTimeButton setTitle:@"" forState:UIControlStateNormal];
        
    NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
    double hour_0 = [startTime[0] doubleValue];
    double minite_0 = [startTime[1] doubleValue];
    double startNum = hour_0*60 + minite_0;
    startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
    }
    
    if (actionSheet.tag == 2) {
        
        
        UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:202];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        formatter.dateFormat = @"H:mm";
        NSString *timestart = [formatter stringFromDate:datePicker.date];
    
                [(UILabel *)[self.view viewWithTag:104] setText:timestart];
        [self.endTimeButton setTitle:@"" forState:UIControlStateNormal];
        
        NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
        
        
        double hour_1 = [endTime[0] doubleValue];
        double minite_1 = [endTime[1] doubleValue];
        double endNum = hour_1*60 + minite_1;

        endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
        if (self.startLabel.text) {
            if ([endTimeNum doubleValue]<=[startTimeNum doubleValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"结束时间应该比开始时间更大哦！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        
        
 /*
        NSArray *startTime = [timestart componentsSeparatedByString:@":"];
        int hour = [startTime[0] intValue];
        int minite = [startTime[1] intValue];
        NSLog(@"hour:%d,minite:%d",hour,minite);
*/
        
        
        
    }

    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;

        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        } else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (IBAction)endEditing:(id)sender {
    [self resignFirstResponder];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]||[objInput isKindOfClass:[UITextView class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
        
    }
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



- (void)willPresentAlertView:(UIAlertView *)myAlertView {
    if (myAlertView.tag == 0) {
        NSLog(@"Alert0000000000");
        myAlertView.frame = CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height/3);

    }
    else if(myAlertView.tag == 1){
        
        NSLog(@"Alert111111111");
        myAlertView.frame = CGRectMake(0, 65, self.view.bounds.size.width/2, 372);
        
    }
 
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3) {
        if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
            NSLog(@"new tag is : %@",tf.text);
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                
                // 插入当天的数据
                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO TAG(tagName) VALUES(?)"];
                
                const char *insertsatement = [insertSql UTF8String];
                sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                sqlite3_bind_text(statement,1, [tf.text UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement)==SQLITE_DONE) {
                    NSLog(@"innsert tag ok");
                [self.tags addObject:tf.text];
               // [self.addTagDataDelegate addTagData:tf.text];
                }
                else {
                    NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                    UIAlertView *tagNotUnique = [[UIAlertView alloc]
                                    initWithTitle:@"Attention"
                                    message:@"This tag is already exist!"
                                    delegate:nil
                                    cancelButtonTitle:@"确定"
                                    otherButtonTitles:nil];
                    
                    
                    [tagNotUnique show];

                }
                sqlite3_finalize(statement);
            }
            
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            [self.tagTable reloadData];
            


            NSLog(@"点击了确定按钮");
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
    if (alertView.tag == 4) {
        
        NSNumber *oldStartNum;
        if (buttonIndex == 1) {
            
            if(modifying == 1){
                
                const char *dbpath = [databasePath UTF8String];
                sqlite3_stmt *statement;
                sqlite3_stmt *statement_1;
                sqlite3_stmt *statement_2;
                
                if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                    
                    NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
                    
                    const char *queryEventstatment = [queryEvent UTF8String];
                    if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                        if (sqlite3_step(statement)==SQLITE_ROW) {
                            //找到当前修改的事件，取出数据，并清零对应的Area。
                            NSLog(@"After select event ID");
                            NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                            oldStartNum = startTm;
                            NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                            
                            if ([self.eventType intValue] == 0) {
                                for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                                    workArea[i] = 0;
                                    NSLog(@"release work area is :%d",i);
                                }
                            }else if([self.eventType intValue] == 1){
                                for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                                    lifeArea[i] = 0;
                                    NSLog(@"release life area is :%d",i);
                                }
                            }
                            
                        }
                        
                    }
                    NSLog(@"the old start is :%d",[oldStartNum intValue]);
                    [self.drawBtnDelegate redrawButton:nil:nil:nil:self.eventType:oldStartNum];
                    
                    //删除收藏表中的数据，如果没有，也执行，只是没有删除任何行。
                    
                    NSString *deleteCollect = [NSString stringWithFormat:@"DELETE FROM collection WHERE eventID=?"];
                    
                    const char *deleteCollectStement = [deleteCollect UTF8String];
                    sqlite3_prepare_v2(dataBase, deleteCollectStement, -1, &statement_2, NULL);
                    sqlite3_bind_int(statement_2, 1, modifyEventId);
                    
                    if (sqlite3_step(statement_2)==SQLITE_DONE) {
                        NSLog(@"delete event from collection ok");
                        
                    }
                    else {
                        NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                        
                    }
                    
                    
                    // 删除当天的数据
                    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM EVENT WHERE eventID=?"];
                    
                    const char *deletestement = [deleteSql UTF8String];
                    sqlite3_prepare_v2(dataBase, deletestement, -1, &statement_1, NULL);
                    sqlite3_bind_int(statement_1, 1, modifyEventId);
                    
                    if (sqlite3_step(statement_1)==SQLITE_DONE) {
                        NSLog(@"delete event ok");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"成功删除该事项"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        //刷新所有列表，因为删除了事件，列表内容应该有相应的改变
                        [self.reloadDelegate reloadTable];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        
                    }
                    else {
                        NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                        
                    }
                    


                    
                    sqlite3_finalize(statement);
                    sqlite3_finalize(statement_1);
                    sqlite3_finalize(statement_2);
                }
                
                else {
                    NSLog(@"数据库打开失败");
                    
                }
                sqlite3_close(dataBase);
                NSLog(@"事项删除完毕！！！！！！") ;
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该事件尚未保存，无须删除"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];

            }
            
        }
    }
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}


#pragma mark remindData Delegate
-(void)setRemindData:(NSString *)date :(NSString *)time
{
    self.remindData = [NSString stringWithFormat:@"%@,%@",date,time];
    NSLog(@"%@",self.remindData);
    
    
}

#pragma mark drawTag delegation

-(void) drawTag:(NSString *)oldTags
{
    NSLog(@"old label is :%@",oldTags);
    self.selectedTags = oldTags;
    
    NSArray *tagToDraw = [oldTags componentsSeparatedByString:@","];
    if (tagToDraw.count > 0) {
        for (int i = 0; i < tagToDraw.count; i++) {
            UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(280, 150+30*i, self.view.frame.size.width-280, 20)];
            tag.text = tagToDraw[i];
            [tagLabels addObject:tag];
            [self.view addSubview:tag];
            
        }
        
    }
    

    
}


#pragma mark tavleView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  NSLog(@"count:%d",[currentAlbumData[@"titles"] count]);
    return self.tags.count;
}

// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        
    }
    NSUInteger row=[indexPath row];
    
    //设置文本
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text =[self.tags objectAtIndex :row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger row=[indexPath row];
 
    [selected addObject:[self.tags objectAtIndex:row]];
    NSLog(@"select---->:%@",selected);

    

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;
}




- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [selected removeObject:[self.tags objectAtIndex:indexPath.row]];
     NSLog(@"Deselect---->:%@",selected);

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"here!!!!!!!!!");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            
            // 插入当天的数据
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM TAG WHERE tagName=?"];
            
            const char *deletestement = [deleteSql UTF8String];
            sqlite3_prepare_v2(dataBase, deletestement, -1, &statement, NULL);
            sqlite3_bind_text(statement,1, [[self.tags objectAtIndex:indexPath.row] UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if (sqlite3_step(statement)==SQLITE_DONE) {
                NSLog(@"delete tag ok");
                [self.tags removeObject:[self.tags objectAtIndex:indexPath.row]];
               
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
        [self.tagTable setEditing:NO animated:YES];

        
    }
   
}


@end
