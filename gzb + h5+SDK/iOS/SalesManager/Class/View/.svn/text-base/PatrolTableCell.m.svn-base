//
//  PatrolTableCell.m
//  SalesManager
//
//  Created by liuxueyan on 14-10-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "PatrolTableCell.h"
#import "Constant.h"

@implementation PatrolTableCell
@synthesize icon,title,subTitle1,subTitle2,name;

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
-(void)setVideoSize:(NSString *)videoSize{
    _videoSize = videoSize;
    //subtitle2
    
    if (lbVideoSize == nil) {
        
        
        lbVideoSize = [[[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH - subTitle2.frame.size.width / 2 - 8,
                                                                subTitle2.frame.origin.y,
                                                                subTitle2.frame.size.width / 2 + 10,
                                                                subTitle2.frame.size.height)] retain];
        
        
        lbVideoSize.backgroundColor = WT_CLEARCOLOR;
        if (!IOS7) {
            CGRect r = lbVideoSize.frame;
            r.origin.x -= 15;
            lbVideoSize.frame = r;
        }
        
        lbVideoSize.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:lbVideoSize];
        
        //缩短title2的宽度
        CGRect r = subTitle2.frame;
        r.size.width /= 2;
        subTitle2.frame = r;
    }
    lbVideoSize.text = [NSString stringWithFormat:NSLocalizedString(@"video_lable_video_size", nil),_videoSize];
    if (lbPlayIcon == nil) {
        lbPlayIcon = [[[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width / 2 - 15, icon.frame.size.height / 2 - 15, 30, 30)] retain];
        lbPlayIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
        lbPlayIcon.textColor = WT_LIGHT_GRAY;
        lbPlayIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *playGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(playAction)];
        playGesture.numberOfTapsRequired = 1;
        [icon setBackgroundColor:WT_CLEARCOLOR];
        [icon addGestureRecognizer:playGesture];
        [icon setUserInteractionEnabled:YES];
        [icon addSubview:lbPlayIcon];
    }
    lbPlayIcon.backgroundColor = WT_CLEARCOLOR;
    lbPlayIcon.text = [NSString fontAwesomeIconStringForEnum:ICON_PLAY];
}


-(void) playAction{
    NSLog(@"播放视频：");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentVC.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    PlayVideViewController* playVC = [[PlayVideViewController alloc] init];
    playVC.videoPath = self.videoPath;
    playVC.delegate = self;
    playVC.bNetWork = YES;
    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:playVC];
    navCtrl.navigationBarHidden = YES;
    [self.parentVC presentViewController:navCtrl animated:YES completion:nil];
    [navCtrl release];
    [playVC release];
}

-(void)MPMoviePlayerPlayback{
    [MBProgressHUD hideHUDForView:self.parentVC.view animated:YES];
}

- (void)dealloc {
    [icon release];
    [title release];
    [subTitle1 release];
    [subTitle2 release];
    [name release];
    [_time release];
    [_btApprove release];
    [_parentVC release];
//    [_videoPath release];
//    [_videoSize release];
    [super dealloc];
}

@end
