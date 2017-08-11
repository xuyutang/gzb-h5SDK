//
//  ChangeDateTableViewCell.m
//  SalesManager
//
//  Created by iOS-Dev on 16/11/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "ChangeDateTableViewCell.h"

@implementation ChangeDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_weekLabel release];
    [_workTypeLabel release];
    [_changeDateBtn release];
    [super dealloc];
}

@end
