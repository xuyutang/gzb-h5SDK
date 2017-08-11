//
//  VideoListCell.h
//  SalesManager
//
//  Created by Administrator on 15/11/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@protocol VideoListCellDelegate <NSObject>

-(void) VideoListCellReplyTouch;

@end

@interface VideoListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *image;

@property (retain, nonatomic) IBOutlet UILabel *videoTitle;

@property (retain, nonatomic) IBOutlet UILabel *videoContent;
@property (retain, nonatomic) IBOutlet UILabel *videoCategory;
@property (retain, nonatomic) IBOutlet UILabel *videoSize;
@property (retain, nonatomic) IBOutlet UIButton *videoReplyCount;
@property (retain, nonatomic) UILabel *createTime;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UIImageView *videoPlayImage;

@property (nonatomic,retain) VideoTopic *video;

@property (nonatomic,assign) id<VideoListCellDelegate> delegate;
@end
