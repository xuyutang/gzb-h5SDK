//
//  AlarmItemCell.h
//  SalesManager
//
//  Created by liuxueyan on 15/6/9.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface AlarmItemCell : SWTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UISwitch *onoff;

@end
