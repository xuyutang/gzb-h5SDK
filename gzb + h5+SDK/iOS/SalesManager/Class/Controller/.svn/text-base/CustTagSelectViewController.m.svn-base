//
//  DepartmentViewController.m
//  SalesManager
//
//  Created by Administrator on 16-3-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "CustTagSelectViewController.h"

@implementation TagObj


@end

@interface CustTagSelectViewController ()
{
    UIButton *buttonView;
}
@end

@implementation CustTagSelectViewController
@synthesize delegate,tagArray,selectedArray,tagValueArray,dataArray;

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
    dataArray = [[NSMutableArray alloc] init];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"hint_customer_tag_select",@"");
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *checkAllImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    checkAllImageView.image = [UIImage imageNamed:@"ab_icon_save.png"];
    checkAllImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDone)];
    [tapGesture1 setNumberOfTapsRequired:1];
    checkAllImageView.contentMode = UIViewContentModeScaleAspectFit;
    [checkAllImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:checkAllImageView];
    [checkAllImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    
    //树控件参数定义
    treeView = [[ZKTreeView alloc] init];
    treeView.view.frame = self.view.frame;
    dataArray = [[LOCALMANAGER getCustomerTags] retain];
    treeView.cells = [self createTreeSource:dataArray];
    treeView.bSingle = _bSingle;
    if (!_bSingle) {
        treeView.selectCount = [LOCALMANAGER getKvoByKey:KEY_CUSTOMERTAG_COUNT].intValue;
        treeView.maxSelectCount = [LOCALMANAGER getKvoByKey:KEY_CUSTOMERTAG_MAX_COUNT].intValue;
    }
    [treeView expandNodeWithDepth:1];
    [self addChildViewController:treeView];
    [self.view addSubview:self.childViewControllers.firstObject.view];
    
}

-(void)setBView:(BOOL)bView{
    _bView = bView;
    if (_bView) {
        [self initBottomButton];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (_bView) {
        buttonView.frame = CGRectMake(0,treeView.view.frame.size.height, self.view.frame.size.width, 44);
    }
    [super viewWillAppear:animated];
}

-(void) cancelCheckedAllCell{
    [treeView cancelAllCheckedCell];
}

-(void) initBottomButton{
    treeView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
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
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//构造CELL 数据源
-(NSMutableArray *) createTreeSource:(NSMutableArray *) source{
    NSMutableArray *_cells = [[[NSMutableArray alloc] init] autorelease];
    for (CustomerTag *item in source) {
        ZKTreeCell *pcell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                        depth:0
                                                      bExpand:NO
                                                 bCheckParent:treeView.bCheckParent
                                                       parent:nil
                                                       target:item rootId:item.id];
        [_cells addObject:pcell];
        NSMutableArray *tagValues = [LOCALMANAGER getCustomerTagValuesWithTagId:item.id];
        [self addChildCell:pcell depth:0 rootId:pcell.rootId parentId:item.id array:tagValues];
    }
    return _cells;
}

//递归子节点
-(void) addChildCell:(ZKTreeCell *) parentCell depth:(int) depth rootId:(int) rootId parentId:(int) parentId array:(NSMutableArray *) array{
    depth++;
    for (CustomerTagValue *item in array) {
        ZKTreeCell *cell = [[ZKTreeCell alloc] initWithTitle:item.name
                                                       depth:depth
                                                     bExpand:NO
                                                bCheckParent:treeView.bCheckParent
                                                      parent:parentCell
                                                      target:item rootId:rootId];
        [parentCell.children addObject:cell];
        NSMutableArray *values = [LOCALMANAGER getCustomerTagValuesWithPartentId:item.id];
        [self addChildCell:cell depth:depth rootId:rootId parentId:item.id array:values];
    }
}

-(BOOL) checkTagValStatus:(CustomerTagValue *) tagVal array:(NSMutableArray *) array{
    for (CustomerTagValue *item in array) {
        if (tagVal.id == item.id) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) checkTagStatus:(CustomerTag *) obj{
    for (id item in selectedArray) {
        if ([item isKindOfClass:[CustomerTag class]]) {
            CustomerTag *tmp = item;
            if (tmp.id == obj.id) {
                return YES;
            }
        }
    }
    return  NO;
}

-(void)checkDone{

    if ([self.delegate respondsToSelector:@selector(custTagSelecDidFnishedCheck:)]) {
        [self.delegate custTagSelecDidFnishedCheck:treeView.checkedArray];
    }
    
    //2.1 版本
    if ([self.delegate respondsToSelector:@selector(custTagSelectDidFnished:)]) {
        [self.delegate custTagSelectDidFnished:treeView.checkedArray];
    }
    if ([self.delegate respondsToSelector:@selector(custTagTreeDidFnishedCheck:)]) {
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        for (id item in treeView.checkedArray) {
            if ([item isKindOfClass:[CustomerTag class]]) {
                [tags addObject:item];
            }else{
                CustomerTagValue *tmpVal = (CustomerTagValue*)item;
                CustomerTag *tmpTag = [LOCALMANAGER getCustomerTagWithTagValueId:tmpVal.id];
                tmpTag = [[[tmpTag toBuilder] setTagValuesArray:@[tmpVal]] build];
                [tags addObject:tmpTag];
            }
        }
        [self.delegate custTagTreeDidFnishedCheck:tags];
    }
    if (!_bView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[self.navigationController dismissModalViewControllerAnimated:YES];
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
