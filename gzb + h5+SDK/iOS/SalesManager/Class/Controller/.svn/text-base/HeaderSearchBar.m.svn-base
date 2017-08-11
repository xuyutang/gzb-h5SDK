//
//  HeaderSearchBar.m
//  自定义搜索导航
//
//  Created by 朱康 on 15/10/9.
//  Copyright © 2015年 Anonymous. All rights reserved.
//

#import "HeaderSearchBar.h"
#import "Constant.h"

@implementation HeaderSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = -1;
    }
    return self;
}

-(void)layoutSubviews{
    if (_icontitles.count != _titles.count || _icontitles.count == 0) {
        NSLog(@"图标个数与标题个数不一致 或者 个数不能为0");
        return;
    }
    _buttons = [[NSMutableArray alloc] init];
    _icons = [[NSMutableArray alloc] init];
    float x,y,w,h,linex;
    
    for (int i = 0 ; i < _icontitles.count; i++) {
        float cellWidth = self.frame.size.width / _icontitles.count * i;
        //图标
        x = (self.frame.size.width / _icontitles.count) * 0.2 + cellWidth;
        y = 15;
        UILabel* _tmpIcon = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 15, 15)];
        _tmpIcon.backgroundColor = [UIColor clearColor];
        _tmpIcon.text = _icontitles[i];
        _tmpIcon.font = [UIFont fontWithName:@"FontAwesome" size:17.0f];
        [self addSubview:_tmpIcon];
        [_icons addObject:_tmpIcon];
        //按钮
        y = 0;
        h = self.frame.size.height;
        w = self.frame.size.width / _icontitles.count;
        x = self.frame.size.width / _icontitles.count * i;
        linex = x + 1;
        //如果没有图标 就居中显示
        NSLog(@"length:%d",((NSString*)_icontitles[i]).length);
        if (((NSString*)_icontitles[i]).length > 0) {
            x += 35;
            w -= 35;
        }
        CGRect tmpFrame = CGRectMake(x, y, i > 0 ? w - 1 : w, h);
        UIButton* tmpBtn = [[UIButton alloc] initWithFrame:tmpFrame];
        tmpBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [tmpBtn setTitle:_titles[i] forState:UIControlStateNormal];
        tmpBtn.backgroundColor = [UIColor clearColor];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [tmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tmpBtn.tag = i;
        [tmpBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:tmpBtn];
        [self addSubview:tmpBtn];
        //分界线
        if (i > 0) {
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(linex, 0, 1, self.frame.size.height)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
    }
    UIView* deLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    deLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:deLine];
}

-(void)btnAction:(NSObject*) objct{
    UIButton* btn = (UIButton*) objct;
    //设置选择颜色
    [self setBtnColor:btn.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(HeaderSearchBarClickBtn:current:)]) {
        
        [_delegate HeaderSearchBarClickBtn:(int)btn.tag current:_currentIndex];
        if (btn.tag == _currentIndex) {
            _currentIndex = -1;
        }else{
            _currentIndex = (int)btn.tag;
        }
    }
    
}

-(void) setBtnColor:(int)index{
    UIButton* item;
    UILabel* icon;
    for (int i = 0; i < _buttons.count; i++) {
        item = _buttons[i];
        icon = _icons[i];
        
        if (i == index) {
            [item setTitleColor:WT_RED forState:UIControlStateNormal];
            icon.textColor = WT_RED;
        }
        else{
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            icon.textColor = [UIColor blackColor];
        }
    }
    if (_currentIndex == index) {
        item = _buttons[index];
        icon = _icons[index];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        icon.textColor = [UIColor blackColor];
    }
}

-(void) setColor:(int)index{
    if (index == -1) {
        for (int i = 0; i < _buttons.count; i++) {
            [((UIButton *)_buttons[i])setTitleColor:WT_BLACK forState:UIControlStateNormal];
            [((UILabel *)_icons[i]) setTextColor:WT_BLACK];
        }
    }else{
        UIButton* item = _buttons[index];
        UILabel* icon = _icons[index];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        icon.textColor = [UIColor blackColor];
    }
    _currentIndex = -1;
}

-(void)dealloc{
    [_icontitles release];
    [_icons release];
    [_titles release];
    [_buttons release];
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
