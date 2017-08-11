//
//  PatrolDetailViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"

@protocol RefreshTableViewDelegate <NSObject>

- (void) refresh:(Patrol*) patrol;

@end

@interface PatrolDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,SMWebSocketDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    TextViewCell *tvReplyCell;
    
    NSMutableArray *imageFiles;
    Patrol *patrol;
    int patrolId;
    UITextView *textView;
    
    PatrolReply *patrolReply;
    NSString *strPatrolReply;
    id<RefreshTableViewDelegate> delegate;
}

@property(nonatomic,assign) id<RefreshTableViewDelegate> delegate;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) Patrol *patrol;
@property(nonatomic,assign) int patrolId;
-(id)init;

@end
