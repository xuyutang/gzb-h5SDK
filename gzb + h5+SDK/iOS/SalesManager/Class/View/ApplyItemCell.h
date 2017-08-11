//
//  ApplyItemCell.h
//  SalesManager
//
//  Created by 章力 on 14-9-22.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"

@interface ApplyItemCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UIButton *btnApprove;
@property (retain, nonatomic) IBOutlet UILabel *content;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheck;
@property (retain, nonatomic) IBOutlet QCheckBox *checkBox;
@property (retain, nonatomic) IBOutlet UILabel *lblCategory;
@property (retain, nonatomic) IBOutlet UIImageView *userImage;

@end
