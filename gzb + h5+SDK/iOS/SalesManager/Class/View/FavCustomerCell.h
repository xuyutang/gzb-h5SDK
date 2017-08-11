//
//  FavCustomerCell.h
//  SalesManager
//
//  Created by Administrator on 16/3/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavCustomerCell : UITableViewCell

@property (nonatomic,retain) Customer *cust;
@property (nonatomic,retain) UIImageView *favButton;
@property (nonatomic,assign) BOOL bCheck;

@property (nonatomic,copy) void(^click) (FavCustomerCell *);
@property (nonatomic,retain) UILabel *type;

-(void) setFav:(BOOL) ist;
@end
