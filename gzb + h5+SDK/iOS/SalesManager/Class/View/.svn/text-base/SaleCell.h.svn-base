//
//  SaleCell.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBArray;
@interface SaleCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *customer;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *updateTime;
@property (retain, nonatomic) IBOutlet UILabel *total;
@property (retain, nonatomic) IBOutlet UITableView *productTableView;
@property (retain, nonatomic) IBOutlet UILabel *lMark;

@property (retain,nonatomic) PBArray* products;
@property (nonatomic,assign) BOOL hiddenPrice;
- (void) showProducts;
@end
