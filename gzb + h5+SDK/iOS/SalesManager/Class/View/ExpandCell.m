//
//  ExpandCell.m
//  SalesManager
//
//  Created by liu xueyan on 1/22/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "ExpandCell.h"

@implementation ExpandCell
@synthesize bExpand,icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bExpand = NO;
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [icon setImage:[UIImage imageNamed:@"ic_go"]];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 200, 40)];
        [self addSubview:icon];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    bExpand = !bExpand;

    if (bExpand) {
        [icon setImage:[UIImage imageNamed:@"expander_ic_maximized"]];
    }else{
        [icon setImage:[UIImage imageNamed:@"expander_ic_minimized"]];
    }
}

- (void)dealloc{

    [super dealloc];
    [icon release];
}

@end
