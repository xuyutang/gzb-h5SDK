//
//  HeaderSearchView.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-19.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "HeaderSearchView.h"
#import "Constant.h"

#define MENU_NUM 4
@implementation HeaderSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    
    if (_buttonCount == 0) {
        _buttonCount = MENU_NUM;
    }
    
    _icon1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 15, 15)];
    [_icon1 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon1 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_icon1];
    
    _icon2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH/_buttonCount+5, 15, 20, 15)];
    [_icon2 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon2 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_icon2];

    _icon3 = [[UILabel alloc] initWithFrame:CGRectMake(2*MAINWIDTH/_buttonCount+5, 15, 15, 15)];
    [_icon3 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon3 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_icon3];
    
    _icon4 = [[UILabel alloc] initWithFrame:CGRectMake(3*MAINWIDTH/_buttonCount+5, 15, 15, 15)];
    [_icon4 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17]];
    [_icon4 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_icon4];
    
    _bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt1 setTitle:_title1 forState:UIControlStateNormal];
    [_bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bt1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt1 setBackgroundColor:[UIColor clearColor]];
    [_bt1 setFrame:CGRectMake(20, 0, MAINWIDTH/_buttonCount-20, 45)];
    [self addSubview:_bt1];
    
    
    _bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt2 setTitle:_title2 forState:UIControlStateNormal];
    _bt2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt3 setBackgroundColor:[UIColor clearColor]];
    [_bt2 setFrame:CGRectMake(MAINWIDTH/_buttonCount+20, 0, MAINWIDTH/_buttonCount-20, 45)];
    [self addSubview:_bt2];
    
    _bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt3 setTitle:_title3 forState:UIControlStateNormal];
    [_bt3 setBackgroundColor:[UIColor clearColor]];
    _bt3.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt3 setFrame:CGRectMake(2*MAINWIDTH/_buttonCount+20, 0, MAINWIDTH/_buttonCount-20, 45)];
    [self addSubview:_bt3];
    
    _bt4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt4 setTitle:_title4 forState:UIControlStateNormal];
    [_bt4 setBackgroundColor:[UIColor clearColor]];
    _bt4.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bt4 setFrame:CGRectMake(3*MAINWIDTH/_buttonCount+20, 0, MAINWIDTH/_buttonCount-20, 45)];
    [self addSubview:_bt4];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(3*MAINWIDTH/_buttonCount, 0, 1, 45)];
    [line4 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line4];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*MAINWIDTH/_buttonCount, 0, 1, 45)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/_buttonCount, 0, 1, 45)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line2];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, 1)];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line3];
    
    [_bt1 addTarget:self action:@selector(clickButton1) forControlEvents:UIControlEventTouchUpInside];
    [_bt2 addTarget:self action:@selector(clickButton2) forControlEvents:UIControlEventTouchUpInside];
    [_bt3 addTarget:self action:@selector(clickButton3) forControlEvents:UIControlEventTouchUpInside];
    [_bt4 addTarget:self action:@selector(clickButton4) forControlEvents:UIControlEventTouchUpInside];
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

-(void)clickButton4{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(clickButtunIndex:)]) {
        [_delegate clickButtunIndex:4];
    }
}

@end
