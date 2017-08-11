//
//  PDMenu.h
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentView.h"

@interface PDMenu : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tvb1;
    ContentView *tvb2;
}
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,copy) void(^clicked) (id);
@end
