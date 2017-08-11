//
//  GiftProductsCell.h
//  SalesManager
//
//  Created by 章力 on 14-9-26.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBArray;
@interface GiftProductsCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *customer;
@property (retain, nonatomic) IBOutlet UILabel *total;
@property (retain, nonatomic) IBOutlet UITableView *productTableView;

@property (retain,nonatomic) PBArray* products;
@property (nonatomic,assign) BOOL hiddenPrice;
- (void) showProducts;


@end
