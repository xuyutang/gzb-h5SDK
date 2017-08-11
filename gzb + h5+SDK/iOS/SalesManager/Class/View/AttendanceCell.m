//
//  AttendanceCell.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-10-21.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "AttendanceCell.h"

@implementation AttendanceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_checkInTime release];
    [_checkInAddress release];
    [_checkInComment release];
    [_name release];
    [_btApprove release];
    [_category release];
    [_ivImage release];
    [super dealloc];
}
@end
