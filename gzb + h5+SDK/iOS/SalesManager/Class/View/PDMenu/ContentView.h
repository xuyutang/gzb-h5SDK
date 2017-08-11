//
//  ContentView.h
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tvb;
}

@property (nonatomic,strong) NSMutableArray *dataSource;

-(void) reloadTable;

-(void) initView;

@property (nonatomic,copy) void(^clicked) (id);

@end
