//
//  ApplyItemCell.m
//  SalesManager
//
//  Created by 章力 on 14-9-22.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ApplyItemCell.h"

@implementation ApplyItemCell

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
    [_userName release];
    [_btnApprove release];
    [_content release];
    [_date release];
    [_imgCheck release];
    [_checkBox release];
    [_lblCategory release];
    [_userImage release];
    [super dealloc];
}
@end
