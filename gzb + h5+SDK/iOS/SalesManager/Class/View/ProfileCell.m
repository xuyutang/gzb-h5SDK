//
//  ProfileCell.m
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell
@synthesize lblCompany;
@synthesize lblDepart;
@synthesize lblPosition;
@synthesize lblName;
@synthesize lblIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite_topbar_bg_orange"]];
        [self setBackgroundView:imageView];
        [imageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [lblCompany release];
    [lblName release];
    [lblDepart release];
    [lblPosition release];
    [lblIcon release];
    [super dealloc];
}
@end
