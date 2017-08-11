//
//  GiftDistributeDetailViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "InputCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"

@interface GiftDistributeDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate,UITextFieldDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    InputCell *inputCell;
    LiveImageCell *liveImageCell;
    TextViewCell *textViewCell;
    
    NSMutableArray *imageFiles;
    GiftDistribute *giftDistribute;
    int giftDistributeId;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) GiftDistribute *giftDistribute;
@property(nonatomic,assign) int giftDistributeId;
@property(nonatomic,assign) int msgType;
-(id)init;


@end
