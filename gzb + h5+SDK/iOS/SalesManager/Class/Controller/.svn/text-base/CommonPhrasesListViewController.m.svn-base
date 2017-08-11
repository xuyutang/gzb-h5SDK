//
//  CommonPhrasesViewController.m
//  SalesManager
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "CommonPhrasesListViewController.h"
#import "InputViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"


#define VALIDATE_LENGTH 140; //文字验证长度
@interface CommonPhrasesListViewController ()<SWTableViewCellDelegate>

@end

@implementation CommonPhrasesListViewController

- (void)viewDidLoad {
    
    _dataList = [[LOCALMANAGER getFavoriteLangs] retain];
    [super viewDidLoad];
    [lblFunctionName setText:NSLocalizedString(@"menu_function_common_phrases", nil)];
    
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [addImageView setImage:[UIImage imageNamed:@"ab_icon_add"]];
      UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAdd:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    addImageView.userInteractionEnabled = YES;
    addImageView.contentMode = UIViewContentModeScaleAspectFit;
    [addImageView addGestureRecognizer:tapGesture1];
    [_rightView addSubview:addImageView];
    [tapGesture1 release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshFavoriteList)];
    [tapGesture1 setNumberOfTapsRequired:1];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [_rightView addSubview:saveImageView];
    [tapGesture2 release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightView];
    self.rightButton = rightButton;
    [addImageView release];
    [saveImageView release];
    [rightButton release];
    [_rightView release];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_tableView addGestureRecognizer:longPress];
    [longPress release];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    if (_dataList.count == 0) {
        [self refreshFavoriteList];
    }
}

-(void)clickLeftButton:(id)sender{
    if (_bSelect) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) toAdd:(NSObject *) obj{
    if (_dataList.count >= COMMON_PHRASES_COUNT) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:[NSString stringWithFormat:NSLocalizedString(@"common_phrases_count", nil),COMMON_PHRASES_COUNT]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    InputViewController *cpvc = [[InputViewController alloc] init];
    cpvc.bExpand = YES;
    cpvc.validateLength = VALIDATE_LENGTH;
    cpvc.functionName = NSLocalizedString(@"menu_function_common_phrases_add", nil);
    cpvc.defaultText = NSLocalizedString(@"common_phrases_text_hint", nil);
    cpvc.saveButttonClicked = ^(NSString *content){
        NSLog(@"新增内容:%@",content);
        [self addFavorite:content];
    };
    [self.navigationController pushViewController:cpvc animated:YES];
    // [cpvc release];
}

-(void) toEdit:(FavoriteLang *) favoriteLang{
    InputViewController *cpvc = [[InputViewController alloc] init];
    cpvc.validateLength = VALIDATE_LENGTH;
    cpvc.bExpand = YES;
    cpvc.functionName = NSLocalizedString(@"menu_function_common_phrases_edit", nil);
    cpvc.defaultText = NSLocalizedString(@"common_phrases_text_hint", nil);
    cpvc.editText = favoriteLang.commonLang;
    cpvc.saveButttonClicked = ^(NSString *content) {
        NSLog(@"编辑内容:%@",content);
        [self editFavorite:content];
    };
    [self.navigationController pushViewController:cpvc animated:YES];
    //[cpvc release];
}


#pragma -mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = ((FavoriteLang*)_dataList[indexPath.row]).commonLang;
    CGSize size = [super rebuildSizeWithString:text ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
    return MAX(45.f, size.height + 20);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SWLableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWLableCell"];
    
    
    NSString *text = ((FavoriteLang*)_dataList[indexPath.row]).commonLang;
    CGSize size = [super rebuildSizeWithString:text ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
    //if (cell == nil) {
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    [btns addUtilityButtonWithColor:WT_BLUE title:@"编辑"];
    [btns addUtilityButtonWithColor:WT_RED title:@"删除"];
    
    cell = [[SWLableCell alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:@"LableCell"
                        containingTableView:tableView
                                  rowHeight:MAX(45.f, size.height + 20)
                         leftUtilityButtons:nil
                        rightUtilityButtons:btns];
    [btns release];
    //}
    cell.tag = indexPath.row + 100;
    //cell = [[LableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LableCell"];
    [cell setText:text size:size];
    cell.delegate = self;
    cell.lable.frame = CGRectMake(10, 10, size.width,size.height);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndex = indexPath.row;
    FavoriteLang *favoriteLang = _dataList[indexPath.row];
    if (!_bSelect) {
        //移除点击编辑加入到滑动编辑
        //[self toEdit:favoriteLang];
    }else{
        if (self.selectedItem) {
            self.selectedItem(favoriteLang);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma -mark 数据新增编辑

-(void) refreshFavoriteList{
    SHOWHUD;
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeFavLangList param:nil]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_function_common_phrases", nil)
                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) addFavorite:(NSString *) content{
    SHOWHUD;
    FavoriteLang_Builder *pb = [FavoriteLang builder];
    [pb setId:0];
    [pb setCommonLang:content];
    [pb setUser:USER];
    FavoriteLang *v1 = [pb build];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeFavLangSave param:v1]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_function_common_phrases", nil)
                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) editFavorite:(NSString *) content{
    if (_currentIndex >= 0) {
        SHOWHUD;
        FavoriteLang *favoriteLang = (FavoriteLang*)_dataList[_currentIndex];
        FavoriteLang_Builder *pb = [favoriteLang toBuilder];
        [pb setCommonLang:content];
        favoriteLang = [pb build];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeFavLangUpdate param:favoriteLang]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_function_common_phrases", nil)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
    }
}


- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    _currentIndex = cell.tag - 100;
    NSLog(@"操作 CELL_ID：%d",_currentIndex);
    if (index == 0) {
        FavoriteLang *favoriteLang = _dataList[_currentIndex];
        [self toEdit:favoriteLang];
    }else{
        NSLog(@"删除CELL");
        SHOWHUD;
        FavoriteLang *pb = _dataList[_currentIndex];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeFavLangDelete param:pb]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_function_common_phrases", nil)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }

    }
}


-(IBAction) longPress:(UILongPressGestureRecognizer*) sender{
    CGPoint point = [sender locationInView:_tableView];
    NSIndexPath *index = [[_tableView indexPathForRowAtPoint:point] retain];
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath *sourceIndex = nil;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!index) {
                break;
            }
            
            sourceIndex = [[NSIndexPath indexPathForRow:index.row inSection:index.section] retain];
            
            //拖动动画
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:index ];
            
            // Take a snapshot of the selected row using helper method.
            snapshot = [self customSnapshotFromView:cell];
            
            // Add the snapshot as subview, centered at cell's center...
            __block CGPoint center = cell.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [_tableView addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                
                // Offset for gesture location.
                center.y = point.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;
                
                // Black out.
                cell.backgroundColor = [UIColor whiteColor];
            } completion:nil];
            NSLog(@"移动开始%@",sourceIndex);
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (!index) {
                break;
            }
            //动画
            CGPoint center = snapshot.center;
            center.y = point.y;
            snapshot.center = center;
            NSLog(@"indexpath %d  sourceIndexPath %d",index.row,sourceIndex.row);
            //数据
            if (![index isEqual:sourceIndex]) {
                [_dataList exchangeObjectAtIndex:index.row withObjectAtIndex:sourceIndex.row ];
                [_tableView moveRowAtIndexPath:sourceIndex toIndexPath:index];
                sourceIndex = index;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //动画
            // Clean up.
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:sourceIndex];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            //数据
            [sourceIndex release];
            [index release];
            [_tableView reloadData];
            [LOCALMANAGER saveFavoriteLangs:[PBArray arrayWithArray:_dataList valueType:PBArrayValueTypeObject] SortIds:_dataList];
            NSLog(@"移动结束%@",index);
        }
            break;
        default:
            break;
    }
    
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    if (!IOS7) {
        return nil;
    }
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
-(void) reloadTable{
    [_tableView reloadData];
}


-(void)didReceiveMessage:(id)message{
    SessionResponse *sr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    if ([super validateSessionResponse:sr]) {
        return;
    }
    switch (INT_ACTIONTYPE(sr.type)) {
        case ActionTypeFavLangSave:
        {
            if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                FavoriteLang *v1 = [FavoriteLang parseFromData:sr.data];
                [LOCALMANAGER saveFavoriteLang:v1 Status:CREATE];
                [_dataList insertObject:v1 atIndex:0];
                [_tableView reloadData];
                [self showMessage2:sr Title:NSLocalizedString(@"menu_function_common_phrases", nil) Description:NSLocalizedString(@"common_phrases_save", nil)];
            }
        }
            break;
        case ActionTypeFavLangUpdate:
        {
            if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                FavoriteLang *favoriteLang = [FavoriteLang parseFromData:sr.data];
                [_dataList replaceObjectAtIndex:_currentIndex withObject:favoriteLang];
                [LOCALMANAGER saveFavoriteLang:favoriteLang Status:UPDATE];
                [_tableView reloadData];
                [self showMessage2:sr Title:NSLocalizedString(@"menu_function_common_phrases", nil) Description:NSLocalizedString(@"common_phrases_edit", nil)];
            }
        }
            break;
            
        case ActionTypeFavLangDelete:
        {
            if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                FavoriteLang *pb = _dataList[_currentIndex];
                [LOCALMANAGER saveFavoriteLang:pb Status:DELETE];
                [_dataList removeObjectAtIndex:_currentIndex];
                [_tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView endUpdates];
                //重新更变CELL_.ID
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:.5f];
                [self showMessage2:sr Title:NSLocalizedString(@"menu_function_common_phrases", nil) Description:NSLocalizedString(@"common_phrases_delete", nil)];
            }
        }
            break;
            
        case ActionTypeFavLangList:
        {
            if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                PBArray *datas = sr.datas;
                [_dataList removeAllObjects];
                for (NSData *item in datas) {
                    [_dataList addObject:[FavoriteLang parseFromData:item]];
                }
                [LOCALMANAGER saveFavoriteLangs:[PBArray arrayWithArray:_dataList valueType:PBArrayValueTypeObject] SortIds:_dataList];
                [_tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
    [super showMessage2:sr Title:NSLocalizedString(@"menu_function_common_phrases", nil) Description:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
