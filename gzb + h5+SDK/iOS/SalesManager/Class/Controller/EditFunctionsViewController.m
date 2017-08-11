//
//  EditFunctionsViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-26.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "EditFunctionsViewController.h"
#import "MyInfoItemCell.h"
#import "Constant.h"

@interface EditFunctionsViewController (){
    NSMutableArray *functions;
    NSMutableArray *favFunctions;
    
    Function *removeFunction;
}

@end

@implementation EditFunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    functions = [[[NSMutableArray alloc] initWithArray:[LOCALMANAGER getFunctions]] retain];
    [self mergeContactForFunctions];
    
    favFunctions = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getFavFunctions]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_tableView addGestureRecognizer:longPress];
    
    lblFunctionName.text = @"菜单选择(长按拖动排序)";
}


#pragma -mark - 私有方法
/**
 *合并通讯录
 */
-(void) mergeContactForFunctions{
    int removeIndex = -1;
    //寻找位置
    int companyIndex = [self getFunctionsIndexWithDES:FUNC_COMPANY_CONTACT_DES];
    int custIndex = [self getFunctionsIndexWithDES:FUNC_CUSTOMER_CONTACT_DES];
    if (companyIndex >= 0 && custIndex >= 0) {
        removeIndex = MAX(companyIndex, custIndex);
        removeFunction = [functions[removeIndex] retain];
        [functions removeObjectAtIndex:removeIndex];
    }
}

/**
 *找到指定功能所在数组总的位置
 */
-(int) getFunctionsIndexWithDES:(NSString *) des{
    int i = 0;
    for (Function *item in functions) {
        if ([item.value isEqualToString:des]) {
            return i;
        }
        i++;
    }
    return -1;
}


-(void)clickLeftButton:(id)sender{
    //[super clickLeftButton:sender];
    if (favFunctions.count == 0 && functions.count != 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"edit_function", @"")
                          description:NSLocalizedString(@"msg_no_function", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (removeFunction != nil) {
        [functions addObject:removeFunction];
    }
    PBAppendableArray *functionArray = [[PBAppendableArray alloc] initWithArray:functions valueType:PBArrayValueTypeObject];
    [LOCALMANAGER saveFunctions:functionArray];
    [functionArray release];
    
    PBAppendableArray *favFunctionArray = [[PBAppendableArray alloc] initWithArray:favFunctions valueType:PBArrayValueTypeObject];
    [LOCALMANAGER favFunctions:favFunctionArray];
    [favFunctionArray release];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return functions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Function *function = [functions objectAtIndex:indexPath.row];
    MyInfoItemCell *itemCell=(MyInfoItemCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoItemCell"];
    if(itemCell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyInfoItemCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[MyInfoItemCell class]])
                itemCell=(MyInfoItemCell *)oneObject;
        }
    }
    
    [self _buildCell:(NSIndexPath *)indexPath MyInfoItemCell:itemCell];
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self isFavFuction:function]) {
        itemCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        itemCell.accessoryType = UITableViewCellAccessoryNone;
    }
    itemCell.count.hidden = YES;
    
    return itemCell;
}

-(BOOL)isFavFuction:(Function *)function{
    for (Function *item in favFunctions) {
        if (function.id == item.id) {
            return YES;
        }
    }
    return NO;
}

-(void)removeFunction:(Function *)function{
    for (Function *item in favFunctions) {
        if (function.id == item.id) {
            [favFunctions removeObject:item];
            return;
        }
    }
}

-(void)addFunction:(Function *)function{
    [favFunctions addObject:function];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = [indexPath retain];
                
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor whiteColor];
                } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            //NSLog(@"indexpath %d  sourceIndexPath %d",indexPath.row,sourceIndexPath.row);
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [functions exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [_tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = [indexPath retain];
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:sourceIndexPath];
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
            [sourceIndexPath release];
            sourceIndexPath = nil;
            break;
        }
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

-(BOOL) validateExistFunc:(NSString *) funcDes{
    if ([funcDes isEqualToString:FUNC_VIDEO_DES] ||
        [funcDes isEqualToString:FUNC_ATTENDANCE_DES]||
        [funcDes isEqualToString:FUNC_WORKLOG_DES]||
        [funcDes isEqualToString:FUNC_PATROL_DES]||
        [funcDes isEqualToString:FUNC_COMPETITION_DES]||
        [funcDes isEqualToString:FUNC_SELL_STOCK_DES]||
        [funcDes isEqualToString:FUNC_SELL_ORDER_DES]||
        [funcDes isEqualToString:FUNC_SELL_TODAY_DES]||
        [funcDes isEqualToString:FUNC_CUSTOMER_CONTACT_DES]||
        [funcDes isEqualToString:FUNC_COMPANY_CONTACT_DES]||
        [funcDes isEqualToString:FUNC_BIZOPP_DES]||
        [funcDes isEqualToString:FUNC_RESEARSH_DES]||
        [funcDes isEqualToString:FUNC_APPROVE_DES]||
        [funcDes isEqualToString:FUNC_GIFT_DES]||
        [funcDes isEqualToString:FUNC_SYNC_DES]||
        [funcDes isEqualToString:FUNC_MESSAGE_DES]||
        [funcDes isEqualToString:FUNC_FAVORATE_DES]||
        [funcDes isEqualToString:FUNC_PATROL_TASK_DES]||
        [funcDes isEqualToString:FUNC_SPACE_DES]||
        [funcDes isEqualToString:FUNC_ALARM_DES]||
        [funcDes isEqualToString:FUNC_TASK_DES]||
        [funcDes isEqualToString:FUNC_INSPECTION_DES] ||
        [funcDes isEqualToString:FUNC_PAPER_POST_DES] ||
        [funcDes isEqualToString:FUNC_HOLIDAY_DES]) {
        return YES;
    }
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Function *function = [functions objectAtIndex:indexPath.row];
    //功能更新检测
    if (![self validateExistFunc:function.value]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:NSLocalizedString(@"func_no_sync_hint", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    if (cellView.accessoryType == UITableViewCellAccessoryNone) {
        cellView.accessoryType=UITableViewCellAccessoryCheckmark;
        [self addFunction:function];
    }
    else {
        cellView.accessoryType = UITableViewCellAccessoryNone;
        [self removeFunction:function];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //    需要的移动行
    NSInteger fromRow = [sourceIndexPath row];
    //    获取移动某处的位置
    NSInteger toRow = [destinationIndexPath row];
    //    从数组中读取需要移动行的数据
    id object = [functions objectAtIndex:fromRow];
    //    在数组中移动需要移动的行的数据
    [functions removeObjectAtIndex:fromRow];
    //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
    [functions insertObject:object atIndex:toRow];
    
}

- (void) _buildCell:(NSIndexPath *)indexPath MyInfoItemCell:(MyInfoItemCell*) cell{
    cell.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    [cell.icon setTextColor:[UIColor grayColor]];
    [cell.count setTextColor:[UIColor grayColor]];
    Function* f = [functions objectAtIndex:indexPath.row];
    cell.tag = f.id;
    
    if ([f.value isEqual:FUNC_PATROL_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PATROL]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_WORKLOG_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_WORKLOG]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_SELL_ORDER_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER]];
        [cell.title setText:f.name];
    }
    if ([f.value isEqual:FUNC_SELL_STOCK_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_SELL_TODAY_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_RESEARSH_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_COMPETITION_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_COMPETITION]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_ATTENDANCE_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_TASK_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_BIZOPP_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_APPROVE_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_APPROVE]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_GIFT_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
        [cell.title setText:f.name];
    }else if ([f.value isEqual:FUNC_INSPECTION_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_INPECTION]];
        [cell.title setText:f.name];
        
    }else if ([f.value isEqual:FUNC_SYNC_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_DATA_SYNC]];
        [cell.title setText:f.name];
    }else if ([f.value isEqual:FUNC_MESSAGE_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_MESSAGE]];
        [cell.title setText:f.name];
    }/*else if ([f.value isEqual:FUNC_FAVORATE_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_FAV]];
        [cell.title setText:f.name];
    }*/else if ([f.value isEqual:FUNC_PATROL_TASK_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
        [cell.title setText:f.name];
    }else if ([f.value isEqual:FUNC_SPACE_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_COMPANY_SPACE]];
        [cell.title setText:f.name];
    }else if ([f.value isEqual:FUNC_ALARM_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_ALARM]];
        [cell.title setText:f.name];
    }else if ([f.value isEqual:FUNC_VIDEO_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_VIDEO]];
        [cell.title setText:f.name];
    } else if ([f.value isEqual:FUNC_PAPER_POST_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD]];
        [cell.title setText:f.name];
    
    } else if ([f.value isEqual:FUNC_HOLIDAY_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:FAPlane]];
        [cell.title setText:f.name];

        }
    
    
//企业通讯录 客户通讯录 ICON_CUSTOMER_CONTACT
    else if ([f.value isEqual:FUNC_CUSTOMER_CONTACT_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PHONE]];
        [cell.title setText:NSLocalizedString(@"contacts", nil)];
    }else if ([f.value isEqual:FUNC_COMPANY_CONTACT_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PHONE]];
        [cell.title setText:NSLocalizedString(@"contacts", nil)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [functions release];
    [_tableView release];
    [super dealloc];
}
@end
