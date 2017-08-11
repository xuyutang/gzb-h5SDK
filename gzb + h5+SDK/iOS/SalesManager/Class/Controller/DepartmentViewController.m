//
//  DepartmentViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "DepartmentViewController.h"


@interface DepartmentViewController ()
{
    UIView *buttonView;
}
@end

@implementation DepartmentViewController
@synthesize delegate,departmentArray,selectedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_departBool) {
         lblFunctionName.text = @"部门选择";
    }
   // leftImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_BACK];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *checkAllImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    checkAllImageView.image = [UIImage imageNamed:@"ab_icon_save.png"];
//    checkAllImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
//    checkAllImageView.textColor = WT_RED;
//    checkAllImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    checkAllImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveDone)];
    [tapGesture1 setNumberOfTapsRequired:1];
    checkAllImageView.contentMode = UIViewContentModeScaleAspectFit;
    [checkAllImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:checkAllImageView];
    [checkAllImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [tapGesture1 release];
    [self initTree];
}


-(void) initTree{
    treeView = [[ZKTreeView alloc] init];
    treeView.bCheckParent = YES;
    treeView.cells = [self createTreeSource:departmentArray];
    
    treeView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    [treeView expandNodeWithDepth:3];
    [self addChildViewController:treeView];
    [self.view addSubview:self.childViewControllers.firstObject.view];
    
    buttonView = [[UIButton alloc] init];
    [buttonView setBackgroundColor:treeView.view.backgroundColor];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 60, 30)];
    [leftButton setBackgroundColor:WT_RED];
    [leftButton setTitleColor:WT_WHITE forState:UIControlStateNormal];
    [leftButton setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [leftButton setTitle:NSLocalizedString(@"btn_reset", nil) forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelCheckedAllCell) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:leftButton];
    [self.view addSubview:buttonView];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(treeView.view.frame.size.width - 70, 7, 60, 30)];
    [rightButton setBackgroundColor:WT_RED];
    [rightButton setTitleColor:WT_WHITE forState:UIControlStateNormal];
    [rightButton setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [rightButton setTitle:NSLocalizedString(@"btn_search", nil) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(checkDone) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:rightButton];
    [self.view addSubview:buttonView];
    [rightButton release];
    [leftButton release];
    
    if (_departBool) {
        leftButton.hidden = YES;
        rightButton.hidden = YES;
        treeView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


-(void)viewWillAppear:(BOOL)animated{
    buttonView.frame = CGRectMake(0,treeView.view.frame.size.height, self.view.frame.size.width, 44);
    [super viewWillAppear:animated];
}

#pragma -mark -树操作

-(void) cancelCheckedAllCell{
    [treeView cancelAllCheckedCell];
}


#pragma -mark  -构造部门树数据源
//构造CELL 数据源
-(NSMutableArray *) createTreeSource:(NSMutableArray *) source{
    NSMutableArray *_cells = [[[NSMutableArray alloc] init] autorelease];
    switch (_treeType) {
        case TreeTypeDepartment:
        {
            for (Department *item in source) {
                if (item.parentId == 0) {
                    BOOL bCheck = [selectedArray containsObject:item];
                    ZKTreeCell *pcell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                                    depth:0
                                                                  bExpand:NO
                                                             bCheckParent:treeView.bCheckParent
                                                                   parent:nil
                                                                   target:item rootId:item.id];
                    [_cells addObject:pcell];
                    [self addChildCell:pcell depth:0 rootId:pcell.rootId parentId:item.id];
                }
            }
        }
            break;
        case TreeTypeProductCategory:
        {
            for (ProductCategory *item in source) {
                if (item.parentId == 0) {
                    BOOL bCheck = [selectedArray containsObject:item];
                    ZKTreeCell *pcell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                                    depth:0
                                                                  bExpand:NO
                                                             bCheckParent:treeView.bCheckParent
                                                                   parent:nil
                                                                   target:item rootId:item.id];
                    [_cells addObject:pcell];
                    [self addChildCell:pcell depth:0 rootId:pcell.rootId parentId:item.id];
                }
            }
        }
            break;
        default:
            break;
    }
    return _cells;
}

//递归子节点
-(void) addChildCell:(ZKTreeCell *) parentCell depth:(int) depth rootId:(int) rootId parentId:(int) parentId{
    depth++;
    switch (_treeType) {
        case TreeTypeDepartment:
        {
            for (Department *item in departmentArray) {
                if (item.parentId == parentId) {
                    ZKTreeCell *cell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                                   depth:depth
                                                                 bExpand:NO
                                                            bCheckParent:treeView.bCheckParent
                                                                  parent:parentCell
                                                                  target:item rootId:rootId];
                    [parentCell.children addObject:cell];
                    [self addChildCell:cell depth:depth rootId:rootId parentId:item.id];
                }
            }
        }
            break;
        case TreeTypeProductCategory:
        {
            for (ProductCategory *item in departmentArray) {
                if (item.parentId == parentId) {
                    ZKTreeCell *cell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                                   depth:depth
                                                                 bExpand:NO
                                                            bCheckParent:treeView.bCheckParent
                                                                  parent:parentCell
                                                                  target:item rootId:rootId];
                    [parentCell.children addObject:cell];
                    [self addChildCell:cell depth:depth rootId:rootId parentId:item.id];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma -mark -- 初始化数据

#pragma -mark --
-(void)saveDone{
    savebool = YES;
    if ([self.delegate respondsToSelector:@selector(didFnishedCheck:)]) {
        [self.delegate didFnishedCheck:treeView.checkedArray];
    }
    //2.1 版本
    if ([self.delegate respondsToSelector:@selector(didFnished:)]) {
        [self.delegate didFnished:treeView.checkedArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)checkDone{
    
    if ([self.delegate respondsToSelector:@selector(didFnishedCheck:)]) {
        //        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        //        for (SinTreeCheckNode *node in treeView.checkedArray) {
        //            [resultArray addObject:node.department];
        //        }
        [self.delegate didFnishedCheck:treeView.checkedArray];
    }
    //2.1 版本
    if ([self.delegate respondsToSelector:@selector(didFnished:)]) {
        //        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        //        for (SinTreeCheckNode *node in treeView.checkedArray) {
        //            [resultArray addObject:node.department];
        //        }
        [self.delegate didFnished:treeView.checkedArray];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    if (!savebool) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_ui" object:nil]; 
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
