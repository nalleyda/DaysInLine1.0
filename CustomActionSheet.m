//
//  CustomActionSheet.m
//  customActionSheetTest
//
//  Created by 林 劲捷 on 13-5-30.
//  Copyright (c) 2013年 林 劲捷. All rights reserved.
//

#import "CustomActionSheet.h"
#import "AppDelegate.h"
#define intervalWithButtonsX 30
#define intervalWithButtonsY 5
#define buttonCountPerRow 3
#define headerHeight 20
#define bottomHeight 20
#define cancelButtonHeight 46
@implementation CustomActionSheet
@synthesize buttons;
@synthesize backgroundImageView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithButtons:(NSArray *)buttonArray
{
    self = [super init];
    self.buttons = buttonArray;
    if (self) {
        // Initialization code
        coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.6f];
        coverView.hidden = YES;
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"actionsheet_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:110]];
        self.backgroundImageView.alpha = 0.7f;
        [self addSubview:self.backgroundImageView];
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.imgButton.tag = i;
            [button.imgButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: button];
        }
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"actionsheet_button.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


-(void)dealloc
{
    self.buttons = nil;
    self.backgroundImageView = nil;
  
}

-(void)setPositionInView:(UIView *)view
{
    if([self.buttons count] == 0)
    {
        return;
    }
    float buttonWidth = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.width;
    float buttonHeight = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.height;
    self.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width, cancelButtonHeight + bottomHeight + headerHeight + (buttonHeight + intervalWithButtonsY)*(([self.buttons count]-1)/buttonCountPerRow + 1));
    self.backgroundImageView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    float beginX = (self.frame.size.width - (intervalWithButtonsX * (buttonCountPerRow - 1) + buttonWidth * buttonCountPerRow))/2;
    cancelButton.frame = CGRectMake(beginX,
                                    (intervalWithButtonsY + buttonHeight) * (([self.buttons count]-1)/buttonCountPerRow + 1) + headerHeight,
                                    self.frame.size.width - beginX * 2, cancelButtonHeight);
    if ([self.buttons count] > buttonCountPerRow) {
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(beginX + i%buttonCountPerRow*(buttonWidth + intervalWithButtonsX),
                                      headerHeight + i/buttonCountPerRow*(buttonHeight + intervalWithButtonsY), buttonWidth, buttonHeight);
        }
    }
    else
    {
        float intervalX = (self.frame.size.width - beginX*2 - buttonWidth*[self.buttons count])/([self.buttons count] - 1);
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(beginX + i%buttonCountPerRow*(buttonWidth + intervalX),
                                      headerHeight + i/buttonCountPerRow*(buttonHeight + intervalWithButtonsY), buttonWidth, buttonHeight);
        }
    }

    
}


-(void)showInView:(UIView *)view
{
    [self setPositionInView:view];
    [view addSubview:coverView];
    [view addSubview:self];
    [UIView beginAnimations:@"ShowCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    coverView.hidden = NO;
    [UIView commitAnimations];
}
-(void)dissmiss
{
    [UIView beginAnimations:@"DismissCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(sheetDidDismissed)];
    coverView.hidden = YES;
    [UIView commitAnimations];
}

-(void)sheetDidDismissed
{
    [coverView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)buttonAction:(UIButton *)button
{
    NSLog(@"index:%d",button.tag);
    if([delegate respondsToSelector:@selector(choseAtIndex:)])
    {
        [delegate choseAtIndex:button.tag];
    }
    [self dissmiss];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


@implementation CustomActionSheetButton
@synthesize imgButton;
@synthesize titleLabel;
-(id)init
{
    if(self)
    {
        self = nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomActionSheetButton" owner:self options:nil] objectAtIndex:0];
    for (id obj in self.subviews) {
        if([obj isKindOfClass:[UIButton class]])
        {
            self.imgButton = obj;
        }
        else if([obj isKindOfClass:[UILabel class]])
        {
            self.titleLabel = obj;
        }
    }
    return self;
}

+(CustomActionSheetButton *)buttonWithImage:(UIImage *)image title:(NSString *)title
{
    CustomActionSheetButton * button = [[CustomActionSheetButton alloc] init] ;
    [button.imgButton setBackgroundImage:image forState:UIControlStateNormal];
    button.titleLabel.text = title;
    return button;
}

-(void)dealloc
{
    self.titleLabel = nil;
    self.imgButton = nil;
}
@end