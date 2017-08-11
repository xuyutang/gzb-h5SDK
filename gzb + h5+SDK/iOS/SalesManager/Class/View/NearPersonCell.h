//
//  NearPersonCell.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-7.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearPersonCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *department;
@property (retain, nonatomic) IBOutlet UILabel *icLocal;
@property (retain, nonatomic) IBOutlet UILabel *distance;
@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UILabel *lView;

@end
