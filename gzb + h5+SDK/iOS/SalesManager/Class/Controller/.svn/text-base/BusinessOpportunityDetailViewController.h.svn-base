//
//  BusinessOpportunityDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 6/5/14.
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

- (void) refresh:(BusinessOpportunity*) bizopp;

@end

@interface BusinessOpportunityDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{
    UIView *rightView;
    
    UITableView *tableView;
    ExpandCell *expandCell;
    
    CustomerCategory *currentCategory;
    NSMutableArray *imageFiles;
    BusinessOpportunity *currentBizOpp;
    int bizoppId;
    
    UITextView *textView;
    TextViewCell *tvReplyCell;
    BusinessOpportunityReply* bizReply;
    NSString* sBizReply;
    id<RefreshTableViewDelegate> delegate;
}

@property(nonatomic,retain) BusinessOpportunity *currentBizOpp;
@property(nonatomic,assign) int bizoppId;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,strong) id<RefreshTableViewDelegate> delegate;
@property(nonatomic,assign) int msgType;

-(id)init;


@end
