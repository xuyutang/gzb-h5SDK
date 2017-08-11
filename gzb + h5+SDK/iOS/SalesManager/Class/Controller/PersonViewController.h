//
//  PersonViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/8.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "CompanyContactCell.h"
#import "PullTableView.h"
#import "BaseViewController.h"

typedef void(^chosePerson)(NSMutableArray *array);

@class MBProgressHUD;
@interface PersonViewController : BaseViewController<MFMessageComposeViewControllerDelegate,CompanyContactCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    
    UISearchBar *searchBar;
    NSMutableArray *contacts;
    NSMutableArray *filterContacts;
    
    NSMutableArray *selectTels;
    MBProgressHUD *HUD;
    UIViewController *parentCtrl;
}
- (void) reload;
@property(nonatomic,retain) PullTableView *tableView;
@property(nonatomic,retain) NSMutableArray *selectTels;
@property(nonatomic,retain) NSMutableArray *selectNames;
@property(nonatomic,retain) UIViewController *parentCtrl;
@property (nonatomic, copy) chosePerson choseBlock;
//是否是单选 ;
@property (nonatomic,assign) BOOL radioBool;
@property (nonatomic,copy) NSString *messageTitle;
-(void)getPersonsWithBlock:(chosePerson)block;

@end

