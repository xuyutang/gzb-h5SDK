//
//  AlarmItemCell.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/9.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "AlarmItemCell.h"

@implementation AlarmItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSubviews{
    [super initSubviews];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(15,7,130,30)];
    [self addSubview:_title];
    [_title release];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(148,11,83,21)];
    [self addSubview:_time];
    [_time release];
    
    _onoff = [[UISwitch alloc] initWithFrame:CGRectMake(239,6,51,31)];
    [self addSubview:_onoff];
    [_onoff release];
}

- (void)dealloc {
    [_title release];
    [_time release];
    [_onoff release];
    [super dealloc];
}
@end
