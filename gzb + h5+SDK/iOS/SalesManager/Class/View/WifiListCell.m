//
//  WifiListCell.m
//  SalesManager
//
//  Created by iOS-Dev on 16/12/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiListCell.h"

@implementation WifiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
   
    [_wifiOtherNameLabel release];
    [_wifiNameLabel release];
    [_addressLabel release];
    [_wifiEnableImageView release];
    [_wifiSwichImageView release];
    [super dealloc];
}

@end
