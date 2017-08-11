//
//  DataReportTypeViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/29.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class DataReportTypeViewController;

@protocol  DataReportTypeDelegate<NSObject>

- (void)datareportSearch:(DataReportTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)datareportSearchDidCanceled:(DataReportTypeViewController *)controller;
- (void)allTemplate;

@end

@interface DataReportTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *datareportTypes;
    NSMutableArray *filterTypes;
    PaperTemplate *myFavorate;
    NSMutableArray *mulArray ;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
    BOOL hidenBool;
    BOOL allBool;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *datareportTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;
@property(nonatomic,assign)  BOOL allBool;

@property(nonatomic,assign)  BOOL hidenBool;
@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<DataReportTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

-(void)setDataList:(NSArray *)datareportTypes;
-(void)reload;


@end
