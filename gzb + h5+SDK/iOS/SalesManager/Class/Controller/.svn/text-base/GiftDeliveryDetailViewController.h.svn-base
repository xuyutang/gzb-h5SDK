//
//  GiftDeliveryDetailViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"

@interface GiftDeliveryDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    TextViewCell *textViewCell0;
    LiveImageCell *liveImageCell;
    
    NSMutableArray *imageFiles;
    GiftDelivery *giftDelivery;
    int giftDeliveryId;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) GiftDelivery *giftDelivery;
@property(nonatomic,assign) int giftDeliveryId;
@property(nonatomic,assign) int msgType;
-(id)init;


@end
