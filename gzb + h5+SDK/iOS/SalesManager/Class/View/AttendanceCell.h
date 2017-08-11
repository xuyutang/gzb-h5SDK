//
//  AttendanceCell.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-10-21.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *checkInTime;
@property (retain, nonatomic) IBOutlet UILabel *checkInAddress;
@property (retain, nonatomic) IBOutlet UILabel *checkInComment;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UIButton *btApprove;
@property (retain, nonatomic) IBOutlet UIImageView *ivImage;
@property (retain, nonatomic) IBOutlet UIButton *category;
@end
