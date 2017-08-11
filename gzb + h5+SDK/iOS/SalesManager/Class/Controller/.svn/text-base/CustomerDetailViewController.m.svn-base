//
//  CustomerDetailViewController.m
//  SalesManager
//
//  Created by 章力 on 15/6/1.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "Constant.h"
#import "CustomerInfoCell.h"
#import "MyInfoItemCell.h"
#import "Product.h"
#import "GZBWebView.h"
#import "CustWebViewController.h"

@interface CustomerDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIActionSheetDelegate,PullTableViewDelegate>{
    NSMutableArray *functionItems;
    int secondSectionRow;
    CountData* countData;
    
    GZBWebView* customerMap;
    UIView *rightView;
    int _custId;
    NSString *_custName;
}

@end

@implementation CustomerDetailViewController
@synthesize tableview,customer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
        
    tableview.delegate = self;
    tableview.dataSource = self;
    AGENT.delegate = self;
    [lblFunctionName setText:@"客户详情"];
    tableview.pullDelegate = self;
    tableview.pullBackgroundColor = WT_YELLOW;
    tableview.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    
    UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [mapImageView setImage:[UIImage imageNamed:@"ab_icon_location"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadBaidu)];
    [tapGesture1 setNumberOfTapsRequired:1];
    mapImageView.userInteractionEnabled = YES;
    mapImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mapImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:mapImageView];
    [mapImageView release];
    [tapGesture1 release];
    
    [rightView addSubview:mapImageView];
    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [refreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    [tapGesture1 setNumberOfTapsRequired:1];
    refreshImageView.userInteractionEnabled = YES;
    [refreshImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:refreshImageView];
    [refreshImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    float cellHeight = 174.0f;
    
    customerMap = [[GZBWebView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, cellHeight)];
        
    NSString *urlParam = [NSString stringWithFormat:CUSTOEMR_MAP_URL,customer.id,USER.userName,USER.password];
    NSString *url = [NSString stringWithFormat:@"https://%@/%@/%@",SERVER_URL,CONTEXT_PATH,urlParam];
        NSLog(@"customer map url:%@",url);
    customerMap.delegate = self;
    [customerMap loadUrl:url];
      
    [self initData];
}

-(void)initData{
    tableview.pullLastRefreshDate = [NSDate date];
    tableview.pullTableIsRefreshing = YES;
    
    [self _loadFunctions];
    [tableview reloadData];
    
    [self _getCustomerCountData];
}

-(void)refresh {
    [self _loadFunctions];
    [tableview reloadData];
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");

    CountParams_Builder* bs = [CountParams builder];
    [bs setCustomersArray:[[NSArray alloc] initWithObjects:customer, nil]];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCountDataGet param:[bs build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(initData) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(initData) withObject:nil afterDelay:RELOAD_DELAY];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }if (section == 1) {
        return 1;
    }
    return secondSectionRow;
}

- (void) _loadFunctions {
    if (functionItems.count > 0){
        [functionItems removeAllObjects];
        [functionItems release];
        functionItems = nil;
    }
    functionItems = [[NSMutableArray alloc] initWithCapacity:11];
    NSMutableArray* userFunc = [LOCALMANAGER getFunctions];
    
    secondSectionRow = 0;
    for (Function* f in userFunc){
        /*if ([f.value isEqual: FUNC_ATTENDANCE_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
        if ([f.value isEqual: FUNC_PATROL_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        /*
        if ([f.value isEqual: FUNC_TASK_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
        /*
        if ([f.value isEqual: FUNC_INSPECTION_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
        /*
        if ([f.value isEqual: FUNC_WORKLOG_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
        if ([f.value isEqual: FUNC_RESEARSH_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_BIZOPP_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_COMPETITION_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }/*
        if ([f.value isEqual:FUNC_APPROVE_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
        if ([f.value isEqual:FUNC_GIFT_DES]){
            /*Function_Builder* f = [Function builder];
            Function_Builder* f = [Function builder];
            [f setId:FUNC_GIFT_PURCHASE_LIST];
            [f setName:FUNC_GIFT_PURCHASE_LIST_DES];
            [f setValue:FUNC_GIFT_PURCHASE_LIST_DES];
            [f setVersion:f.version];
            [f set:[f build]];
            ++secondSectionRow;
            [functionItems addObject:[f build]];
            
            Function_Builder* f1 = [Function builder];
            Function_Builder* f1 = [Function builder];
            [f1 setId:FUNC_GIFT_DELIVERY_LIST];
            [f1 setName:FUNC_GIFT_DELIVERY_LIST_DES];
            [f1 setValue:FUNC_GIFT_DELIVERY_LIST_DES];
            [f1 setVersion:f1.version];
            [f1 set:[f1 build]];
            ++secondSectionRow;
            [functionItems addObject:[f1 build]];*/
            
            Function_Builder* f2 = [Function builder];
            [f2 setId:FUNC_GIFT_DISTRIBUTE_LIST];
            [f2 setName:FUNC_GIFT_DISTRIBUTE_LIST_DES];
            [f2 setValue:FUNC_GIFT_DISTRIBUTE_LIST_DES];
            ++secondSectionRow;
            [functionItems addObject:[f2 build]];
            /*
            Function_Builder* f3 = [Function builder];
            Function_Builder* f3 = [Function builder];
            [f3 setId:FUNC_GIFT_STOCK_LIST];
            [f3 setName:FUNC_GIFT_STOCK_LIST_DES];
            [f3 setValue:FUNC_GIFT_STOCK_LIST_DES];
            [f3 setVersion:f3.version];
            [f3 set:[f3 build]];
            ++secondSectionRow;
            [functionItems addObject:[f3 build]];*/
        }
        /*
        if ([f.value isEqual:FUNC_PATROL_TASK_DES]) {
            ++secondSectionRow;
            [functionItems addObject:f];
        }*/
    }
    
    return;
}


- (void) _getCustomerCountData{
    CountParams_Builder* bs = [CountParams builder];
    [bs setCustomersArray:[[NSArray alloc] initWithObjects:customer, nil]];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCountDataGet param:[bs build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeCountDataGet) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        HUDHIDE2
        countData = [[CountData parseFromData:cr.data] retain];
        if ([super validateData:countData]) {
            [tableview reloadData];
        }
        
    }
    tableview.pullTableIsRefreshing = NO;
    tableview.pullTableIsLoadingMore = NO;
}

- (void) didFailWithError:(NSError *)error{
    tableview.pullTableIsRefreshing = NO;
    tableview.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    tableview.pullTableIsRefreshing = NO;
    tableview.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0 && indexPath.row == 0) {
       return 174.f;
        
    }
    
    if (indexPath.section== 1 && indexPath.row == 0) {
        return 108.f;
    }
    return 44.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1.0f;
    }
    if (section == 1) {
        return 1.0f;
    }
    return 1.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NearPersonViewController *vctrl = [[NearPersonViewController alloc] init];
    //[self.parentController.navigationController pushViewController:vctrl animated:YES];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            ;
        }

    }
    if (indexPath.section == 2) {

            Function* f = [functionItems objectAtIndex:indexPath.row];
            
            /*if ([f.value isEqual: FUNC_ATTENDANCE_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_ATTENDANCE_LIST Object:customer Delegate:nil NeedBack:YES];
            }*/
            if ([f.value isEqual: FUNC_PATROL_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_PATROL_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual: FUNC_TASK_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_ATTENDANCE Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual: FUNC_INSPECTION_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_INSPECTION_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            /*if ([f.value isEqual: FUNC_WORKLOG_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_WORKLOG_LIST Object:customer Delegate:nil NeedBack:YES];
            }*/
            if ([f.value isEqual: FUNC_RESEARSH_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_RESEARSH_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual: FUNC_BIZOPP_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_BIZOPP_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual: FUNC_COMPETITION_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_COMPETITION_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_SELL_TODAY_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_SELL_STOCK_LIST Object:customer Delegate:nil NeedBack:YES];
            }
            if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_ATTENDANCE Object:customer Delegate:nil  NeedBack:YES];
            }
            /*if ([f.value isEqual:FUNC_APPROVE_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_APPROVE_LIST Object:customer Delegate:nil NeedBack:YES];
            }*/
        if ([f.value isEqual:FUNC_GIFT_DISTRIBUTE_LIST_DES]){
            [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_GIFT_DISTRIBUTE_LIST Object:customer Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_DELIVERY_LIST_DES]){
            [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_GIFT_DELIVERY_LIST Object:customer Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_PURCHASE_LIST_DES]){
            [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_GIFT_PURCHASE_LIST Object:customer Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_STOCK_LIST_DES]){
            [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_GIFT_STOCK_LIST Object:customer Delegate:nil NeedBack:YES];
        }
            if ([f.value isEqual:FUNC_PATROL_TASK_DES]){
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_TASK Object:customer Delegate:nil NeedBack:YES];
            }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        float cellHeight = 174.0f;
        
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, cellHeight)];
        
        [cell.contentView addSubview:customerMap];
            /*UIButton* bMark = [UIButton buttonWithType:UIButtonTypeCustom];
            [bMark setFrame:CGRectMake(CELL_CONTENT_WIDTH - 50, 5.0f,50.0f, 50.0f)];
            bMark.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
            [bMark setTitle:[NSString fontAwesomeIconStringForEnum:ICON_LOCATION_ARROW] forState:UIControlStateNormal] ;
            [bMark setTitleColor:WT_RED forState:UIControlStateNormal];
            [bMark addTarget:self action:@selector(loadBaidu) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:customerMap];
            [cell.contentView addSubview:bMark];*/
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        CustomerInfoCell *topCell=(CustomerInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerInfoCell"];
        if(topCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomerInfoCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[CustomerInfoCell class]])
                    topCell=(CustomerInfoCell *)oneObject;
            }
        }
        [topCell setBackgroundColor:WT_BLUE];
        
        [topCell.name setText:customer.name];
        topCell.name.textColor = [UIColor whiteColor];
        _custId = customer.id;
        _custName = customer.name;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadCustomer)];
        [tapGesture setNumberOfTapsRequired:1];
        topCell.name.userInteractionEnabled = YES;
        topCell.name.contentMode = UIViewContentModeScaleAspectFit;
        [topCell.name addGestureRecognizer:tapGesture];

        if (customer.contacts.count >0) {
            Contact *contact = [customer.contacts objectAtIndex:0];
            if (contact.phone.count >0) {
                NSString* constactName = contact.name;
                NSString *phone = [contact.phone objectAtIndex:0];
                if (![constactName isEqualToString:@""] || ![phone isEqualToString:@""]) {
                    topCell.contact.text = [NSString stringWithFormat:@"%@ %@",constactName,phone];
                }
                if (!phone.isEmpty) {
                    topCell.btPhone.hidden = NO;
                    topCell.btPhone.tag = indexPath.row;
                    [topCell.btPhone addTarget:self action:@selector(selectCall) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    topCell.btPhone.hidden = YES;
                    topCell.address.frame = topCell.btPhone.frame;
                }
            }
        }
        topCell.contact.textColor = [UIColor whiteColor];
        [topCell.address setText:customer.location.address];
        topCell.address.textAlignment = 1;
        topCell.address.textColor = [UIColor whiteColor];
        cell = topCell;
    }
    if (indexPath.section == 2) {
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
        cell = itemCell;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 调往客户的h5页面
-(void) loadCustomer{
    CustWebViewController *webView = [[CustWebViewController alloc]init];
    webView.custId = *(&(_custId));
    webView.custName = _custName;
    [self.navigationController pushViewController:webView animated:YES];

}

-(void)loadBaidu{
    if (APPDELEGATE.myLocation == nil) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"gps_unavilable", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (customer.location.latitude <= 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"gps_customer_unavilable", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        NSString *urlString = [[NSString stringWithFormat:BAIDU_NAV,APPDELEGATE.myLocation.latitude, APPDELEGATE.myLocation.longitude,customer.location.latitude,customer.location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        
    }else{
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"msg_cannot_find_baidu", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
}

-(void)selectCall{
    if (customer.contacts.count >0) {
        Contact *contact = [customer.contacts objectAtIndex:0];
        if (contact.phone.count >0) {
            NSString *phone = [contact.phone objectAtIndex:0];
            if (!phone.isEmpty) {
                UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                             initWithTitle:NSLocalizedString(@"msg_customer_call", @"")
                                             delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"no", @"")
                                             destructiveButtonTitle:phone
                                             otherButtonTitles:nil,nil];
                
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [actionSheet showInView:self.view];
            }
        }
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *phone = @"";
    if (customer.contacts.count >0) {
        Contact *contact = [customer.contacts objectAtIndex:0];
        if (contact.phone.count >0) {
            phone = [contact.phone objectAtIndex:0];
        }
    }
    switch (buttonIndex) {
        case 0:{
            NSString* tel = [NSString stringWithFormat:@"tel://%@",phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
            break;
        default:
            break;
    }
}

- (void) _buildCell:(NSIndexPath *)indexPath MyInfoItemCell:(MyInfoItemCell*) cell{
    cell.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    [cell.icon setTextColor:[UIColor grayColor]];
    [cell.count setTextColor:[UIColor grayColor]];
    

            Function* f = [functionItems objectAtIndex:indexPath.row];
            cell.tag = f.id;
            if ([f.value isEqual:FUNC_PATROL_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PATROL]];
                [cell.title setText:TITLENAME(FUNC_PATROL_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.patrolCount] ];
            }
            if ([f.value isEqual:FUNC_WORKLOG_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_WORKLOG]];
                [cell.title setText:TITLENAME(FUNC_WORKLOG_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.workLogCount]];
            }
            if ([f.value isEqual:FUNC_SELL_ORDER_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER]];
                [cell.title setText:TITLENAME(FUNC_SELL_ORDER_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.orderGoodsCount]];
            }
            if ([f.value isEqual:FUNC_SELL_STOCK_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK]];
                [cell.title setText:TITLENAME(FUNC_SELL_STOCK_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.stockCount]];
            }
            if ([f.value isEqual:FUNC_SELL_TODAY_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY]];
                [cell.title setText:TITLENAME(FUNC_SELL_TODAY_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.saleGoodsCount]];
            }
            if ([f.value isEqual:FUNC_RESEARSH_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH]];
               [cell.title setText:TITLENAME(FUNC_RESEARSH_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.marketResearchCount]];
            }
            if ([f.value isEqual:FUNC_COMPETITION_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_COMPETITION]];
                [cell.title setText:TITLENAME(FUNC_COMPETITION_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.competitionGoodsCount]];
            }
            if ([f.value isEqual:FUNC_ATTENDANCE_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE]];
                [cell.title setText:TITLENAME(FUNC_ATTENDANCE_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.attendanceCount]];
            }
            if ([f.value isEqual:FUNC_TASK_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
                [cell.title setText:TITLENAME(FUNC_PATROL_TASK_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.taskPatrolCount]];
            }
            if ([f.value isEqual:FUNC_BIZOPP_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY]];
                 [cell.title setText:TITLENAME(FUNC_BIZOPP_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.businessOpportunityCount]];
            }
            if ([f.value isEqual:FUNC_APPROVE_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_APPROVE]];
                [cell.title setText:TITLENAME(FUNC_APPROVE_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.applyItemCount]];
            }
    if ([f.value isEqual:FUNC_GIFT_DELIVERY_LIST_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
        [cell.title setText:TITLENAME(FUNC_PATROL_TASK_DES)];
        [cell.title setText:NSLocalizedString(@"bar_gift_delivery", "")];
        [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftDeliveryCount.intValue]]];
    }
    if ([f.value isEqual:FUNC_GIFT_DISTRIBUTE_LIST_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
        [cell.title setText:NSLocalizedString(@"bar_gift_distribute", "")];
        [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftDistributeCount.intValue]]];
    }
    if ([f.value isEqual:FUNC_GIFT_PURCHASE_LIST_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
        [cell.title setText:NSLocalizedString(@"bar_gift_purchase", "")];
        [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d", (int)countData.giftPurchaseCount.intValue]]];
    }
    if ([f.value isEqual:FUNC_GIFT_STOCK_LIST_DES]) {
        [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
        [cell.title setText:NSLocalizedString(@"bar_gift_stock", "")];
        [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftStockCount.intValue]]];
    }
            if ([f.value isEqual:FUNC_INSPECTION_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_INPECTION]];
                [cell.title setText:TITLENAME(FUNC_INSPECTION_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.inspectionReportCount]];
            }
            if ([f.value isEqual:FUNC_PATROL_TASK_DES]) {
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
               [cell.title setText:TITLENAME(FUNC_TASK_DES)];
                [cell.count setText:[NSString countNumAndChangeformat:countData.taskPatrolCount]];
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
    [tableview release];
    [super dealloc];
}
@end
