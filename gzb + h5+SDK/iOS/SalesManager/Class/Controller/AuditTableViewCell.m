//
//  AuditTableViewCell.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/17.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "AuditTableViewCell.h"

@implementation AuditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_icon release];
    [_name release];
    [_auditName release];
    [_time release];
    [_comment release];
    [_status release];
    [super dealloc];
}
@end
