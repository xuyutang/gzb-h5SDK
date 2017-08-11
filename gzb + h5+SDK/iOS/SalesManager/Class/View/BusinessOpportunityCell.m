//
//  BusinessOpportunityCell.m
//  SalesManager
//
//  Created by 章力 on 14-5-6.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BusinessOpportunityCell.h"

@implementation BusinessOpportunityCell

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
    [_customer release];
    [_bizOppName release];
    [_bizOppPrincipal release];
    [_user release];
    [_time release];
    [_btnApprove release];
    [_userImageView release];
    [super dealloc];
}
@end
