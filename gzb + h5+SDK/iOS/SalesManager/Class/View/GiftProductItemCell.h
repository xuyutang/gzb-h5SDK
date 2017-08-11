//
//  GiftProductItemCell.h
//  SalesManager
//
//  Created by 章力 on 14-9-26.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftProductItemCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *product;
@property (retain, nonatomic) IBOutlet UILabel *modelName;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UILabel *unit;
@property (retain, nonatomic) IBOutlet UILabel *count;

@end
