//
//  PickerVideoCell.h
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ALBBQuPaiPlugin/ALBBQuPaiPluginPluginServiceProtocol.h>
#import <TAESDK/TAESDK.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Util.h"


/**
 *拍摄类型 (根据不同类型,获取指定的拍摄时间)
 */
typedef enum PickerVideoType{
    PickerVideoTypePatroVideo = 0,  //巡访报告拍摄时间
    PickerVideoTypeVideo            //视频管理拍摄时间
};

@protocol PickerVideoDelegate <NSObject>

-(void) PickerVideoTouch:(NSString*)videPath photoPath:(NSString*)photoPath;

@end

@interface PickerVideoCell : UITableViewCell<QupaiSDKDelegate>
{
    UIViewController*   _pickerView;//相机
}

@property (assign, nonatomic) BOOL                  bPickerVideo;//是否已经拍摄
@property (retain, nonatomic) UIImageView*              icon;
@property (retain, nonatomic) UIViewController*     parentVC;
@property (retain, nonatomic) NSString*             videoPath;
@property (assign, nonatomic) id<PickerVideoDelegate> delegate;
@property (retain, nonatomic) UIView*               container;
@property (retain, nonatomic) AVPlayer*             player;

@property (copy,nonatomic) void(^firstClick) (NSObject *pickerVideo);

@property(assign,nonatomic) id<ALBBQuPaiPluginPluginServiceProtocol> taeSDK;

@property (nonatomic) enum PickerVideoType pickVideoType;


-(void) playOrPickerVide;
-(void) imageLongPress;
@end
