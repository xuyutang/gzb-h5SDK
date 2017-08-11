//
//  OrderFloatButton.m
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "OrderFloatButton.h"
#import "Constant.h"

#define CELL_HEIGHT 45

@implementation OrderFloatButton
{
    UILabel *_lable;
    UIButton *_button;
    UIButton *_button2;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, MAINHEIGHT - CELL_HEIGHT,MAINWIDTH, CELL_HEIGHT);
    }
    return self;
}

-(instancetype)initWithLableText:(NSString *) lableText titles:(NSArray *) titles{
    if (self = [super init]) {
        self.frame = CGRectMake(0, MAINHEIGHT - CELL_HEIGHT,MAINWIDTH, CELL_HEIGHT);
        [self initViewWithLableText:lableText titles:titles];
    }
    return self;
}


-(void) initViewWithLableText:(NSString *) lableText titles:(NSArray *) titles{
    if (_lable == nil) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, CELL_HEIGHT)];
        _lable.backgroundColor = [UIColor colorWithWhite:0.f alpha:.5f];
        _lable.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
        _lable.textAlignment = UITextAlignmentLeft;
        _lable.textColor = WT_WHITE;
        [self addSubview:_lable];
    }
    if (lableText != nil && lableText.length > 0) {
        _lable.text = [NSString stringWithFormat:@"    %@",lableText];
    }
    
    if (titles.count == 1) {
        
        if (_button == nil) {
            _button = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 70, CELL_HEIGHT)];
            _button.backgroundColor = WT_RED;
            [_button setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
            [_button setTitleColor:WT_WHITE forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_button];
        }
        [_button setTitle:titles[0] forState:UIControlStateNormal];
        
    }else if(titles.count == 2){
        
        if (_button == nil) {
            _button = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 70, CELL_HEIGHT)];
            _button.backgroundColor = WT_RED;
            [_button setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
            [_button setTitleColor:WT_WHITE forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_button];
        }
        [_button setTitle:titles[0] forState:UIControlStateNormal];
        
        if (_button2 == nil) {
            _button2 = [[UIButton alloc] initWithFrame:CGRectMake(250 - 71, 0, 70, CELL_HEIGHT)];
            _button2.backgroundColor = WT_RED;
            [_button2 setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
            [_button2 setTitleColor:WT_WHITE forState:UIControlStateNormal];
            [_button2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_button2];
        }
        [_button2 setTitle:titles[1] forState:UIControlStateNormal];
    }
}

-(void) btnClick2:(UIButton *) btn{
    if (self.btnClick) {
        self.btnClick(1);
    }
}

-(void) btnClick:(UIButton *) btn{
    if (self.btnClick) {
        self.btnClick(0);
    }
}

#pragma -mark -- 公开方法
-(void)setLabeText:(NSString *)txt{
    _lable.text = [NSString stringWithFormat:@"    %@",txt];
}

-(void) setLableText:(NSString *) lableText titles:(NSArray *) titles{
    [self initViewWithLableText:lableText titles:titles];
}

-(void) setButtonEnable:(BOOL) ist{
    if (_button != nil) {
        _button.enabled = ist;
        if (ist) {
            _button.backgroundColor = WT_RED;
        }else{
            
            _button.backgroundColor = WT_LIGHT_GRAY;
        }
    }
    if (_button2 != nil) {
        _button2.enabled = ist;
        if (ist) {
            _button.backgroundColor = WT_RED;
        }else{
            
            _button.backgroundColor = WT_LIGHT_GRAY;
        }
    }
}

-(void)setFullButton{
    if (_button != nil) {
        _button.frame = CGRectMake(0, 0, MAINWIDTH, CELL_HEIGHT);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
