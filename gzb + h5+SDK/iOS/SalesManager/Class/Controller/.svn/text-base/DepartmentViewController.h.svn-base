//
//  DepartmentViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "SinTreeCheckNode.h"
#import "SinTreeCheckView.h"
#import "ZKTreeView.h"

typedef enum : NSUInteger {
    TreeTypeDepartment = 0,
    TreeTypeProductCategory
} TreeType;

@protocol DepartmentViewControllerDelegate <NSObject>

@optional
-(void)didFnishedCheck:(NSMutableArray *)departments;
-(void)didFnished:(NSMutableArray *)departments;
@end

@interface DepartmentViewController : BaseViewController{

    ZKTreeView *treeView;
    NSMutableArray *departmentArray;
    NSMutableArray *selectedArray;
    id<DepartmentViewControllerDelegate> delegate;
    BOOL savebool;
    
}
@property (nonatomic,assign) BOOL departBool;
@property(nonatomic,retain) NSMutableArray *selectedArray;
@property(nonatomic,retain) NSMutableArray *departmentArray;
@property(nonatomic,assign) id<DepartmentViewControllerDelegate> delegate;
@property (nonatomic) TreeType treeType;

-(void)createDepartmentTree;
-(void) resetButtonLocation;
@end
