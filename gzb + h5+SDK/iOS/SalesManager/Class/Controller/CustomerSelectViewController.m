//
//  CustomerSelectViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/16.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "CustomerSelectViewController.h"
#import "UIView+Util.h"
#import "CustomerListCell.h"
#import "FavCustomerViewController.h"
#import "Constant.h"

@implementation CustomerSelectViewController
{
    UIBarButtonItem *_addCustButton;
    FavCustomerViewController *favVC;
    Customer *_currentCustomer;
    int     _currentIndex;
}
-(void)viewDidLoad{
    self.bHideFuncBtn = YES;
    self.user = USER;
    [super setBNeedBack:YES];
    
    [super viewDidLoad];
    [self.lblFunctionName setTextAlignment:NSTextAlignmentLeft];
    [super.leftView setHidden:NO];
    [super.leftImageView setHidden:NO];
    //高度填充屏幕
    CGRect r = self.tableView.frame;
    r.size.height = MAINHEIGHT - r.origin.y;
    self.tableView.frame = r;
    
    [self.lblFunctionName setText:NSLocalizedString(@"select_customer", nil)];
    
    UISegmentedControl *pageCtrol = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"task_status_all", nil),NSLocalizedString(@"my_fav", nil)]];
    pageCtrol.frame = CGRectMake(120, (self.leftView.frame.size.height - 28) / 2, 120, 28);
    pageCtrol.tintColor = WT_RED;
    pageCtrol.selectedSegmentIndex = 0;
    [pageCtrol addTarget:self action:@selector(btnTouchIndex:) forControlEvents:UIControlEventValueChanged];
    self.leftView.frame = CGRectMake(0, 0, MAINWIDTH - 90, self.leftView.frame.size.height);
    [self.leftView addSubview:pageCtrol];
    _addCustButton = [[UIBarButtonItem alloc] initWithCustomView:self.navigationItem.rightBarButtonItem.customView];
    
}


-(void) initRightButton{
    UIImageView *syncFav = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [syncFav setImage:[UIImage imageNamed:@"ab_icon_save"]];
    syncFav.userInteractionEnabled = YES;
    UITapGestureRecognizer *syncFavAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syncCostomer)];
    [syncFavAction setNumberOfTapsRequired:1];
    syncFav.contentMode = UIViewContentModeScaleAspectFit;
    [syncFav addGestureRecognizer:syncFavAction];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:syncFav];
    self.rightButton = rightBtn;
    [rightBtn release];
}


-(void) syncCostomer{
    if (favVC != nil) {
        [favVC deleteCustomerFav];
    }
}


-(void) btnTouchIndex:(UISegmentedControl *) sender{
    if (sender.selectedSegmentIndex == 1) {
        if (_favView == nil) {
            favVC = [[FavCustomerViewController alloc] init];
            favVC.delegate = self;
            [self addChildViewController:favVC];
            //0 标签筛选
            _favView = self.childViewControllers[1].view;
            _favView.frame = CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT);
        }
        [UIView addSubViewToSuperView:self.view subView:_favView];
        [self initRightButton];
    }else{
        [self initRightAddButton];
        [UIView removeViewFormSubViews:-1 views:@[_favView]];
        [self.tableView reloadData];
    }
}

-(void)clickLeftButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark -- UITableViewDeleaget
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100.f;
    }
    return 50.f;
}

//拓展收藏功能
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerListCell *cell = (CustomerListCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        Customer *cust = (Customer*)self.customerArray[indexPath.row];
        cell.tag = indexPath.row;
        cell.object = cust;
        [cell setFavStatus:YES bfav:cust.isFav].favTouchAction = ^(CustomerListCell *sender){
            // 与服务器通信 然后缓存本地
            _currentCustomer = sender.object;
            _currentIndex = sender.tag;
            [self favCustomer:_currentCustomer];
        };
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        Customer *cust = self.customerArray[indexPath.row];
        NSLog(@"选择客户:%@",cust.name);
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
            [_delegate customerSearch:self didSelectWithObject:cust];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)didFinishedInput:(Customer_Builder *) custBuilder{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(newCustomerDidFinished:newCustomer:)]) {
        [self.delegate newCustomerDidFinished:self newCustomer:custBuilder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//收藏界面选择
-(void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
        [self.delegate customerSearch:controller didSelectWithObject:aObject];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)favCustomerDelegate:(UIViewController *)controller didSelectWithObject:(id)aObject{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
        [self.delegate customerSearch:self didSelectWithObject:aObject];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma -mark -- 自定义私有操作

//通知服务器收藏
-(void) favCustomer:(Customer *) cust{
    NSLog(@"%@",cust.name);
    SHOWHUD;
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerFavSave param:@[cust.dataStream]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

//收藏 取消收藏
-(void) favCustomer:(Customer *) cust bFav:(BOOL) bFav{
    if (![LOCALMANAGER hasFavCustomer:cust]) {
        [LOCALMANAGER saveCustomer:cust];
    }
    [LOCALMANAGER favCustomer:cust Fav:bFav];
}

#pragma -mark -- ResponseDelegate
-(void)didReceiveMessage:(id)message{
    [super didReceiveMessage:message];
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeCustomerFavSave:
        {
            if ([NS_ACTIONCODE(ActionCodeDone) isEqual:cr.code]) {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                  description:NSLocalizedString(@"favorate_commit_done", @"")
                                         type:MessageBarMessageTypeSuccess
                                  forDuration:SUCCESS_MSG_DURATION];
                Customer_Builder *tmpCust = [_currentCustomer toBuilder];
                [tmpCust setIsFav:1];
                _currentCustomer = [tmpCust build];
                [self favCustomer:_currentCustomer bFav:YES];
                [self.customerArray replaceObjectAtIndex:_currentIndex withObject:_currentCustomer];
                [self.tableView reloadData];
                //通知收藏UI 更新
                [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)dealloc{
    [_addCustButton release];
    if (favVC != nil) {
        [favVC release];
    }
    [super dealloc];
}

@end
