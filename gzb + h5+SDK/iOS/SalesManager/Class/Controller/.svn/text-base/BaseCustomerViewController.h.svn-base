//
//  BaseCustomerViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/16.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "CustTagSelectViewController.h"

@interface BaseCustomerViewController : BaseViewController<CustTagSelectControllerDelegate>
@property(nonatomic,retain) UIViewController *parentController;
@property(nonatomic,retain) User* user;
@property (nonatomic,assign) BOOL bHideFuncBtn;                     //CELL 的功能按钮是否隐藏
@property (nonatomic,retain) PullTableView *tableView;
@property (nonatomic,retain) NSMutableArray *selectTags;
@property (nonatomic,retain) NSMutableArray *customerArray;

-(void)reload;

-(void) initRightAddButton;
//子类拓展收藏等功能
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
