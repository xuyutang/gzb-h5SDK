//
//  SelectedTagCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-4.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "SelectedTagCell.h"

@implementation SelectedTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_title release];
    [_btDelete release];
    [super dealloc];
}
@end
