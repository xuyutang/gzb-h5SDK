//
//  DateReportCell.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateReportCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *ivImage;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *mType;

@end
