//
//  statisticViewController.h
//  DaysInLine
//
//  Created by 张力 on 14-1-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface statisticViewController : UIViewController
{
    sqlite3 *dataBase;
    NSString *databasePath;
    
}
@property (weak, nonatomic) IBOutlet UILabel *brifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodScore;
@property (weak, nonatomic) IBOutlet UILabel *growthScore;

@property (weak, nonatomic) IBOutlet UILabel *workTime;
@property (weak, nonatomic) IBOutlet UILabel *lifeTime;
@property (weak, nonatomic) IBOutlet UILabel *incomeTotal;
@property (weak, nonatomic) IBOutlet UILabel *expendTotal;
- (IBAction)continueButton:(id)sender;

@property (weak, nonatomic) NSString *startDate;
@property (weak, nonatomic) NSString *endDate;
@end
