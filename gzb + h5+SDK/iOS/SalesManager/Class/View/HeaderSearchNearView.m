//
//  HeaderSearchNearView.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/3.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "HeaderSearchNearView.h"
#import "Constant.h"

@implementation HeaderSearchNearView

-(void)layoutSubviews{
    
    _icon1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 15, 15)];
    [_icon1 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon1 setBackgroundColor:WT_CLEARCOLOR];
    [self addSubview:_icon1];
    
    //_icon2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH/3+5, 15, 15, 15)];
    _icon2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH/2+5, 15, 15, 15)];
    [_icon2 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon2 setBackgroundColor:WT_CLEARCOLOR];
    [self addSubview:_icon2];
    
    //_icon3 = [[UILabel alloc] initWithFrame:CGRectMake(2*MAINWIDTH/3+5, 12, 20, 20)];
    //[_icon3 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    //[self addSubview:_icon3];
    
    _bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt1 setTitle:_title1 forState:UIControlStateNormal];
    [_bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bt1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    //[_bt1 setBackgroundColor:[UIColor clearColor]];
    //[_bt1 setFrame:CGRectMake(20, 0, MAINWIDTH/3-20, 45)];
    [_bt1 setFrame:CGRectMake(20, 0, MAINWIDTH/2-20, 45)];
    [self addSubview:_bt1];
    
    
    _bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt2 setTitle:_title2 forState:UIControlStateNormal];
    _bt2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    //[_bt2 setBackgroundColor:[UIColor clearColor]];
    //[_bt2 setFrame:CGRectMake(MAINWIDTH/3+20, 0, MAINWIDTH/3-20, 45)];
    [_bt2 setFrame:CGRectMake(MAINWIDTH/2+20, 0, MAINWIDTH/2-20, 45)];
    [self addSubview:_bt2];
    
    /*_bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt3 setTitle:_title3 forState:UIControlStateNormal];
    _bt3.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt3 setBackgroundColor:[UIColor clearColor]];
    [_bt3 setFrame:CGRectMake(2*MAINWIDTH/3+20, 0, MAINWIDTH/3-20, 45)];
    [self addSubview:_bt3];*/
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/2, 0, 1, 45)];
    //UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/3, 0, 1, 45)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line1];
    
    /*UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(2*MAINWIDTH/3, 0, 1, 45)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line2];*/
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, 1)];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line3];
    
    [_bt1 addTarget:self action:@selector(clickButton1) forControlEvents:UIControlEventTouchUpInside];
    [_bt2 addTarget:self action:@selector(clickButton2) forControlEvents:UIControlEventTouchUpInside];
    //[_bt3 addTarget:self action:@selector(clickButton3) forControlEvents:UIControlEventTouchUpInside];
    _icon1.text = [NSString fontAwesomeIconStringForEnum:ICON_TAB_CITY];
    _icon2.text = [NSString fontAwesomeIconStringForEnum:ICON_TAB_DISTANCE];
    _icon3.text = [NSString fontAwesomeIconStringForEnum:ICON_CUSTOMER];

    [_bt1 setTitle:NSLocalizedString(@"search_title_department", nil) forState:UIControlStateNormal];
    [_bt2 setTitle:NSLocalizedString(@"search_title_distance", nil) forState:UIControlStateNormal];
    [_bt3 setTitle:NSLocalizedString(@"search_title_staff", nil) forState:UIControlStateNormal];
}

-(void)clickButton1{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(clickButtunIndex:)]) {
        [_delegate clickButtunIndex:1];
    }
}

-(void)clickButton2{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(clickButtunIndex:)]) {
        [_delegate clickButtunIndex:2];
    }
}

-(void)clickButton3{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(clickButtunIndex:)]) {
        [_delegate clickButtunIndex:3];
    }
}

@end
