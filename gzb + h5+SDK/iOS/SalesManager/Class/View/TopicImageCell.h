//
//  TopicNewsCell.h
//  Club
//
//  Created by ZhangLi on 13-12-22.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"

@interface TopicImageCell : UITableViewCell
@property(nonatomic,retain) EScrollerView       *imgScrollView;

-(void) initTopicWithTitle:(NSMutableArray*)titles Images:(NSMutableArray*)images;
@end
