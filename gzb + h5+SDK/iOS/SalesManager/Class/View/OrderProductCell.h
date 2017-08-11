//
//  OrderProductCell.h
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface OrderProductCell : SWTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UITextField *count;
@property (retain, nonatomic) IBOutlet UILabel *unit;
@property (retain, nonatomic) IBOutlet UITextField *price;

@end
