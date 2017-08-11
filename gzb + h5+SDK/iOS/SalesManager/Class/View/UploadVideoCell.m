//
//  UploadVideoCellTableViewCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "UploadVideoCell.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "VideoDetailViewController.h"

@implementation UploadVideoCell
{
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView rowHeight:(CGFloat)height leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView rowHeight:height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self) {
        //[self initView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self initView];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        //[self initView];
    }
    return self;
}

-(void) initView{
    //缩略图
    self.frame = CGRectMake(0, 0, MAINWIDTH, 80);
    _image = [[UIImageView alloc] init];
    _image.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_image];
    [_image release];
    
    //标题
    _videoTitle = [[UILabel alloc] init];
    _videoTitle.textAlignment = UITextAlignmentLeft;
    _videoTitle.font = [UIFont systemFontOfSize:17.f];
    _videoTitle.backgroundColor = WT_CLEARCOLOR;
    [self addSubview:_videoTitle];
    [_videoTitle release];
    
    //类型
    _videoCategory = [[UILabel alloc] init];
    _videoCategory.textAlignment = UITextAlignmentLeft;
    _videoCategory.font = [UIFont systemFontOfSize:12.f];
    _videoCategory.backgroundColor = WT_CLEARCOLOR;
    _videoCategory.textColor = WT_LIGHT_GRAY;
    [self addSubview:_videoCategory];
    [_videoCategory release];
    
    
    //视频大小
    _fileSize = [[UILabel alloc] init];
    _fileSize.textAlignment = UITextAlignmentLeft;
    _fileSize.font = [UIFont systemFontOfSize:12.f];
    _fileSize.textColor = WT_LIGHT_GRAY;
    _fileSize.backgroundColor = WT_CLEARCOLOR;
    [self addSubview:_fileSize];
    [_fileSize release];
    
    //时间
    _time = [[UILabel alloc] init];
    _time.textAlignment = UITextAlignmentRight;
    _time.font = [UIFont systemFontOfSize:12.f];
    _time.backgroundColor = WT_CLEARCOLOR;
    _time.textColor = WT_LIGHT_GRAY;
    [self addSubview:_time];
    [_time release];
    
    //播放按钮
    _icon = [[UIButton alloc] init];
    _icon.font = [UIFont fontWithName:@"FontAwesome" size:20];
    [self addSubview:_icon];
    [_icon setTitleColor:WT_GRAY forState:UIControlStateNormal];
    _icon.titleLabel.textAlignment = UITextAlignmentCenter;
    [_icon addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    _icon.backgroundColor = WT_CLEARCOLOR;
    [_icon release];
    
    //上传按钮
    _btnUpload = [[UIButton alloc] init];
    _btnUpload.font = [UIFont fontWithName:@"FontAwesome" size:30.f];
    [_btnUpload setTitleColor:WT_RED forState:UIControlStateNormal];
    [_btnUpload setTitle:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD] forState:UIControlStateNormal];
    _btnUpload.backgroundColor = WT_CLEARCOLOR;
    [self addSubview:_btnUpload];
    [_btnUpload release];
}

-(void)initSubviews{
    [super initSubviews];
    [self initView];
    _image.frame = CGRectMake(0, 0, 80, 80);
    _videoTitle.frame = CGRectMake(83, 3, 229, 21);
    _videoCategory.frame = CGRectMake(83, 33, 132, 32);
    _fileSize.frame = CGRectMake(83, 59, 110, 21);
    _btnUpload.frame = CGRectMake(269, 25, 37, 39);
    _time.frame = CGRectMake(189, 59, 123, 21);
    _icon.frame = CGRectMake(30, 30, 20,20);
    
}

-(void)setVideo:(VideoTopic *)video{
    _video = video;
    if (_video != nil) {
        NSString* imageUrl = [_video.filePaths objectAtIndex:0];
        _image.backgroundColor = WT_CLEARCOLOR;
        if (imageUrl != nil) {
            _image.image = [UIImage imageWithContentsOfFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:imageUrl]];
        }
        _videoTitle.text = _video.title;
        _videoCategory.text = _video.category.name;
        _fileSize.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_video_size", nil),[_video.videoSizes objectAtIndex:0]];
        _time.text = _video.createDate;
        [_icon setTitle:[NSString fontAwesomeIconStringForEnum:ICON_PLAY] forState:UIControlStateNormal];
    }
}

//播放完成回调
-(void)MPMoviePlayerPlayback{
    [MBProgressHUD hideHUDForView:_parentView.view animated:NO];
}

-(void) playVideo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parentView.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    PlayVideViewController* playVC = [[PlayVideViewController alloc] init];
    if (_video.videoPaths.count > 0) {
        playVC.videoPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[_video.videoPaths objectAtIndex:0]];
        playVC.delegate = self;
        UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:playVC];
        navCtrl.navigationBarHidden = YES;
        [_parentView presentViewController:navCtrl animated:YES completion:nil];
        [navCtrl release];
        
    }
    [playVC release];
}



- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_image release];
    [_videoTitle release];
    [_videoCategory release];
    [_fileSize release];
    [_time release];
    [_btnUpload release];
    [super dealloc];
}
@end
