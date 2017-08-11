//
//  ProductCell.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *product;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UILabel *unit;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *RMBLabel;
@property (retain, nonatomic) IBOutlet UILabel *count;
@end
