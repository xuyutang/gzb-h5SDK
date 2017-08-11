//
//  PDTvbCell.m
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "PDTvbCell.h"

@implementation PDTvbCell

- (void)awakeFromNib {
    // Initialization code
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.6f alpha:.8f];
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.6f alpha:.8f];
    UIView *bc = [[UIView alloc] initWithFrame:self.frame];
    [bc addSubview:line2];
    bc.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = bc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
