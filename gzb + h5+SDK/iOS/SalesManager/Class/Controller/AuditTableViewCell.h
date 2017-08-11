//
//  AuditTableViewCell.h
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/17.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *auditName;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UILabel *comment;
@property (retain, nonatomic) IBOutlet UILabel *status;

@end
