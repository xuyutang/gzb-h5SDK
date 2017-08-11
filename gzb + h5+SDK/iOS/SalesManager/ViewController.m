//
//  ViewController.m
//  SalesManager
//
//  Created by liu xueyan on 7/29/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "ViewController.h"
#import "Msg.pb.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.socket.delegate = self;

    //[mbProgress show:NO];

    
    [super viewDidLoad];
    
    [[UIDevice currentDevice] identifierForVendor];
	// Do any additional setup after loading the view, typically from a nib.
    [self login:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Web Socket

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"open");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"failwitherror");
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"closewithcode");
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
    NSLog(@"Got a binary message");
    
    [self _logReceiveData:message];
    //Hooray! I got a binary message.
}

- (void) _logReceiveData:(id) data{
    ClientResponse* cr = [ClientResponse parseFromData:(NSData*)data];
    
    switch (cr.type) {
        case RequestTypeLogin:{
            User* u = cr.user;
            
            newUser = [[[u toBuilder]setPassword:@"123456"] build];
            [[LocalManager sharedInstance] saveLoginUser:newUser];
            appDelegate.currentUser = newUser;
            
            //[mbProgress hide:YES];
            /*[self.view makeToast:@"登陆成功"
                        duration:3.0
                        position:@"bottom"];*/

            /*[[MessageBarManager sharedInstance] showMessageWithTitle:@"操作已成功"
                                                         description:@"登陆成功"
                                                                type:MessageBarMessageTypeSuccess
                                                         forDuration:3.0];*/
            [self getMessages];
            
            break;
        }
        case RequestTypeSyncCategory:{
            if (cr.code == ResultCodeResponseDone){
                NSMutableArray* ccs = [[NSMutableArray alloc]initWithCapacity:cr.customerCategories.count];
                for (int i = 0 ;i < cr.customerCategories.count;i++){
                    [ccs addObject:[cr.customerCategories objectAtIndex:i]];
                }
                [[LocalManager sharedInstance] saveCustomerCategories:ccs];
                
                NSMutableArray* cps = [[NSMutableArray alloc] initWithCapacity:cr.patrolCategories.count];
                for (int i =0; i< cr.patrolCategories.count;i++){
                    [cps addObject:[cr.patrolCategories objectAtIndex:i]];
                }
                [[LocalManager sharedInstance] savePatrolCategories:cps];
                [cps removeAllObjects];
                [cps release];
                
                NSMutableArray* fs = [[NSMutableArray alloc] initWithCapacity:cr.functions.count];
                for (int i =0; i< cr.functions.count;i++){
                    [fs addObject:[cr.functions objectAtIndex:i]];
                }
                [[LocalManager sharedInstance] saveFunctions:fs];
                [self _syncCustomer:appDelegate.currentUser];
                
                Location* l = cr.location;
                
                [[LocalManager sharedInstance] saveLocationSetting:l.interval];
            }
        }
            break;
            
        case RequestTypeCustomerList:{
            if (cr.code == ResultCodeResponseDone){
                NSMutableArray* cs = [[NSMutableArray alloc]initWithCapacity:cr.customers.count];
                for (int i = 0 ;i < cr.customers.count;i++){
                    [cs addObject:[cr.customers objectAtIndex:i]];
                }
                
                [[LocalManager sharedInstance] saveCustomers:cs];
                [self _syncUser:appDelegate.currentUser];
            }
        }
            break;
        case RequestTypeUserList:{
            if (cr.code == ResultCodeResponseDone){
                NSMutableArray* us = [[NSMutableArray alloc]initWithCapacity:cr.users.count];
                for (int i = 0 ;i < cr.users.count;i++){
                    [us addObject:[cr.users objectAtIndex:i]];
                }
                
                [[LocalManager sharedInstance] saveUsers:us];
                
                //[mbProgress hide:YES];
                /*[self.view makeToast:@"同步成功"
                 duration:3.0
                 position:@"bottom"];*/
                
                /*[[MessageBarManager sharedInstance] showMessageWithTitle:@"操作已成功"
                                                             description:@"同步数据成功"
                                                                    type:MessageBarMessageTypeSuccess
                                                             forDuration:3.0];*/
            }
        }
            break;
        case RequestTypeAttendanceCheckin:{
            if (cr.code == ResultCodeResponseDone){
                /*
                 WineTone.wtDB.saveSetting(WineToneDB.Setting.CHECKDATE.toString(),
                 DateUtil.getDateTime(DateUtil.PATTERN_DATE));
                 WineTone.wtDB.saveSetting(WineToneDB.Setting.CHECKIN.toString(),
                 String.valueOf(response.getAttendance().getId()));
                 */
                int i = cr.attendance.id;
                [[LocalManager sharedInstance] saveCheckIn:i];
                [[LocalManager sharedInstance] saveCheckInDate:[[LocalManager sharedInstance] getDate]];

                NSLog(@"打卡成功");
            }
        }
            break;

        case RequestTypeAttendanceCheckout:{
            if (cr.code == ResultCodeResponseDone){
        
                NSLog(@"下班打卡成功");
            }
        }
            break;

        
        case RequestTypeWorklogSave:{
            if (cr.code == ResultCodeResponseDone){
                
                NSLog(@"日志上传成功");
            }
        }
            break;
        case RequestTypeWorklogList:{
            if (cr.code == ResultCodeResponseDone){
                int worklogCount = cr.pageWorkLog.workLogs.count;
                
                //NSMutableArray* ws = [[NSMutableArray alloc]initWithCapacity:worklogCount];
                for (int i = 0 ;i < worklogCount;i++){
                    //[ws addObject:[cr.users objectAtIndex:i]];
                    WorkLog* wl = (WorkLog*)[[cr.pageWorkLog workLogs] objectAtIndex:i];
                    NSLog(@"第%d条日志==今日工作：%@，明日计划：%@，特殊：%@",i,wl.today,wl.plan,wl.special);
                }

                NSLog(@"日志查询成功");
                NSLog(@"每页显示条数%d",cr.pageWorkLog.pageSize);
                NSLog(@"日志总数%d",cr.pageWorkLog.totalSize);
            }
        }
            break;
        case RequestTypeChangePwd:{
            if (cr.code == ResultCodeResponseDone){
                [[LocalManager sharedInstance] saveLoginUser:newUser];
                appDelegate.currentUser = newUser;
                NSLog(@"密码修改成功");
            }
        }
            break;
        case RequestTypeStockSave:{
            if (cr.code == ResultCodeResponseDone){
 
                NSLog(@"上报库存成功");
            }
        }
            break;
            
        case RequestTypeStockList:{
            if (cr.code == ResultCodeResponseDone){
                int stockCount = cr.pageStock.stocks.count;
                
                for (int i = 0 ;i < stockCount;i++){
                    Stock* s = (Stock*)[[cr.pageStock stocks] objectAtIndex:i];
                    NSLog(@"第%d条上报库存信息",i);
                    NSLog(@"客户姓名:%@",s.customer.name);
                    NSLog(@"上报人姓名:%@",s.user.realName);
                    NSLog(@"上报时间:%@",s.createDate);
                    for (int j = 0;j < s.products.count;j++){
                        NSLog(@"第%d条产品信息",j);
                        Product* p = [s.products objectAtIndex:j];
                        NSLog(@"产品名称:%@",p.name);
                        NSLog(@"产品数量:%d",p.num);
                        NSLog(@"产品单位:%@",p.unit);
                    }
                    
                }
                
                NSLog(@"上报库存查询成功");
                NSLog(@"每页显示条数%d",cr.pageStock.pageSize);
                NSLog(@"上报库存总数%d",cr.pageStock.totalSize);
            }
        }
            break;
            
        case RequestTypeOrderGoods:{
            if (cr.code == ResultCodeResponseDone){
                
                NSLog(@"上报订单成功");
            }
        }
            break;
        case RequestTypeGoodsList:{
            if (cr.code == ResultCodeResponseDone){
                int orderCount = cr.pageOrderGoods.orderGoods.count;
                
                for (int i = 0 ;i < orderCount;i++){
                    OrderGoods* o = (OrderGoods*)[[cr.pageOrderGoods orderGoods] objectAtIndex:i];
                    NSLog(@"第%d条上报订单信息",i);
                    NSLog(@"客户姓名:%@",o.customer.name);
                    NSLog(@"上报人姓名:%@",o.user.realName);
                    NSLog(@"上报时间:%@",o.createDate);
                    for (int j = 0;j < o.products.count;j++){
                        NSLog(@"第%d条产品信息",j);
                        Product* p = [o.products objectAtIndex:j];
                        NSLog(@"产品名称:%@",p.name);
                        NSLog(@"产品数量:%d",p.num);
                        NSLog(@"产品单位:%@",p.unit);
                    }
                    
                }
                
                NSLog(@"上报订单查询成功");
                NSLog(@"每页显示条数%d",cr.pageOrderGoods.pageSize);
                NSLog(@"上报订单总数%d",cr.pageOrderGoods.totalSize);
            }
        }
            break;
            
        case RequestTypeMessageList:{
            /*
             List<Message> messages = response.getMessagesList();
             // Log.i(TAG, "获得消息数："+messages.size());
             if (!messages.isEmpty()) {
             WineTone.wtDB.saveMessages(messages);
             WineTone.getInstance().notify("收到" + messages.size() + "条消息",
             messages.get(0).getContent());
             */
            if (cr.code == ResultCodeResponseDone){
                NSMutableArray* ms = [[NSMutableArray alloc]initWithCapacity:cr.messages.count];
                for (int i = 0 ;i < cr.messages.count;i++){
                    [ms addObject:[cr.messages objectAtIndex:i]];
                }
                
                [[LocalManager sharedInstance] saveMessages:ms];
            }
        }
            break;
        
        case RequestTypePatrolSave:{

            if (cr.code == ResultCodeResponseDone){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"寻访报告上传成功");
            }
        }
            break;
        case RequestTypePatrolList:{
            if (cr.code == ResultCodeResponseDone){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                /*
                 holder.customerName.setText(item.getCustomer().getName());
                 holder.category.setText(item.getCategory().getName() + " | " + item.getCreateDate());
                 holder.content.setText(item.getContent());
                 holder.cb.setChecked(pItem.isChecked());
                 String uri = item.getFilePath(0);
                 mBitmapHelper.configLoadingImage(R.drawable.default_rect_pic);
                 mBitmapHelper.display(holder.file, uri, 80, 80);
                 */
                
                int patrolCount = cr.pagePatrol.patrols.count;
                
                for (int i = 0 ;i < patrolCount;i++){
                    Patrol* p = (Patrol*)[[cr.pagePatrol patrols] objectAtIndex:i];
                    NSLog(@"第%d条寻访报告信息",i);
                    NSLog(@"客户姓名:%@",p.customer.name);
                    NSLog(@"寻访类型:%@",p.category.name);
                    NSLog(@"上报时间:%@",p.createDate);
                    NSLog(@"图片地址:%@",[p.filePath objectAtIndex:0]);
                    ;

                }
                
                NSLog(@"寻访报告查询成功");
                NSLog(@"每页显示条数%d",cr.pagePatrol.pageSize);
                NSLog(@"寻访报告总数%d",cr.pagePatrol.totalSize);
            }

        }
            break;
            
        default:
            break;
    }
}
/**
 * Called when pong is sent... For keep-alive optimization.
 **/


-(IBAction)login:(id)sender{
    
    //[mbProgress setLabelText:@"正在登陆，请稍后。"];
    //[mbProgress show:YES];
   
    [appDelegate.socket loginWithUsername:@"11" password:@"123456"];
    
    socket = appDelegate.socket;
    requestType = RequestTypeLogin;
    
    
    
    /*if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // 越精确，越耗电！
    }
    
    [locationManager startUpdatingLocation];*/  // 开始定位
    
}

- (void) getMessages{
    /*
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.MESSAGE_LIST);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(user);
     Message message = wtDB.getLatestMessage();
     if (message != null) {
     request.setMessage(message);
     }
     sendRequest(request.build(), new BinderWebSocketCallback() {
     
     @Override
     public void onResponse(int resultCode, ClientResponse response, ClientRequest request,
     Object tag) {
     if (response.getCode() == ResultCode.RESPONSE_DONE) {
     List<Message> messages = response.getMessagesList();
     // Log.i(TAG, "获得消息数："+messages.size());
     if (!messages.isEmpty()) {
     WineTone.wtDB.saveMessages(messages);
     WineTone.getInstance().notify("收到" + messages.size() + "条消息",
     messages.get(0).getContent());
     
     }
     }
     }
     
     }, "message_list");
     */
    Message* m = [[LocalManager sharedInstance] getLastestMessage];
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", m,@"message",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeMessageList param:params];
    [params release];
}

- (IBAction)sync:(id)sender {
    //[mbProgress setLabelText:@"正在同步数据，请稍后。"];
    //[mbProgress show:YES];
    
    [self _syncCategory:appDelegate.currentUser];
}

- (void) _syncCategory:(User*) u{
    requestType = RequestTypeSyncCategory;
    
    [appDelegate.socket sendRequestWithType:RequestTypeSyncCategory param:u];
}

- (void) _syncCustomer:(User*) u{
    requestType = RequestTypeCustomerList;
    
    [appDelegate.socket sendRequestWithType:RequestTypeCustomerList param:u];
}

- (void) _syncUser:(User*) u{
    requestType = RequestTypeUserList;
    
    [appDelegate.socket sendRequestWithType:RequestTypeUserList param:u];
}
- (IBAction)goWork:(id)sender {
    /*
     if (checkInId() == -1) {
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.ATTENDANCE_CHECKIN);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(WineTone.getUser());
     Attendance.Builder attend = Attendance.newBuilder();
     attend.setUser(WineTone.getUser());
     attend.setId(-1);
     Location location = WineTone.wtDB.getLocation();
     attend.setAddress(location.getAddress());
     attend.setLatitude(location.getLatitude());
     attend.setLontitude(location.getLontitude());
     // attend.setComment(mComment.getText().toString());
     request.setAttendance(attend.build());
     if (BinderSDK.SDK_PENDING != WineTone.sendRequest(request.build(), checkInCallback,
     "attendance_checkin")) {
     WineTone.getInstance().showToast(getString(R.string.error_connect_server));
     } else {
     this.mLoadingDialog.show();
     }
     } else {
     WineTone.getInstance().showToast("已打过卡.");
     }
     */
    if ([self _checkIn] == -1) {
        requestType = RequestTypeAttendanceCheckin;
        
        Attendance_Builder* ab = [Attendance builder];
        Location* l = [[LocalManager sharedInstance] getLocation];
        [ab setId:-1];
        [ab setAddress:l.address];
        [ab setLatitude:l.latitude];
        [ab setLontitude:l.lontitude];
        [ab setComment:@"iphone 打卡"];
        [ab setUser:appDelegate.currentUser];
        
        //NSMutableArray* params = [[NSMutableArray alloc] init];
        //[params addObject:user];
        //[params addObject:a];
        NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [ab build],@"attendance",nil];
        [appDelegate.socket sendRequestWithType:RequestTypeAttendanceCheckin param:params];
        [params release];
    }
}
- (IBAction)goHome:(id)sender {
    /*
     int cid = checkInId();
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.ATTENDANCE_CHECKOUT);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(WineTone.getUser());
     Attendance.Builder attend = Attendance.newBuilder();
     attend.setUser(WineTone.getUser());
     Location location = WineTone.wtDB.getLocation();
     attend.setAddress(location.getAddress());
     attend.setLatitude(location.getLatitude());
     attend.setLontitude(location.getLontitude());
     attend.setId(cid);
     String comment = mComment.getText().toString();
     if (Validators.isNotEmpty(comment))
     attend.setComment(comment);
     request.setAttendance(attend.build());
     if (BinderSDK.SDK_PENDING != WineTone.sendRequest(request.build(), checkOutCallback,
     "attendance_checkout")) {
     WineTone.getInstance().showToast(getString(R.string.error_connect_server));
     } else {
     this.mLoadingDialog.show();
     }*/
    int cid = [self _checkIn];
    requestType = RequestTypeAttendanceCheckout;
    
    Attendance_Builder* ab = [Attendance builder];
    Location* l = [[LocalManager sharedInstance] getLocation];
    [ab setId:cid];
    [ab setAddress:l.address];
    [ab setLatitude:l.latitude];
    [ab setLontitude:l.lontitude];
    [ab setComment:@"iphone 下班打卡"];
    [ab setUser:appDelegate.currentUser];

    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [ab build],@"attendance",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeAttendanceCheckout param:params];
    [params release];
}

- (int) _checkIn{
    
    if (![[[LocalManager sharedInstance] getDate] isEqualToString:[[LocalManager sharedInstance] getCheckInDate]]){
        [[LocalManager sharedInstance] saveCheckIn:-1];
    }
    return [[LocalManager sharedInstance] getCheckIn];
    
}
- (IBAction)saveWorkLog:(id)sender {
    /*
     WorkLog.Builder report = WorkLog.newBuilder();
     report.setUser(WineTone.getUser());
     report.setToday(todayWork);
     report.setPlan(tomorrowPlan);
     report.setSpecial(specailItem);
     ClientRequest request = ClientRequest.newBuilder().setWorkLog(report.build())
     .setSequence(UUID.randomUUID().toString()).setType(RequestType.WORKLOG_SAVE)
     .setUser(WineTone.getUser()).build();
     */
    WorkLog_Builder* wb = [WorkLog builder];
    [wb setUser:appDelegate.currentUser];
    [wb setToday:@"今天上班"];
    [wb setPlan:@"明天上班"];
    [wb setSpecial:@"后天休息"];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [wb build],@"worklog",nil];
    REQUEST_STATUS status = [appDelegate.socket sendRequestWithType:RequestTypeWorklogSave param:params];
    if (status == NETWROK_NOT_AVAILABLE) {
        NSLog(@"NETWROK_NOT_AVAILABLE");
    }
    if (status == RECONNECT_WEBSOCKET){
        NSLog(@"RECONNECT_WEBSOCKET");
    }
    if (status == WEBSOCKET_NOT_OPEN){
        NSLog(@"WEBSOCKET_NOT_OPEN");
    }
    if (status == DONE){
        NSLog(@"REQUEST_DONE");
    }

    [params release];
}
- (IBAction)getWorkLogs:(id)sender {
    /*
     WorkLogParams.Builder param = WorkLogParams.newBuilder();
     param.setStartDate(mStartTime.getText().toString());
     param.setEndDate(mEndTime.getText().toString());*/
    
    /*
     WorkLogParams params = mWorkLogParams.toBuilder().setPage(page).build();
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setSequence(UUID.randomUUID().toString());
     //if (params.hasUser()) {
     //    request.setUser(params.getUser());
     //} else {
     request.setUser(WineTone.getUser());
     //}
     request.setType(RequestType.WORKLOG_LIST);
     request.setWorkLogParams(params);
     */
    WorkLogParams_Builder* wbparam = [WorkLogParams builder];
    //[wbparam setUser:appDelegate.currentUser];
    NSString* startDate = @"2013-07-01 00:00:00";
    NSString* endDate = @"2013-08-18 23:59:00";
    [wbparam setStartDate:startDate];
    [wbparam setEndDate:endDate];
    [wbparam setPage:1];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [wbparam build],@"worklogparam",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeWorklogList param:params];
    [params release];
}

- (IBAction)changePwd:(id)sender {
    /*
     final User newUser = user.toBuilder().setPassword(newPassword).build();
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.CHANGE_PWD);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(newUser);*/
    User* user = appDelegate.currentUser;
    newUser = [[[[user toBuilder] setPassword:@"123456"] build] retain];
    
    [[appDelegate socket] sendRequestWithType:RequestTypeChangePwd param:newUser];
    
}
- (IBAction)saveStock:(id)sender {
    /*
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.STOCK_SAVE);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(WineTone.getUser());
     
     Stock.Builder order = Stock.newBuilder();
     Location _location = WineTone.wtDB.getLocation();
     order.setId(-1);
     order.setAddress(_location.getAddress());
     order.setLatitude(_location.getLatitude());
     order.setLongitude(_location.getLontitude());
     order.setCustomer(mCustomer);
     order.addAllProducts(mProductAdapter.getAllItems());
     request.setStock(order.build());
     */
    
    Stock_Builder* sb = [Stock builder];
    Location* l = [[LocalManager sharedInstance] getLocation];
    [sb setId:-1];
    [sb setAddress:l.address];
    [sb setLatitude:l.latitude];
    
    CustomerCategory_Builder* ccb = [CustomerCategory builder];
    [ccb setId:1];
    [ccb setName:@"签约客户"];
    
    Customer_Builder* cb = [Customer builder];
    [cb setId:383];
    [cb setName:@"红星3号"];
    [cb setUser:appDelegate.currentUser];
    [cb setCategory:[ccb build]];
    Customer* c = [cb build];
    
    NSMutableArray* productSuppliess = [[LocalManager sharedInstance] getProductSupplies:c.id];
    
    NSMutableArray* ps = [[[NSMutableArray alloc]init]autorelease];
    for (Product* p in productSuppliess){
        Product* newp = [[[p toBuilder]setNum:30] build];
        
        [ps addObject:newp];
    }
    
    [sb setUser:appDelegate.currentUser];
    [sb setCustomer:c];
    
    [sb setProductsArray:(NSArray*)ps];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [sb build],@"stock",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeStockSave param:params];
    [params release];
}

- (IBAction)getStocks:(id)sender {
    /*
     StockParams params = mParams.toBuilder().setPage(page).build();
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setSequence(UUID.randomUUID().toString());
     //if (mParams.hasUser()) {
     //    request.setUser(mParams.getUser());
     //} else {
     request.setUser(WineTone.getUser());
     //}
     request.setType(RequestType.STOCK_LIST);
     request.setStockParams(params);
     */
    
    //[wbparam setUser:appDelegate.currentUser];
    StockParams_Builder* sbparam = [StockParams builder];
    NSString* startDate = @"2013-07-01 00:00:00";
    NSString* endDate = @"2013-08-18 23:59:00";
    [sbparam setStartDate:startDate];
    [sbparam setEndDate:endDate];
    [sbparam setPage:1];
    
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [sbparam build],@"stockparam",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeStockList param:params];
    [params release];

}

- (IBAction)saveOrder:(id)sender {
    /*
     ClientRequest.Builder request = ClientRequest.newBuilder();
     request.setType(RequestType.ORDER_GOODS);
     request.setSequence(UUID.randomUUID().toString());
     request.setUser(WineTone.getUser());
     
     OrderGoods.Builder order = OrderGoods.newBuilder();
     Location _location = WineTone.wtDB.getLocation();
     order.setId(-1);
     order.setAddress(_location.getAddress());
     order.setLatitude(_location.getLatitude());
     order.setLongitude(_location.getLontitude());
     order.setCustomer(mCustomer);
     order.addAllProducts(mGoodsPostAdapter.getAllItems());
     request.addAllOrderGoods(Arrays.asList(order.build()));*/
    
    OrderGoods_Builder* ob = [OrderGoods builder];
    Location* l = [[LocalManager sharedInstance] getLocation];
    [ob setId:-1];
    [ob setAddress:l.address];
    [ob setLatitude:l.latitude];
    [ob setLongitude:l.lontitude];
    
    CustomerCategory_Builder* ccb = [CustomerCategory builder];
    [ccb setId:1];
    [ccb setName:@"签约客户"];
    
    Customer_Builder* cb = [Customer builder];
    [cb setId:383];
    [cb setName:@"红星3号"];
    [cb setUser:appDelegate.currentUser];
    [cb setCategory:[ccb build]];
    Customer* c = [cb build];
    
    NSMutableArray* productSuppliess = [[LocalManager sharedInstance] getProductSupplies:c.id];
    
    NSMutableArray* ps = [[[NSMutableArray alloc]init]autorelease];
    for (Product* p in productSuppliess){
        Product* newp = [[[p toBuilder]setNum:80] build];
        
        [ps addObject:newp];
    }
    
    [ob setUser:appDelegate.currentUser];
    [ob setCustomer:c];
    
    [ob setProductsArray:(NSArray*)ps];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [ob build],@"order",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeOrderGoods param:params];
    [params release];
    
    
}
- (IBAction)getOrders:(id)sender {
    /*
     OrderGoodsParams.Builder param = OrderGoodsParams.newBuilder();
     param.setStartDate(mStartTime.getText().toString());
     param.setEndDate(mEndTime.getText().toString());
     if (mCustomer != null) {
     param.setCustomer(mCustomer);
     }
     if (mUser != null) {
     param.setUser(mUser);
     }
     */
    
    OrderGoodsParams_Builder* obparam = [OrderGoodsParams builder];
    NSString* startDate = @"2013-07-01 00:00:00";
    NSString* endDate = @"2013-08-18 23:59:00";
    [obparam setStartDate:startDate];
    [obparam setEndDate:endDate];
    [obparam setPage:1];
    
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [obparam build],@"orderparam",nil];
    [appDelegate.socket sendRequestWithType:RequestTypeGoodsList param:params];
    [params release];

}
- (IBAction)savePatrol:(id)sender {
    /*
     Patrol.Builder patrol = Patrol.newBuilder();
     patrol.setUser(WineTone.getUser());
     Location l = WineTone.wtDB.getLocation();
     patrol.setId(-1);
     patrol.setAddress(l.getAddress());
     patrol.setLatitude(String.valueOf(l.getLatitude()));
     patrol.setLongitude(String.valueOf(l.getLontitude()));
     patrol.setContent(mReport.getText().toString());
     patrol.setCategory((PatrolCategory) mPatrolCategory.getSelectedItem());
     if (mCustomer != null) {
     mCustomer = mCustomer.toBuilder()
     .setCategory((CustomerCategory) mCustomerCategory.getSelectedItem()).build();
     patrol.setCustomer(mCustomer);
     } else {
     mCustomer = mCustomerAdapter.getItem(mEditCustomerName.getText().toString().trim());
     if (null == mCustomer) {
     // 新客户,默认取拍照地点的经纬度
     Customer.Builder customer = Customer.newBuilder();
     customer.setId(-1);
     customer.setName(mEditCustomerName.getText().toString().trim());
     customer.setAddress(l.getAddress());
     customer.setLatitude(String.valueOf(l.getLatitude()));
     customer.setLongitude(String.valueOf(l.getLontitude()));
     customer.setUser(WineTone.getUser());
     customer.setCategory((CustomerCategory) mCustomerCategory.getSelectedItem());
     patrol.setCustomer(customer.build());
     } else {
     mCustomer = mCustomer.toBuilder()
     .setCategory((CustomerCategory) mCustomerCategory.getSelectedItem())
     .build();
     patrol.setCustomer(mCustomer);
     }
     }*/
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Loading";
    
    for (int i = 0 ; i < 2; i++) {
        if (i == 0){
            Patrol_Builder* pb = [Patrol builder];
            [pb setId:-1];
            [pb setUser:appDelegate.currentUser];
            Location* l = [[LocalManager sharedInstance] getLocation];
            [pb setAddress:l.address];
            
            [pb setLatitude:[NSString stringWithFormat:@"%f",l.latitude]];
            [pb setLongitude:[NSString stringWithFormat:@"%f",l.lontitude]];
            [pb setContent:@"iphone寻访报告"];
            
            PatrolCategory_Builder* pcb = [PatrolCategory builder];
            [pcb setId:1];
            [pcb setName:@"门头"];
            
            [pb setCategory:[pcb build]];
            
            CustomerCategory_Builder* ccb = [CustomerCategory builder];
            [ccb setId:1];
            [ccb setName:@"签约客户"];
            
            Customer_Builder* cb = [Customer builder];
            [cb setId:383];
            [cb setName:@"红星3号"];
            [cb setUser:appDelegate.currentUser];
            [cb setCategory:[ccb build]];
            Customer* c = [cb build];
            
            [pb setCustomer:c];
            
            UIImage*testImg = [UIImage imageNamed:@"app_splash.jpg"];
            NSData*dataImg = UIImagePNGRepresentation(testImg);
            
            UIImage*testImg1 = [UIImage imageNamed:@"app_splash.jpg"];
            NSData*dataImg1 = UIImagePNGRepresentation(testImg1);
            //const char* imgByte = [dataImg bytes];
            
            NSArray* images = [[NSArray alloc] initWithObjects:dataImg, dataImg1, nil];
            [pb setFilesArray:images];
            
            NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [pb build],@"patrol",nil];
            [appDelegate.socket sendRequestWithType:RequestTypePatrolSave param:params];
            [params release];
        }
        
        if (i == 1){
            
            Patrol_Builder* pb = [Patrol builder];
            [pb setId:-1];
            [pb setUser:appDelegate.currentUser];
            Location* l = [[LocalManager sharedInstance] getLocation];
            [pb setAddress:l.address];
            
            [pb setLatitude:[NSString stringWithFormat:@"%f",l.latitude]];
            [pb setLongitude:[NSString stringWithFormat:@"%f",l.lontitude]];
            [pb setContent:@"iphone寻访报告"];
            
            PatrolCategory_Builder* pcb = [PatrolCategory builder];
            [pcb setId:1];
            [pcb setName:@"门头"];
            
            [pb setCategory:[pcb build]];
            
            CustomerCategory_Builder* ccb = [CustomerCategory builder];
            [ccb setId:2];
            [ccb setName:@"潜在客户"];
            
            Customer_Builder* cb = [Customer builder];
            [cb setId:-1];
            [cb setName:@"AAAAAAAA"];
            [cb setUser:appDelegate.currentUser];
            [cb setAddress:l.address];
            [cb setLatitude:[NSString stringWithFormat:@"%f",l.latitude]];
            [cb setLongitude:[NSString stringWithFormat:@"%f",l.lontitude]];     
            [cb setCategory:[ccb build]];
            Customer* c = [cb build];
            
            [pb setCustomer:c];
            
            UIImage*testImg = [UIImage imageNamed:@"app_splash.jpg"];
            NSData*dataImg = UIImagePNGRepresentation(testImg);
            
            UIImage*testImg1 = [UIImage imageNamed:@"app_splash.jpg"];
            NSData*dataImg1 = UIImagePNGRepresentation(testImg1);
            //const char* imgByte = [dataImg bytes];
            
            NSArray* images = [[NSArray alloc] initWithObjects:dataImg, dataImg1, nil];
            [pb setFilesArray:images];
            
            NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [pb build],@"patrol",nil];
            [appDelegate.socket sendRequestWithType:RequestTypePatrolSave param:params];
            [params release];

            
        }
    }
    
}

- (IBAction)getPatrols:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Loading";
    /*
     PatrolParams.Builder param = PatrolParams.newBuilder();
     param.setCategory((PatrolCategory) mPatrolCategory.getSelectedItem());
     param.setCustomerCategory((CustomerCategory) mCustomerCategory.getSelectedItem());
     param.setStartDate(mStartTime.getText().toString());
     param.setEndDate(mEndTime.getText().toString());
     if (mCustomer != null) {
     param.setCustomer(mCustomer);
     }
     if (mUser != null) {
     param.setUser(mUser);
     }*/


    PatrolParams_Builder* pbparam = [PatrolParams builder];
    NSString* startDate = @"2013-07-01 00:00:00";
    NSString* endDate = @"2013-08-18 23:59:00";

    [pbparam setStartDate:startDate];
    [pbparam setEndDate:endDate];
    [pbparam setPage:1];
    
    PatrolCategory_Builder* pcb = [PatrolCategory builder];
    [pcb setId:1];
    [pcb setName:@"门头"];
    [pbparam setCategory:[pcb build]];
    
    CustomerCategory_Builder* ccb = [CustomerCategory builder];
    [ccb setId:1];
    [ccb setName:@"签约客户"];
    [pbparam setCustomerCategory:[ccb build]];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [pbparam build],@"patrolparam",nil];
    [appDelegate.socket sendRequestWithType:RequestTypePatrolList param:params];
    [params release];
}

- (IBAction)showHUD:(id)sender {
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
        case kCLErrorLocationUnknown:
            NSLog(@"The location manager was unable to obtain a location value right now.");
            break;
        case kCLErrorDenied:
            NSLog(@"Access to the location service was denied by the user.");
            break;
        case kCLErrorNetwork:
            NSLog(@"The network was unavailable or a network error occurred.");
            break;
        default:
            NSLog(@"未定义错误");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"oldLocation.coordinate.timestamp:%@", oldLocation.timestamp);
    NSLog(@"oldLocation.coordinate.longitude:%f", oldLocation.coordinate.longitude);
    NSLog(@"oldLocation.coordinate.latitude:%f", oldLocation.coordinate.latitude);
    
    NSLog(@"newLocation.coordinate.timestamp:%@", newLocation.timestamp);
    NSLog(@"newLocation.coordinate.longitude:%f", newLocation.coordinate.longitude);
    NSLog(@"newLocation.coordinate.latitude:%f", newLocation.coordinate.latitude);
    
    NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    NSLog(@"%lf", interval);
    
    // 取到精确GPS位置后停止更新
    //if (interval < 3) {
        // 停止更新
   //     [locationManager stopUpdatingLocation];
   // }
    
   // latitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
   // longitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
}

- (void)dealloc {
    [_btLogin release];
    [_btSync release];
    [_btGoWork release];
    [_btGoHome release];
    [_btSaveWorkLog release];
    [_btGetWorkLogs release];
    [_btChangePwd release];
    [_btSaveStock release];
    [_btGetStocks release];
    [_btSaveOrder release];
    [_btGetOrders release];
    [_btSavePatrol release];
    [_btGetPatrols release];
    [_btShowHUD release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtLogin:nil];
    [self setBtSync:nil];
    [self setBtGoWork:nil];
    [self setBtGoHome:nil];
    [self setBtSaveWorkLog:nil];
    [self setBtGetWorkLogs:nil];
    [self setBtChangePwd:nil];
    [self setBtSaveStock:nil];
    [self setBtGetStocks:nil];
    [self setBtSaveOrder:nil];
    [self setBtGetOrders:nil];
    [self setBtSavePatrol:nil];
    [self setBtGetPatrols:nil];
    [self setBtShowHUD:nil];
    [super viewDidUnload];
}

@end
