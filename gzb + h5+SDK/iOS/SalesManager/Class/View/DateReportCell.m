//
//  DateReportCell.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DateReportCell.h"

@implementation DateReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_ivImage release];
    [_time release];
    [_address release];
    [_name release];
    [_mType release];
    [super dealloc];
}
@end
