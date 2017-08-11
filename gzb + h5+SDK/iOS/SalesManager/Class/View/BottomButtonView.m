//
//  BottomButtonView.m
//  SalesManager
//
//  Created by Administrator on 15/11/19.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "BottomButtonView.h"


@implementation BottomButtonView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //[self initView];
    }
    return self;
}


-(void) initView{
    //底部按钮
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, .5f)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, .5f, 45)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line2];
    [self addSubview:line1];
    [line1 release];
    [line2 release];
    /*
     "title_reply"="按钮1";
     "title_upload"="按钮2";
     */
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button1 setTitle:_titles.count == 2 ? _titles[0] : @"" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.tag = 10000;
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setFrame:CGRectMake(0, 0, self.frame.size.width/2, 45)];
    [button1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 10000 + 1;
    //[button2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button2 setTitle:_titles.count == 2 ? _titles[1] : @"" forState:UIControlStateNormal];//
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 45)];
    [button2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button1];
    [self addSubview:button2];
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    if (_titles != nil) {
        [self initView];
    }
}


-(void) btnAction:(UIButton *) button{
    if (self.buttonSelected) {
        self.buttonSelected(button.tag - 10000);
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
