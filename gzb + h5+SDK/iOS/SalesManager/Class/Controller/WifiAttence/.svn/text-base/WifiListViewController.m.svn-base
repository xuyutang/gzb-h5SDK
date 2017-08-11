//
//  WifiListViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/12/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiListViewController.h"
#import "WifiListCell.h"
#import "Constant.h"
#import "AddWifiViewController.h"

@interface WifiListViewController ()

@end

@implementation WifiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    wifiMuLArray = [[NSMutableArray alloc]init];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [addImageView setImage:[UIImage imageNamed:@"ab_icon_add"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWifi)];
    [tapGesture1 setNumberOfTapsRequired:1];
    addImageView.userInteractionEnabled = YES;
    [addImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:addImageView];
    
    [addImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
   
    self.rightButton = btRight;
    [btRight release];
    self.view.backgroundColor = WT_WHITE;
    [self getWifiList];
    
    [lblFunctionName setText:@"WIFI列表"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWifiList)
                                                 name:@"refreshWifilist"
                                               object:nil];
}

-(void)updateWifiList {
    [self refreshTable];

}

-(void)createTable {
    wifiListTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    wifiListTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    wifiListTableView.pullBackgroundColor = [UIColor yellowColor];
    wifiListTableView.pullTextColor = [UIColor blackColor];
    wifiListTableView.delegate = self;
    wifiListTableView.dataSource = self;
    wifiListTableView.pullDelegate = self;
    wifiListTableView.tableFooterView = [[UIView alloc]init];
    
    wifiListTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    
    [self.view addSubview:wifiListTableView];

}

-(void)addWifi {
    AddWifiViewController *addWifiVC = [[AddWifiViewController alloc]init];
    [self.navigationController pushViewController:addWifiVC animated:YES];

}

-(void)getWifiList {
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    CheckInWifi_Builder *cb = [CheckInWifi builder];
    [cb setId:-1];
    [cb setUser:USER];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeCheckinWifiList param:@""]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }

}

-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
     NSUInteger Count = cr.datas.count;
    [wifiMuLArray removeAllObjects];
    PBAppendableArray* cs = [[PBAppendableArray alloc] autorelease];
    for (int i = 0 ;i < Count;i++){
        CheckInWifi* ac = [CheckInWifi parseFromData:[cr.datas  objectAtIndex:i]];
        [wifiMuLArray addObject:ac];
        [cs addObject:ac];
    }
    if (Count > 0) {
        [self createTable];
    }else {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                              description:@"暂无WIFI"
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
    }
   
   
}
#pragma mark - Refresh and load more methods

- (void) refreshTable {
    [self getWifiList];
    wifiListTableView.pullLastRefreshDate = [NSDate date];
    wifiListTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    wifiListTableView.pullTableIsLoadingMore = NO;
   
}


#pragma mark - tabViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return wifiMuLArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"wifiList";
    WifiListCell *wifiCell = [tableView dequeueReusableCellWithIdentifier:ident];
    CheckInWifi *checkInWifi = (CheckInWifi *)[wifiMuLArray objectAtIndex:indexPath.row];
    
    if (wifiCell == nil) {
        wifiCell = [[[NSBundle mainBundle]loadNibNamed:@"WifiListCell" owner:self options:nil]firstObject];
    }
    wifiCell.wifiNameLabel.text = checkInWifi.name;
    wifiCell.wifiOtherNameLabel.text = checkInWifi.macAddress;

    wifiCell.addressLabel.font = [UIFont systemFontOfSize:12];
    wifiCell.addressLabel.text = checkInWifi.location.address;
    if (checkInWifi.enabled == 3) {
        wifiCell.wifiSwichImageView.image = [UIImage imageNamed:@"switch-close"];
        wifiCell.wifiEnableImageView.image = [UIImage imageNamed:@"wifi_enable"];
        
    }else {
       wifiCell.wifiSwichImageView.image = [UIImage imageNamed:@"switch-open"];
       wifiCell.wifiEnableImageView.image = [UIImage imageNamed:@"wifi_disable"];
        wifiCell.wifiNameLabel.textColor  = WT_GRAY;
         wifiCell.wifiOtherNameLabel.textColor  = WT_GRAY;
         wifiCell.addressLabel.textColor  = WT_GRAY;
    }
    wifiCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return wifiCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}


-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
