//
//  SettingsCell.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "SettingsCell.h"
#import "Constant.h"

@implementation SettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!IOS8) {
        CGRect r = _sw.frame;
        r.origin.x = r.origin.x - 28;
        _sw.frame = r;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_title release];
    [_sw release];
    [super dealloc];
}
@end
