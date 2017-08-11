
//
//  SyncButton.m
//  SalesManager
//
//  Created by Administrator on 16/4/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "SyncButton.h"
#import "Constant.h"

@implementation SyncButton


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}


-(void) initView{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, 30);
    self.backgroundColor = WT_RED;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    lable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    lable.text =[NSString fontAwesomeIconStringForEnum:ICON_DOWNLOAD];
    lable.textAlignment = UITextAlignmentCenter;
    lable.textColor  = WT_WHITE;
    lable.backgroundColor = WT_CLEARCOLOR;
    [self addSubview:lable];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 65, 30)];
    text.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    text.text = @"云端下载";
    text.textColor = WT_WHITE;
    text.backgroundColor = WT_CLEARCOLOR;
    [self addSubview:text];
    self.font = [UIFont fontWithName:kFontAwesomeFamilyName size:self.frame.size.width - 10];
    [self addTarget:self action:@selector(syncAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //注册拖动动画
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(doHandlePanAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
    [lable release];
    [text release];
}

//拖动处理函数
- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
    
    CGPoint point = [paramSender translationInView:self];
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    [paramSender setTranslation:CGPointMake(0, 0) inView:self];
}


-(void) syncAction{
    if (self.onClick) {
        self.onClick(self);
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
