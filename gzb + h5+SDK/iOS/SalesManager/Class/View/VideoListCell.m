//
//  VideoListCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "VideoListCell.h"
#import "SDImageView+SDWebCache.h"

@implementation VideoListCell
{
    CGFloat ios6x;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)setVideo:(VideoTopic *)video{
    _video = video;
    if (_video == nil) {
        return ;
    }
    if (!IOS8) {
        ios6x = 5;
    }
    NSString* avatar = @"";
    if (_video.filePaths.count > 0) {
        //本地显示
        //_image.image = [UIImage imageNamed:[_video.filePaths objectAtIndex:0]];
        
        avatar = [_video.filePaths objectAtIndex:0];
    }
    [_image setImageWithURL:[NSURL URLWithString:avatar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"bg_default_rect_pic"]];
    _userName.text = _video.user.realName;
    _videoTitle.text = _video.title;
    _videoContent.text = _video.comment;
    _videoCategory.text = _video.category.name;
    _videoSize.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_video_size", nil),[_video.videoSizes objectAtIndex:0]];
    
    _createTime = [[UILabel alloc] initWithFrame:CGRectMake(190, 58, 122, 21)];
    _createTime.backgroundColor = WT_CLEARCOLOR;
    _createTime.textColor = WT_DARK_GRAY;
    _createTime.textAlignment = UITextAlignmentRight;
    _createTime.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:_createTime];
    _createTime.text = _video.createDate;
    
//    _videoReplyCount.layer.backgroundColor = WT_CLEARCOLOR.CGColor;
//    _videoReplyCount.backgroundColor = WT_GREEN;
    
    if (!IOS8) {
        CGRect r = _createTime.frame;
        r.origin.x  = r.origin.x - ios6x;
        _createTime.frame = r;
        
        r = _videoReplyCount.frame;
        r.origin.x = r.origin.x - ios6x - 10;
        _videoReplyCount.frame = r;
        
        r = _videoSize.frame;
        r.origin.x = r.origin.x - ios6x - 8;
        _videoSize.frame = r;
    }
    
    if (_video.replyCount > 0) {
        _videoReplyCount.layer.cornerRadius = 16.f;
        _videoReplyCount.layer.borderWidth = 1.f;
        _videoReplyCount.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _videoReplyCount.layer.masksToBounds = YES;
        [_videoReplyCount setTitle:[NSString stringWithFormat:@"%d",_video.replyCount] forState:UIControlStateNormal];
    }else{
        [_videoReplyCount setTitle:NSLocalizedString(@" ", nil) forState:UIControlStateNormal];
    }
    [_videoReplyCount addTarget:self action:@selector(replyCountTouch) forControlEvents:UIControlEventTouchUpInside];
}

-(void) replyCountTouch{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(VideoListCellReplyTouch)]) {
        [_delegate VideoListCellReplyTouch];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_image release];
    [_videoTitle release];
    [_videoContent release];
    [_videoCategory release];
    [_videoSize release];
    [_videoReplyCount release];
    [_createTime release];
    [_userName release];
    [_videoPlayImage release];
    [super dealloc];
}
@end
