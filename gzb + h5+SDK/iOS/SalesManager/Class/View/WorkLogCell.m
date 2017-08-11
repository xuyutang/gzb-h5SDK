//
//  WorkLogCell.m
//  SalesManager
//
//  Created by liu xueyan on 12/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "WorkLogCell.h"

@implementation WorkLogCell
@synthesize title,todayWork;

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
    [title release];
    [todayWork release];
    [_time release];
    [_btApprove release];
    [_userImage release];
    [super dealloc];
}
@end
