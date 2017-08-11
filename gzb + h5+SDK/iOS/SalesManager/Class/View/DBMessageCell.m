//
//  DBMessageCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-23.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "DBMessageCell.h"

@implementation DBMessageCell
@synthesize icon,title,subTitle,count,flag,time;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSubviews{
    [super initSubviews];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(8,5,70,70)];
    [self addSubview:icon];
    [icon release];
    
    count = [[UILabel alloc] initWithFrame:CGRectMake(66,5,20,20)];
    count.font = [UIFont boldSystemFontOfSize:11];
    count.textAlignment = NSTextAlignmentCenter;
    [self addSubview:count];
    [count release];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(94,8,218,21)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor blackColor];
    [self addSubview:title];
    [title release];
    
    subTitle = [[UILabel alloc] initWithFrame:CGRectMake(94,28,218,34)];
    subTitle.font = [UIFont systemFontOfSize:12];
    subTitle.textColor = [UIColor grayColor];
    subTitle.numberOfLines = 2;
    [self addSubview:subTitle];
    [subTitle release];
    
    flag = [[UILabel alloc] initWithFrame:CGRectMake(94,56,42,21)];
    flag.font = [UIFont systemFontOfSize:11];
    [self addSubview:flag];
    [flag release];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(186,57,126,21)];
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor grayColor];
    time.textAlignment = NSTextAlignmentRight;
    [self addSubview:time];
    [time release];
}

- (void)dealloc {
    [icon release];
    [count release];
    [title release];
    [subTitle release];
    [flag release];
    [time release];
    [super dealloc];
}
@end
