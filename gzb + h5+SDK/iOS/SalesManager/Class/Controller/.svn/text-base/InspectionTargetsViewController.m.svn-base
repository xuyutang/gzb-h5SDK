//
//  InspectionTargetsViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionTargetsViewController.h"
#import "SyncButton.h"

@interface InspectionTargetsViewController ()
{
    SyncButton *_syncBtn;
}
@end

@implementation InspectionTargetsViewController
@synthesize selectedArray,targetArray,delegate;

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
    
//    if (targetArray != nil && targetArray.count >0) {
//        [targetArray removeAllObjects];
//    }
//    targetArray = [[NSMutableArray alloc] initWithCapacity:0];
//    selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    [targetArray addObjectsFromArray:[[LOCALMANAGER getInspectionTargetsWithName:@""] retain]];

    
    
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"inspection_label_target",@"");
    self.view.backgroundColor = WT_WHITE;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *checkAllImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    [checkAllImageView setImage:[UIImage imageNamed:@"ab_icon_save.png"]];
//    [checkAllImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SAVE]];
//    [checkAllImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
//    [checkAllImageView setTextColor:WT_RED];
//    [checkAllImageView setTextAlignment:UITextAlignmentCenter];
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
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, MAINWIDTH-20, 26)];
    
    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_WHITE]];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    //searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toSearch)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];
    
    [topView setItems:buttonsArray];
    [searchBar setInputAccessoryView:topView];
    
    treeView = [[InspectionTreeView alloc] initWithFrame:CGRectMake(10, 44, 300, MAINHEIGHT-44)];
    treeView.bLinkParent = YES;
    treeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:treeView];
    filterArray = [[NSMutableArray alloc] initWithArray:targetArray];
    if (targetArray.count > 0) {
        [self initWithData:filterArray];
    }else{
        [self syncInspectionTargets];
    }
    //[self initWithData];
    
    //浮动同步按钮
    CGRect r = self.view.frame;
    _syncBtn = [[SyncButton alloc] initWithFrame:CGRectMake(r.size.width - 100, r.size.height - 140, 40, 40 )];
    _syncBtn.onClick = ^(SyncButton *sender){
        [self syncInspectionTargets];
    };
    [self.view addSubview:_syncBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSync)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
}

//同步巡检对象
-(void) syncInspectionTargets{
    SHOWHUD;
    AGENT.delegate = self;
    SyncDataParams_Builder *pb = [SyncDataParams builder];
    [pb setSyncTarget:NS_SYNCTARGET(SyncTargetInspectionTarget)];
    if (DONE != [AGENT sendRequestWithType:ActionTypeSyncBaseData param:@[[pb build].dataStream]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:[NSString stringWithFormat:@"上传%@",TITLENAME(FUNC_INSPECTION_DES)]

                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) hasSync{
    [treeView.checkedArray removeAllObjects];
    NSMutableArray *syncArray = [LOCALMANAGER getInspectionTargetsWithChildPage:1 parentId:0];
    [self initWithData:syncArray];
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)initWithData:(NSMutableArray *)targets{
    
    //InspectionTreeNode *root;
    NSInteger cid = 0;
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    for (InspectionTarget *target in targets) {
        BOOL bChecked = NO;
        for (InspectionTarget *checkTarget in selectedArray) {
            if (checkTarget.id == target.id) {
                bChecked = YES;
                break;
            }
        }
        [nodes addObject:[InspectionTreeNode nodeWithProperties:cid++ andText:target.name andChecked:bChecked andTarget:target]];
    }
    if (targets.count >= PAGESIZE) {
        [nodes addObject:[InspectionTreeNode nodeWithProperties:cid++ andText:@"加载更多" andChecked:NO andTarget:[targets lastObject]]];
    }
    InspectionTreeNode *rootNode = [[InspectionTreeNode alloc] init];
    rootNode.cid = -1;
    for (InspectionTreeNode *node in nodes) {
        if (node.target.parentId == 0) {
            [rootNode addChild:node];
        }
//        for (InspectionTreeNode *nodeChild in nodes) {
//            if(nodeChild.target.parentId == node.target.id){
//                [node addChild:nodeChild];
//            }
//        }
    }
    
    // 设置默认展开层数
    [rootNode ergodicNode:^BOOL(InspectionTreeNode *node) {
        if(node.level<1){
            // 展开1层
            node.expanded = YES;
            return YES;
        }
        else{
            return NO;
        }
        return NO;
    }];
    [treeView setRootNode:rootNode];
    
    [treeView reloadTableCell];
    HUDHIDE2;
}

-(void)checkDone{
    if ([self.delegate respondsToSelector:@selector(InspectionTargetsdidFnishedCheck:)]) {
        NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < treeView.checkedArray.count; i++) {
            InspectionTreeNode *node = (InspectionTreeNode*)treeView.checkedArray[i];
            if (node == nil || node.cid == -1) {
                continue;
            }
            if (![node.text isEqualToString:LOAD_MORE] && ![node.text isEqualToString:LOAD_MORE_SUBCATEGORY]) {
                //检测有没有带上父类节点
                InspectionTarget *parentObj = ((InspectionTreeNode *)node.parentId).target;
                if (parentObj != nil && ![self isExistArray:resultArray target:parentObj]) {
                    InspectionTarget_Builder* itb = (InspectionTarget_Builder*)[parentObj toBuilder];
                    [itb setParentId:-1];
                    [resultArray addObject:[itb build]];
                }
                [resultArray addObject:node.target];
            }
        }
        [self.delegate InspectionTargetsdidFnishedCheck:[resultArray copy]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(BOOL) isExistArray:(NSMutableArray *) array target:(InspectionTarget *) target{
    for (InspectionTarget *item in array) {
        if (item.id == target.id) {
            return  YES;
        }
    }
    return  NO;
}

#pragma mark -
#pragma mark search bar delegate

-(BOOL)isExist:(InspectionTarget*) item{
    for (InspectionTarget *target in filterArray) {
        if (item.id == target.id) {
            return YES;
        }
    }
    return NO;
}

-(void)addParent:(InspectionTarget*) item{
    if (item.parentId == 0) {
        return;
    }
    for (InspectionTarget *target in targetArray) {
        if (target.id == item.parentId) {
            if(![self isExist:target])
                [filterArray addObject:target];
            [self addParent:target];
            break;
        }
    }
}

-(void)addChild:(InspectionTarget*) item{
    for (InspectionTarget *target in targetArray) {
        if (target.parentId == item.id) {
            if(![self isExist:target])
                [filterArray addObject:target];
            [self addChild:target];
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
       
    //[tableView reloadData];
}

-(void)toSearch{
    [searchBar resignFirstResponder];
    [treeView.cells removeAllObjects];
    [treeView.checkedArray removeAllObjects];
    [treeView reloadData];
    if ([searchBar.text isEqualToString:@""]) {
        
        //[filterArray removeAllObjects];
        //filterArray = [[NSMutableArray alloc] initWithArray:targetArray];
        filterArray = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getInspectionTargetsWithChildPage:1 parentId:0]];
        [self initWithData:filterArray];
        return;
    }
    
    //[filterArray removeAllObjects];
    treeView.searchText = searchBar.text;
    treeView.rootIndex = 1;
    filterArray = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getInspectionTargetsWithName:searchBar.text Index:1]];
    
//数组中搜索
//    for (int i = 0; i<[targetArray count]; i++) {
//        InspectionTarget* item = [targetArray objectAtIndex:i];
//        NSRange range = [item.name rangeOfString:searchBar.text];
//        
//        if (range.location != NSNotFound){
//            if(![self isExist:item])[filterArray addObject:item];
//            //一次性递归加载
////            [self addParent:item];
////            [self addChild:item];
//        }
//    }
    [self initWithData:filterArray];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self toSearch];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}


-(IBAction)searchDismissKeyBoard
{
    [searchBar resignFirstResponder];
}

-(void)didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse *sr = [SessionResponse parseFromData:message];
    if ([super validateResponse:sr]) {
        return;
    }
    switch (INT_ACTIONTYPE(sr.type)) {
        case ActionTypeSyncBaseData:
        {
            if ([NS_ACTIONCODE(ActionCodeDone) isEqualToString:sr.code]) {
                //成功处理
                SyncData *data = [SyncData parseFromData:sr.data];
                [LOCALMANAGER saveInspectionTargets:data.inspectionTargets];
                self.targetArray = [LOCALMANAGER getInspectionTargetsWithChildPage:1 parentId:0];
                [self initWithData:self.targetArray];
            }
        }
            break;
            
        default:
            break;
    }
    [super showMessage2:sr Title:[NSString stringWithFormat:@"上传%@",TITLENAME(FUNC_INSPECTION_DES)]
     Description:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
