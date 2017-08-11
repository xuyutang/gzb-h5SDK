//
//  HeaderSearchDateView.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/3.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "HeaderSearchDateView.h"
#import "Constant.h"
#import "UIImage+JSLite.h"

@implementation HeaderSearchDateView

-(void)layoutSubviews{
    
    
    _bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt1 setTitle:_title1 forState:UIControlStateNormal];
    [_bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bt1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt1 setBackgroundColor:[UIColor clearColor]];
    [_bt1 setFrame:CGRectMake(0, 0, MAINWIDTH/3, 45)];
    [_bt1 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_bt1 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self addSubview:_bt1];
    
    
    _bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt2 setTitle:_title2 forState:UIControlStateNormal];
    _bt2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt2 setBackgroundColor:[UIColor clearColor]];
    [_bt2 setFrame:CGRectMake(MAINWIDTH/3, 0, MAINWIDTH/3, 45)];
    [_bt2 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_bt2 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self addSubview:_bt2];
    
    _bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt3 setTitle:_title3 forState:UIControlStateNormal];
    [_bt3 setBackgroundColor:[UIColor clearColor]];
    _bt3.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt3 setFrame:CGRectMake(2*MAINWIDTH/3, 0, MAINWIDTH/3, 45)];
    [_bt3 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_bt3 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];

    [self addSubview:_bt3];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*MAINWIDTH/3, 0, 1, 45)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/3, 0, 1, 45)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, 1)];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line3];
    
    [_bt1 addTarget:self action:@selector(clickButton1) forControlEvents:UIControlEventTouchUpInside];
    [_bt2 addTarget:self action:@selector(clickButton2) forControlEvents:UIControlEventTouchUpInside];
    [_bt3 addTarget:self action:@selector(clickButton3) forControlEvents:UIControlEventTouchUpInside];

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
