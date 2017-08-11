//
//  CustomerInputView.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-27.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "CustomerInputView.h"

@implementation CustomerInputView

-(void)layoutSubviews{
    [self setBackgroundColor:[UIColor whiteColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), .5f)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetWidth(self.frame)-1, CGRectGetWidth(self.frame), .5f)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10,  CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-20)];
    [self addSubview:_inputTextField];
    [self addSubview:line];
    [self addSubview:line2];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
