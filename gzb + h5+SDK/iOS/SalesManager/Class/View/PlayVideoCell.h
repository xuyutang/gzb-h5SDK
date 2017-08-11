//
//  PlayVideoCell.h
//  SalesManager
//
//  Created by Administrator on 15/11/11.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoCell : UITableViewCell
{
}

@property (assign,nonatomic) BOOL bPlayEnd;
@property (assign,nonatomic) BOOL bNetwork;
@property (retain,nonatomic) NSString *videoPath;
@property (nonatomic,retain) NSString *imgPath;
@property (nonatomic,retain) AVPlayer *player;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bNetwork:(BOOL) bNetwork;

-(void)deallocPlayer;
@end
