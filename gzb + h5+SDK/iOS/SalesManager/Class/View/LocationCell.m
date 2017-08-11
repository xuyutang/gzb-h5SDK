//
//  LocationCell.m
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "LocationCell.h"
#import "Constant.h"

@implementation LocationCell
@synthesize lblAddress,btnRefresh;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews{
    btnRefresh.frame = CGRectMake(MAINWIDTH - 52, 15, 25, 25);
    [btnRefresh setImage:[UIImage imageNamed:@"icon_loc_refresh"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [lblAddress release];
    [btnRefresh release];
    [super dealloc];
}
@end
