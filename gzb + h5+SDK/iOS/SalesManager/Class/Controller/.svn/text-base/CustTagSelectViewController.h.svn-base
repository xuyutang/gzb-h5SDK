//
//  DepartmentViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "ZKTreeView.h"
#import "ZKTreeCell.h"


@interface TagObj : NSObject

@property (nonatomic,retain) CustomerTag *tag;
@property (nonatomic,retain) NSMutableArray *tagValueArray;

@end



@protocol CustTagSelectControllerDelegate <NSObject>

@optional
//TagValues
-(void)custTagSelecDidFnishedCheck:(NSMutableArray *)array;
-(void)custTagSelectDidFnished:(NSMutableArray *)array;

//Tag
-(void)custTagTreeDidFnishedCheck:(NSMutableArray *)array;
@end

@interface CustTagSelectViewController : BaseViewController{

    ZKTreeView *treeView;
    id<CustTagSelectControllerDelegate> delegate;
    
}

@property(nonatomic,retain) NSMutableArray *selectedArray;
@property(nonatomic,retain) NSMutableArray *tagArray;
@property (nonatomic,retain) NSMutableArray *tagValueArray;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property(nonatomic,assign) id<CustTagSelectControllerDelegate> delegate;
@property (nonatomic,assign) BOOL bSingle;
@property (nonatomic,assign) BOOL bView;

@end
