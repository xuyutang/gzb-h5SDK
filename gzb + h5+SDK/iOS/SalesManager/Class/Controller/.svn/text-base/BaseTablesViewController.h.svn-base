//
//  BaseTablesViewController.h
//  SalesManager
//
//  Created by liu xueyan on 10/16/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "SMTableView.h"
#import "BaseTable1HeaderView.h"
#import "BaseTable3HeaderView.h"
#import "BaseTable4HeaderView.h"
#import "SWTableViewCell.h"
#import "TextViewCell.h"
#import "CustomerSelectViewController.h"

@interface BaseTablesViewController : BaseViewController<CustomerCategoryDelegate,SWTableViewCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>{
    
    UIView *rightView;
    SMTableView *tableView;
    Customer *currentCustomer;
    NSMutableArray *productArray;
    NSMutableArray *favorateArray;
    NSMutableArray *targetArray;
    
    NSString *remark;
    UIButton *btNumber;
    UISearchBar *searchBar;
    UITextField *currentTextField;
    UITextView *currentTextView;
    BOOL bHasKeyboard;
    BOOL bProductExpand;
    BOOL bTargetExpand;
    BOOL bFavorateExpand;
    BOOL bEdit;
    BOOL bHasSupply;
    int currentPage;
    NSString *searchContent;
    
    BaseTable1HeaderView *header4;
    BaseTable1HeaderView *header3;
    BaseTable4HeaderView *header2;
    BaseTable1HeaderView *header1;//收藏
    
    TextViewCell *tvRemarkCell;
    
    int productTotal;
}

-(void)initView;
-(void)toList:(id)sender;
-(void)toSave:(id)sender;
-(void)clearTable;
-(void)dismissKeyBoard;
-(void)setHeader3Title;
-(IBAction)finishedInput;
-(void)showMessage:(ActionCode)resultCode Title:(NSString*)title Description:(NSString*)desc;

@end
