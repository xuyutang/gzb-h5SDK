//
//  TopicNewsCell.m
//  Club
//
//  Created by ZhangLi on 13-12-22.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "TopicImageCell.h"
#import "Constant.h"

@implementation TopicImageCell
@synthesize imgScrollView;
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

-(void) initTopicWithTitle:(NSMutableArray*)titles Images:(NSMutableArray*)images{
    imgScrollView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0,0, MAINWIDTH, 146) ImageArray:images TitleArray:titles isBig:NO];
    [imgScrollView setBackgroundColor:WT_LIGHT_YELLOW];
    [self.contentView addSubview:imgScrollView];
    imgScrollView.userInteractionEnabled = YES;
}

@end
