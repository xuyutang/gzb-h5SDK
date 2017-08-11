//
//  BusinessOpportunityCell.h
//  SalesManager
//
//  Created by 章力 on 14-5-6.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessOpportunityCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *customer;
@property (retain, nonatomic) IBOutlet UILabel *bizOppName;
@property (retain, nonatomic) IBOutlet UILabel *bizOppPrincipal;
@property (retain, nonatomic) IBOutlet UILabel *user;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UIButton *btnApprove;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;

@end
