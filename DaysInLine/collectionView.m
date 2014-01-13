//
//  collectionView.m
//  DaysInLine
//
//  Created by 张力 on 14-1-7.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "collectionView.h"

@implementation collectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       /*
        // Initialization code
        self.collectionScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10,55,self.frame.size.width-20, self.frame.size.height-100)];
        self.collectionScroll.backgroundColor = [UIColor grayColor];
        [self addSubview:self.collectionScroll];
        */
        self.collectionTable = [[UITableView alloc] initWithFrame:CGRectMake(10,55,self.frame.size.width-20, self.frame.size.height-100)];
   
        self.collectionTable.tag = 3;
        self.collectionTable.rowHeight = 62;
        
        [self addSubview:self.collectionTable];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawi ng.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
