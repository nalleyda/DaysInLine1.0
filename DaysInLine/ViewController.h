//
//  ViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "redrawButtonDelegate.h"
#import "drawTagDelegate.h"
#import "reloadTableDelegate.h"
//#import "addTagDelegate.h"

@class homeView;
@class daylineView;

@interface ViewController : UIViewController <redrawButtonDelegate,reloadTableDelegate>
{
    sqlite3 *dataBase;
    NSString *databasePath;
   
}
@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
@property (weak, nonatomic) NSObject <drawTagDelegate> *drawLabelDelegate;
@end
