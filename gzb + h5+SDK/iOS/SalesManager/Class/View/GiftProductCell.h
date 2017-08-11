//
//  GiftProductCell.h
//  SalesManager
//
//  Created by 章力 on 14-9-18.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "SWTableViewCell.h"

@interface GiftProductCell : SWTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *productModel;
@property (retain, nonatomic) IBOutlet UITextField *count;
@property (retain, nonatomic) IBOutlet UILabel *unit;
@property (retain, nonatomic) IBOutlet UITextField *price;
@end
