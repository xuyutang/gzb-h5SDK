//
//  CustomerListCell.h
//  SalesManager
//
//  Created by liuxueyan on 15-4-24.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CustomerListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet RTLabel *name;
@property (retain, nonatomic) IBOutlet UILabel *distance;
@property (retain, nonatomic) IBOutlet UILabel *type;
@property (retain, nonatomic) IBOutlet UILabel *locate;
@property (retain, nonatomic) IBOutlet UILabel *tel;
@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UILabel *cloud;
@property (retain, nonatomic) IBOutlet UIButton *btFunction;
@property (retain, nonatomic) IBOutlet UILabel *icon;
@property (retain, nonatomic) IBOutlet UIButton *btLocate;
@property (retain, nonatomic) IBOutlet UIButton *btPhone;

@property (nonatomic,retain) id object;
@property (nonatomic,assign) BOOL bHideFuncBtn;     //显示隐藏功能按钮
@property (nonatomic,assign) BOOL bShowFav;         //显示收藏收藏按钮
@property (nonatomic,assign) BOOL bFav;             //收藏展示状态
@property (nonatomic,copy) void(^favTouchAction) (CustomerListCell *sender);

-(CustomerListCell *) setFavStatus:(BOOL) bShow bfav:(BOOL) bfav;
@end
