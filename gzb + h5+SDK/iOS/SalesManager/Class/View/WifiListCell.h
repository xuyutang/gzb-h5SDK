//
//  WifiListCell.h
//  SalesManager
//
//  Created by iOS-Dev on 16/12/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *wifiOtherNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *wifiNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UIImageView *wifiEnableImageView;
@property (retain, nonatomic) IBOutlet UIImageView *wifiSwichImageView;

@end
