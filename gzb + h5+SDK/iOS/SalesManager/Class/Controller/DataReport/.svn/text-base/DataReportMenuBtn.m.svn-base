//
//  DataReportMenuBtn.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DataReportMenuBtn.h"

@implementation DataReportMenuBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titlelabel = [[UILabel alloc] init];
        _label = [[UILabel alloc] init];
        _label.contentMode =UIViewContentModeCenter;
        
        [self addSubview:_label];
        [self addSubview:_titlelabel];
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height - 21, self.frame.size.width, 21);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 21);
}

@end
