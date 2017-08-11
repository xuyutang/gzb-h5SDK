//
//  GiftPurchaseViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-17.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "SMTableView.h"
#import "BaseTable1HeaderView.h"
#import "BaseTable3HeaderView.h"
#import "BaseTable2HeaderView.h"
#import "SWTableViewCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "ApplyListViewController.h"
#import "ExpandCell.h"

@class AppDelegate;
@interface GiftPurchaseViewController : BaseViewController<ApplyListViewControllerDelegate,SWTableViewCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,LiveImageCellDelegate>{
    
    UIView *rightView;
    SMTableView *tableView;
    NSMutableArray *productModelArray;
    NSMutableArray *targetModelArray;
    NSMutableArray *applyItemArray;
    NSMutableArray *imageFiles;

    UIButton *btNumber;
    UISearchBar *searchBar;
    UITextField *currentTextField;
    UITextView *currentTextView;
    BOOL bHasKeyboard;
    BOOL bProductExpand;
    BOOL bTargetExpand;
    BOOL bExpand;
    BOOL bEdit;
    BOOL bHasSupply;
    int currentPage;
    NSString *searchContent;
    
    BaseTable1HeaderView *header4;
    BaseTable1HeaderView *header3;
    BaseTable2HeaderView *header2;
    
    LiveImageCell *liveImageCell;
    TextViewCell *tvRemarkCell;
    ExpandCell *expandCell;
    UIViewController *parentCtrl;
    int productTotal;
    BOOL bHasSync;
}

-(void)initView;
-(void)toList:(id)sender;
-(void)toSave:(id)sender;
-(void)clearTable;
-(void)dismissKeyBoard;
-(void)setHeader3Title;
-(IBAction)finishedInput;
-(void)showMessage:(ActionCode)resultCode Title:(NSString*)title Description:(NSString*)desc;

@property (nonatomic,strong) UIImageView *expandIcon;
@property(nonatomic,retain) UIViewController *parentCtrl;
@end
