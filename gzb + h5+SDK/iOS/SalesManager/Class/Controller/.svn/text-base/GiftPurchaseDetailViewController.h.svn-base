//
//  GiftPurchaseDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"


@interface GiftPurchaseDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    
    NSMutableArray *imageFiles;
    GiftPurchase *giftPurchase;
    int giftPurchaseId;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) GiftPurchase *giftPurchase;
@property(nonatomic,assign) int giftPurchaseId;
@property(nonatomic,assign) int msgType;
-(id)init;


@end
