//
//  TagButton.m
//  SalesManager
//
//  Created by Administrator on 16/3/26.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "TagButton.h"
#import "Constant.h"

@implementation TagButton
-(instancetype)initWithFrame:(CGRect)frame name:(NSString *) name obj:(id) obj{
    if (self = [super initWithFrame:frame]) {
        _obj = obj;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:name forState:UIControlStateNormal];
        [self setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self initView];
    }
    return self;
}

-(void) clickAction:(TagButton *) sender{
    if (self.click) {
        self.bCheck = !self.bCheck;
        [self setCheckStatus:self.bCheck];
        self.click(sender);
    }
}


-(void) cancelCheck{
    self.bCheck = !self.bCheck;
    [self setCheckStatus:NO];
}

-(void) setCheckStatus:(BOOL) ist{
    if (ist) {
        self.layer.borderColor = WT_RED.CGColor;
        [self setTitleColor:WT_RED forState:UIControlStateNormal];
    }else{
        if (IOS7) {
            self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        }else{
            self.layer.borderColor = WT_LIGHT_GRAY.CGColor;
        }
        [self setTitleColor:WT_BLACK forState:UIControlStateNormal];
    }
}

-(void) initView{
    if (IOS7) {
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }else{
        self.layer.borderColor = WT_LIGHT_GRAY.CGColor;
    }
    self.layer.borderWidth = 1.f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
