//
//  CustomerTypeView.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomerTypeViewDelegate <NSObject>

@optional
-(void)selectedCustomerCategory:(CustomerCategory *)category status:(BOOL)checked;

@end
@interface CustomerTypeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *customerTypes;
}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)id<CustomerTypeViewDelegate> delegate;

- (void)initView;


@end
