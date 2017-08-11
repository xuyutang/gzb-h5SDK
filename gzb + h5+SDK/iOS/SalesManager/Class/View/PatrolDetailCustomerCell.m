//
//  PatrolDetailCustomerCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-29.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "PatrolDetailCustomerCell.h"

@implementation PatrolDetailCustomerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_address release];
    [_category release];
    [_user release];
    [_time release];
    [super dealloc];
}
@end
