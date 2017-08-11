//
//  ResearchDetailViewController.h
//  SalesManager
//
//  Created by liu xueyan on 1/24/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"
#import "ExpandCell.h"
#import "CategoryPickerView.h"
#import "InputCell.h"
#import "SelectCell.h"
#import "AppDelegate.h"

@protocol RefreshTableViewDelegate <NSObject>

- (void) refresh:(Patrol*) patrol;

@end

@interface ResearchDetailViewController : BaseViewController<LiveImageCellDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,RequestAgentDelegate>{
    UIView *rightView;
    
    UITableView *tableView;
    ExpandCell *expandCell;
    TextViewCell *tvReplyCell;
    NSString *strMarketResearchReply;
    MarketResearchReply *marketResearchReply;
    
    CustomerCategory *currentCategory;
    NSMutableArray *imageFiles;
    MarketResearch *currentMarketResearch;
    int martketresearchId;
    id<RefreshTableViewDelegate> delegate;

}

@property(nonatomic,assign) id<RefreshTableViewDelegate> delegate;
@property(nonatomic,retain) MarketResearch *currentMarketResearch;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,assign) int martketresearchId;
@property(nonatomic,assign) int msgType;
-(id)init;
@end
