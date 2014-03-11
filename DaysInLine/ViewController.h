//
//  ViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "sqlite3.h"
#import "redrawButtonDelegate.h"
#import "drawTagDelegate.h"
#import "reloadTableDelegate.h"
#import "setMainTextDelegate.h"

#define ADMOB_ID @"a1531ddc35a4db2"

@class homeView;
@class daylineView;

@interface ViewController : UIViewController <redrawButtonDelegate,reloadTableDelegate,setMainTextDelegate,ADBannerViewDelegate,GADBannerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    sqlite3 *dataBase;
    NSString *databasePath;
   
}
@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
@property (weak, nonatomic) NSObject <drawTagDelegate> *drawLabelDelegate;


//@property (strong, nonatomic) ADBannerView *adView;
@property (strong, nonatomic) ADBannerView *iAdBannerView;
@property (strong, nonatomic) GADBannerView *gAdBannerView;
//@property (strong, nonatomic) NSNumber *failLoadiAD;
@property (nonatomic, assign) BOOL bannerIsVisible;
@end
