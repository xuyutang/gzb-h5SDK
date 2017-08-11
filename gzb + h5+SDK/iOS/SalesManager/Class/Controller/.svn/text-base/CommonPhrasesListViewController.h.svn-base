//
//  CommonPhrasesViewController.h
//  SalesManager
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PullTableView.h"
#import "SWLableCell.h"
@interface CommonPhrasesListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate,RequestAgentDelegate>
{
    UIView          *_rightView;
    NSMutableArray  *_dataList;
    UITableView     *_tableView;
    int             _currentIndex;
}
@property (nonatomic,assign) BOOL bSelect;
@property (nonatomic,copy) void(^selectedItem) (FavoriteLang *favoriteLang);
@end
