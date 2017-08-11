//
//  GiftStockDetailViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"

@interface GiftStockDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    
    NSMutableArray *imageFiles;
    GiftStock *giftStock;
    int giftStockId;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) GiftStock *giftStock;
@property(nonatomic,assign) int giftStockId;
@property(nonatomic,assign) int msgType;
-(id)init;


@end
