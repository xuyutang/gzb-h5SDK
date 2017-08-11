//
//  TreeView.h
//  MyTreeView
//
//  Created by Administrator on 16/1/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTreeCell.h"

@interface ZKTreeView : UITableViewController
{
    NSMutableDictionary *_countDic;
}
@property (nonatomic,assign) BOOL bCheckParent;
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,strong) NSMutableArray *checkedArray;
@property (nonatomic,assign) int selectCount;
@property (nonatomic,assign) int maxSelectCount;
@property (nonatomic,assign) BOOL bSingle;

//展开CELL
-(void) expandNodeWithDepth:(int) depth;
-(void) cancelAllCheckedCell;
@end
