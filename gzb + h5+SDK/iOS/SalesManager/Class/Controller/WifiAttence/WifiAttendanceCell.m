//
//  WifiAttendanceCell.m
//  SalesManager
//
//  Created by iOS-Dev on 16/12/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiAttendanceCell.h"

@implementation WifiAttendanceCell

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
    [_name release];
    [_checkInTime release];
    [_checkInComment release];
    [_checkInAddress release];
    [_category release];
    [_btApprove release];
    [_dayWork release];
    [_lateTime release];
    [_dateLabel release];
    [_time release];
    [super dealloc];
}
@end
