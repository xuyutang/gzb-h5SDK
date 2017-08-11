//
//  VideoCustomerDetailCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/9.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "VideoCustomerDetailCell.h"
#import "Constant.h"

@implementation VideoCustomerDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setVideo:(VideoTopic *)video{
    _video = video;
    if (_video == nil) {
        return;
    }
    if (_videoCategory == nil) {
        _videoCategory = [[UILabel alloc] initWithFrame:CGRectMake(8, 93, 71, 21)];
        _videoCategory.font = [UIFont systemFontOfSize:13];
        _videoCategory.textColor = WT_DARK_GRAY;
        _videoCategory.textAlignment = UITextAlignmentLeft;
        [self addSubview:_videoCategory];
    }
    
    VideoDurationCategory *duration = (VideoDurationCategory *)[_video.videoDurationCategories objectAtIndex:0];
    _videoDuration.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_video_duration", nil),duration.durationValue];
    _videoCategory.text = _video.category.name;
    _videoSize.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_video_size", nil),[_video.videoSizes objectAtIndex:0]];
    
    //拍摄时间
    _uploadTime.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_take_time", nil),_video.createDate];
    
    //缓存时间
    _cacheTime.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_upload_time", nil),_video.uploadDate];
    
    //拍摄地址
    NSString *addr = @"";
    if (_video.location.address == nil || _video.location.address.length == 0) {
        addr = [NSString stringWithFormat:@"%f,%f",_video.location.latitude,_video.location.longitude];
    }else{
        addr = _video.location.address;
    }
    _address.text = addr;
    //缓存地址
    NSString *cacheAddr = @"";
    if (_video.uploadLocation.address == nil || _video.uploadLocation.address.length == 0) {
        cacheAddr = [NSString stringWithFormat:@"%f,%f",_video.uploadLocation.latitude,_video.uploadLocation.longitude];
    }else{
        cacheAddr = _video.uploadLocation.address;
    }
    _cacheAddress.text = cacheAddr;
    
    //变动高度
    float height = [self isChangeHeight:_address str: _address.text];
    if (height > 0) {
        _address.frame = [self addFrameHeight:_address height:height];
        _uploadTime.frame = [self addFrameY:_uploadTime y:height];
        _cacheAddress.frame = [self addFrameY:_cacheAddress y:height];
        _cacheTime.frame = [self addFrameY:_cacheTime y:height];
        _lb_UpdAdd.frame = [self addFrameY:_lb_UpdAdd y:height];
        _videoSize.frame = [self addFrameY:_videoSize y:height];
        _videoDuration.frame = [self addFrameY:_videoDuration y:height];
        _videoCategory.frame = [self addFrameY:_videoCategory y:height];
    }
    height = [self isChangeHeight:_cacheAddress str: _cacheAddress.text];
    if (height > 0) {
        _cacheAddress.frame = [self addFrameHeight:_cacheAddress height:height];
        _cacheTime.frame = [self addFrameY:_cacheTime y:height];
        _videoSize.frame = [self addFrameY:_videoSize y:height];
        _videoDuration.frame = [self addFrameY:_videoDuration y:height];
        _videoCategory.frame = [self addFrameY:_videoCategory y:height];
    }
}


//新增视图高度
-(CGRect) addFrameHeight:(UIView *) view height:(float) height{
    CGRect r = view.frame;
    r.size.height = height;
    return r;
}

//新增视图y坐标
-(CGRect) addFrameY:(UIView *) view y:(float) height{
    CGRect r = view.frame;
    r.origin.y += height / 2;
    return r;
}


//是否需要改变高度 需要改变返回高度 不需要则返回0
-(float) isChangeHeight:(UIView *) view  str:(NSString *) str{
    //返回cell 高度的时候由于宽高找不到 宽高定死
    float tmpHeight = view != nil ? view.frame.size.height : 20.f;
    float tmpWidth = view != nil ? view.frame.size.width : 243.f;
    BaseViewController *bvc = [[[BaseViewController alloc] init] autorelease];
    CGSize size = [bvc rebuildSizeWithString:str ContentWidth:tmpWidth FontSize:FONT_SIZE + 1];
    if (size.height > tmpHeight) {
        return size.height;
    }
    return 0;
}

#pragma -mark 公共方法
//取 cell 变动高度
-(float) getCellHeight:(NSString *) address cacheAdd:(NSString *)cacheAdd{
    float height1 = [self isChangeHeight:_address str: address];
    float height2 = [self isChangeHeight:_cacheAddress str: cacheAdd];
    NSLog(@"%f,%f",height1,height2);
    return 124.f + (height1 > 0 ? height1 / 2 + 1 : 0) + (height2 > 0 ? height2 / 2 + 1 : 0) ;
}

- (void)dealloc {
    [_address release];
    [_videoSize release];
    [_videoCategory release];
    [_uploadTime release];
    [_videoDuration release];
    [_cacheAddress release];
    [_cacheTime release];
    [_lb_takeAdd release];
    [_lb_UpdAdd release];
    [super dealloc];
}
@end
