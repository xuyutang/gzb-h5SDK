//
//  BottomBtnBar.m
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "BottomBtnBar.h"
#import "Constant.h"



@implementation BottomBtnBar

-(instancetype)initWithPoint:(CGPoint)point{
    if ([super initWithFrame:CGRectMake(point.x, point.y, 320, 44)]) {
        [self initView];
    }
    return self;
}


/*
 *初始化视图
 */
-(void) initView{
    self.backgroundColor = WT_WHITE;
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 7, 86, 30)];
    [_leftButton setTitle:NSLocalizedString(@"btn_bar_left_title", nil) forState:UIControlStateNormal];
    [_leftButton setTitleColor:WT_WHITE forState:UIControlStateNormal];
    _leftButton.backgroundColor = WT_RED;
    _leftButton.tag = 1;
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(_leftButton.frame.origin.x + _leftButton.frame.size.width + 20, 7, 86, 30)];
    [_rightButton setTitle:NSLocalizedString(@"btn_bar_right_title", nil) forState:UIControlStateNormal];
    [_rightButton setTitleColor:WT_WHITE forState:UIControlStateNormal];
    _rightButton.backgroundColor = WT_RED;
    _rightButton.tag = 2;
    
    [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_leftButton];
    [self addSubview:_rightButton];
}

/*
 *按钮事件
 */
-(void) buttonAction:(UIButton*) sender{
    if (_delegate && [_delegate respondsToSelector:@selector(BottomBtnBarTouch:)]) {
        [_delegate BottomBtnBarTouch:sender.tag - 1];
    }
}


-(void)dealloc{
    [_leftButton release];
    [_rightButton release];
    [_delegate release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
