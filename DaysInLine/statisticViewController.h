//
//  statisticViewController.h
//  DaysInLine
//
//  Created by 张力 on 14-1-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "resultView.h"


@interface statisticViewController : UIViewController
{
    sqlite3 *dataBase;
    NSString *databasePath;

    
}




@property (weak, nonatomic) NSString *startDate;
@property (weak, nonatomic) NSString *endDate;
@end
