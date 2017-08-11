//
//  NearPersonCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-7.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "NearPersonCell.h"

@implementation NearPersonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_icon release];
    [_name release];
    [_department release];
    [_icLocal release];
    [_distance release];
    [_address release];
    [_time release];
    [_lView release];
    [super dealloc];
}
@end
