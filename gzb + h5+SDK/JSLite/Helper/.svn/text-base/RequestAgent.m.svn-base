#import <malloc/malloc.h>
#import "RequestAgent.h"
#import "GlobalConstant.h"
#import "LocalManager.h"
#import "NSDate+Util.h"
#import "NSString+Helpers.h"
#import "UIDevice+Util.h"
#import "NSDate+Util.h"
#import "Product.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"
#import "NSData+AES.h"
#import "CookieHelper.h"

#define NO_RECEIVE_CODE 10000
#define DIC_KEY_REQUESTTYPE @"requestType"
#define DIC_KEY_DELEGATE @"delegate"
#define DIC_KEY_PARAM @"param"
#define DIC_KEY_REQUESTTIME @"requestTime"

@implementation RequestAgent
@synthesize delegate,webSocket=_webSocket,clientRequest,sendRequestType,recevieResultCode,pushDelegate,bUserIdChanged,bRequesting,actionDelegate;



-(BOOL)isExistenceNetwork
{
    struct sockaddr_in zeroAddress;//sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

-(id)init{
    bUserIdChanged = FALSE;
    if (requestQueue != nil) {
        [requestQueue removeAllObjects];
        [requestQueue release];
        requestQueue = nil;
    }
    requestQueue = [[NSMutableArray alloc] init];
    
    if (responseData != nil) {
        [self resetResponseData];
        [responseData release];
        responseData = nil;
    }
    responseData = [[NSMutableData alloc] init];
    agentQueue = dispatch_queue_create("cc.juicyshare.salesmanager", DISPATCH_QUEUE_SERIAL);
    return self;
}

-(void)loginWithUsername:(NSString *)username password:(NSString *)password {
    //pwd = [password copy];
    _webSocket.delegate = nil;
    [_webSocket close];
    if (_webSocket != nil){
        [_webSocket release];
        _webSocket = nil;
    }
    NSLog(@"Deivce model:%@",[UIDevice deviceModel]);
    NSLog(@"Device id:%@",[UIDevice deviceId]);
    NSLog(@"Device token:%@",[LOCALMANAGER getDeviceToken]);

    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString* token = [NSString stringWithFormat:@"%@%@%f",APP_KEY,APP_SECRET,timeInMiliseconds];
    
    NSString* serverUrl = [[NSString stringWithFormat:@"%@?uid=%d&log=%@&cid=%@&osVersion=%@&deviceType=%@&appVersion=%@&model=%@&deviceId=%@&vCode=%@&deviceToken=%@&appKey=%@&tokenTime=%@&token=%@",WS_SERVER,USER.id,username,USER.company.id,[UIDevice osVersion],DEVICE_TYPE,[UIDevice appVersion],[UIDevice deviceModel],[UIDevice deviceId],[UIDevice bundleVersion],[LOCALMANAGER getDeviceToken],APP_KEY,[NSString stringWithFormat:@"%f",timeInMiliseconds],token.md5] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"socket login URL:%@",serverUrl);
    NSURL* url = [NSURL URLWithString:serverUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //NSString* timestamp = [NSDate stringFromDate:[NSDate date ] withFormat:[NSDate timestampFormatString]];
    //NSLog(@"timestamp:%@",timestamp);
    
    NSLog(@"Request MD5 header:%@",token.md5);
    [request setValue:[NSString stringWithFormat:@"%f",timeInMiliseconds] forHTTPHeaderField:@"tokenTime"];
    [request setValue:token.md5 forHTTPHeaderField:@"token"];
    [request setValue:APP_KEY forHTTPHeaderField:@"appKey"];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    currentSocketDelegate = delegate;
    [_webSocket open];
}

-(void) close{
    while (bRequesting) {
        NSLog(@"waiting.....");
        sleep(1);
    }
    _webSocket.delegate = nil;
    [_webSocket close];
    if (_webSocket != nil){
        [_webSocket release];
        _webSocket = nil;
    }
}

-(void)reconnect{
    NSLog(@"try to reconnecting.");
    
    User* u = [LOCALMANAGER getLoginUser];
    if (u != nil) {
        [self loginWithUsername:u.userName password:u.password.sha256];
    }
}

-(REQUEST_STATUS) sendRequestWithType:(int)requestType param:(id)param{

    sendRequestType = requestType;
    recevieResultCode = NO_RECEIVE_CODE;
    
    //2.4 所有请求均从http通道，无需验证socket通断
    /*
    if (_webSocket.readyState != SR_OPEN){
        
        if (![self isExistenceNetwork]){
            bRequesting = NO;
            return NETWROK_NOT_AVAILABLE;
        }
        
        if (_webSocket.readyState == SR_CONNECTING){
            bRequesting = NO;
            //return RECONNECT_WEBSOCKET;
        }
        
        bRequesting = NO;
        [self reconnect];
        int tryTimes = 0;
        while (_webSocket.readyState != SR_OPEN) {
            
            if (tryTimes == 3) {
                return NETWROK_NOT_AVAILABLE;
            }
            ++tryTimes;
            sleep(1);
            
            
        }
    }*/
    
    //网络监测
    if (![self isExistenceNetwork]) {
        return NETWROK_NOT_AVAILABLE;
    }
    if (requestType != ActionTypeLogin && requestType != ActionTypeLogout) {
        //用户是否有效
        if (USER != nil && [LOCALMANAGER validateUserExpire:USER]) {
            NSString *msg = [LOCALMANAGER isUserExpire:USER];
            msg = msg.length == 0 ? NSLocalizedString(@"error_account_expired", nil) : msg;
            currentSocketDelegate = delegate;
            //自定义错误信息
            SessionResponse_Builder* crb = [SessionResponse builder];
            [crb setSequence:[NSString UUID]];
            [crb setType:NS_ACTIONTYPE(sendRequestType)];
            [crb setCode:NS_ACTIONCODE(ActionCodeErrorServer)];
            [crb setResultMessage:msg];
            [self webSocket:nil didReceiveMessage:[crb build].dataStream];
            return DONE;    
        }
    }
    //如果有网络请求正在进行，就进入队列等待；
    if (param == nil) {
        param = @"";
    }
    if (requestType == ActionTypeLogin) {
        User* u = (User*)param;
        pwd = [u.password copy];
    }
    
    dispatch_async(agentQueue, ^{
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:requestType],DIC_KEY_REQUESTTYPE,param,DIC_KEY_PARAM,delegate,DIC_KEY_DELEGATE, nil];
        [self requestTimer:dict];
        [dict release];
    });
    return DONE;
}

-(void)requestTimer:(NSDictionary *) dict{
    
    int requestType = [(NSNumber *)[dict objectForKey:DIC_KEY_REQUESTTYPE] intValue];
    id param = [dict objectForKey:DIC_KEY_PARAM];
    currentSocketDelegate = [dict objectForKey:DIC_KEY_DELEGATE];
    
    //当前正在运行的请求
    NSDictionary* curRequest = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:requestType],DIC_KEY_REQUESTTYPE,param,DIC_KEY_PARAM,currentSocketDelegate,DIC_KEY_DELEGATE,[NSDate getCurrentDateTime],DIC_KEY_REQUESTTIME, nil];
    
    
    NSData *dtRequest = nil;
    
    Device_Builder* v1 = [Device builder];
    [v1 setAppVersion:[UIDevice appVersion]];
    [v1 setAppVersionCode:[UIDevice bundleVersion].intValue];
    [v1 setDeviceType:DEVICE_TYPE];
    [v1 setModel:[UIDevice model]];
    [v1 setDeviceId:[UIDevice deviceId]];
    [v1 setDeviceToken:[LOCALMANAGER getDeviceToken]];
    Device* d = [v1 build];
    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString* tokenStr = [NSString stringWithFormat:@"%@%@%f",APP_KEY,APP_SECRET,timeInMiliseconds];
    
    Token_Builder* tb = [Token builder];
    [tb setToken:tokenStr.md5];
    [tb setTokenTime:[NSString stringWithFormat:@"%f",timeInMiliseconds]];
    [tb setAppKey:APP_KEY];
    Token* token = [tb build];
    
    dtRequest = [self createDtRequestWithRequestType:requestType
                                              device:d
                                               param:param
                                               token:token];
    
    if (dtRequest !=  nil){
        NSLog(@"send request type:%@",NS_ACTIONTYPE(requestType));
        NSLog(@"send data length:%lu",(unsigned long)dtRequest.length);
        //创建请求
        ASIHTTPRequest* request = nil;
        switch (requestType) {
            case ActionTypeLogin:{
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:HTTP_LOGIN_SERVER]];
            }
                break;
            case ActionTypeLogout:{
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:HTTP_LOGOUT_SERVER]];
            }
                break;
                
            default:{
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:HTTP_SERVER]];
            }
                break;
        }
        //设置请求Cookie
        [request setRequestCookies:[COOKIEHEPLER getCookie]];
        //设置请求类型
        [request setRequestMethod:@"POST"];
        //请求头
        request.timeOutSeconds = 60.f;
        [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
        //[request addRequestHeader:@"Accept" value:@"application/x-protobuf"];
        //[request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)dtRequest.length]];
        NSLog(@"requestCookies:%@",request.requestCookies);
        //加密传输数据
        DataOutputStream* stream = [[DataOutputStream alloc] init];
        NSData* encryptData = [dtRequest AES256EncryptedDataWithKey:[APP_KEY substringToIndex:16] iv:IV_KEY];
        NSLog(@"encrypt data size:%lu", (unsigned long)encryptData.length);
        [stream writeInt:encryptData.length];
        [stream writeBytes:encryptData];
        NSData* data = [stream toByteArray];
        [request setPostBody:[NSMutableData dataWithData:data]];
        
        request.delegate = self;
        [request startSynchronous];
        
    }
}

-(NSData *) createDtRequestWithRequestType:(int) requestType device:(Device *) d param:(id) param token:(Token *) token{
    NSData *dtRequest;
    SessionRequest_Builder* crb = [SessionRequest builder];
    [crb setType:NS_ACTIONTYPE(requestType)];
    [crb setSequence:[NSString UUID]];
    [crb setToken:token];
    [crb setDevice:d.dataStream];
    if (requestType == ActionTypeLogin) {
        [crb setParam:((User*)param).dataStream];
    }else{
        [crb setParam:USER.dataStream];
    }
    
    switch (requestType) {
        case ActionTypeLogin:{
        }
            break;
        case ActionTypeLogout:{
           [crb setData:((Log *) param).dataStream];
        }
            break;
        case ActionTypeUserInfoGet:{
            [crb setData:((UserParams*)param).dataStream];
        }
            break;
        case ActionTypeCountDataGet:{
            [crb setData:((CountParams*)param).dataStream];
        }
            break;
        case ActionTypeAttendanceCategoryList:{
        }
            break;
        case   ActionTypeCustomerList:{
            [crb setData:((CustomerParams*)param).dataStream];
        }
            break;
        case ActionTypeAttendanceSave:{
            [crb setData:((Attendance*)param).dataStream];
        }
            break;
            
        case ActionTypeAttendanceGet:{
            [crb setData:((AttendanceParams *)param).dataStream];
        }
            break;
        case ActionTypeWorklogSave:{
            [crb setData:((WorkLog*)param).dataStream];
        }
            break;
        case ActionTypeWorklogList:{
            [crb setData:((WorkLogParams*)param).dataStream];
        }
            break;
            
            
        case ActionTypeChangePwd:{
            [crb setData:((User*)param).dataStream];
        }
            break;
        case ActionTypeStockSave:{
            [crb setData:((Stock*)param).dataStream];
        }
            break;
        
        case ActionTypeStockList:{
            [crb setData:((StockParams*)param).dataStream];
        }
            break;
        case ActionTypeSalegoodsSave:{
            [crb setData:((SaleGoods*)param).dataStream];
        }
            break;
            
        case ActionTypeSalegoodsList:{
            [crb setData:((SaleGoodsParams*)param).dataStream];
        }
            break;
            
        case ActionTypeOrdergoodsSave:{
            [crb setData:((OrderGoods*)param).dataStream];
        }
            break;
            
        case ActionTypeOrdergoodsList:{
            [crb setData:((OrderGoodsParams*)param).dataStream];
        }
            break;
            
        case ActionTypeCompetitiongoodsSave:{
            [crb setData:((CompetitionGoods*)param).dataStream];
        }
            break;
            
        case ActionTypeCompetitiongoodsList:{
            [crb setData:((CompetitionGoodsParams*)param).dataStream];
        }
            break;
            
        case ActionTypeMessageList:{
            SysMessageParams* m = (SysMessageParams*)param;
            [crb setData:m.dataStream];
        }
            break;
            
        case ActionTypeAnnounceList:{
            AnnounceParams* m = (AnnounceParams*)param;
            [crb setData:m.dataStream];
        }
            break;
            
        case ActionTypePatrolSave:{
            [crb setData:((Patrol*)param).dataStream];
        }
            break;
        case ActionTypeAttendanceReply:{
            [crb setData:((AttendanceReply *)param).dataStream];
        }
            break;
            
        case ActionTypePatrolReply:{
            [crb setData:((PatrolReply *)param).dataStream];
        }
            break;
            
        case ActionTypePatrolList:{
            [crb setData:((PatrolParams *)param).dataStream];
        }
            break;
            
            
        case ActionTypeFavSave:{
            [crb setData:((FavData *)param).dataStream];
        }
            break;
            
        case ActionTypeAttendanceList:{
            [crb setData:((AttendanceParams*)param).dataStream];
        }
            break;
            
        case ActionTypeWorklogReply :{
            [crb setData:((WorkLogReply *)param).dataStream];
            
        }
            break;
            
        case ActionTypeLocationSave:{
            [crb setData:((Location *)param).dataStream];
        }
            break;
        case ActionTypeMarketresearchReply:{
            [crb setData:((MarketResearchReply *)param).dataStream];
        }
            break;
            
        case ActionTypeMarketresearchSave:{
            [crb setData:((MarketResearch*)param).dataStream];
        }
            break;
        case ActionTypeMarketresearchList:{
            [crb setData:((MarketResearchParams *)param).dataStream];
            
        }
            break;
            
        case ActionTypeBusinessopportunitySave:{
            [crb setData:((BusinessOpportunity *)param).dataStream];
        }
            break;
        case ActionTypeBusinessopportunityList:{
            [crb setData:((BusinessOpportunityParams *)param).dataStream];
        }
            break;
            
        case ActionTypeBusinessopportunityReply :{
            [crb setData:((BusinessOpportunityReply *)param).dataStream];
        }
            break;
            
        case ActionTypeAnnounceAck:{
            [crb setDatasArray:(NSArray *)param ];
        }
            break;
            
        case ActionTypeMessageAck:{
            [crb setDatasArray:(NSArray *)param];
        }
            break;
            
        case ActionTypeWorklogGet:{
            [crb setData:((WorkLogParams *)param).dataStream];
        }
            break;
            
        case ActionTypeMarketresearchGet:{
            [crb setData:((MarketResearchParams *)param).dataStream];
        }
            
            break;
        case ActionTypePatrolGet:{
            [crb setData:((PatrolParams *)param).dataStream];
        }
            
            break;
            
        case ActionTypeSyncBaseData:
        {
            bSyncInTime = FALSE;
            if ([param isKindOfClass:[NSArray class]]) {
                [crb setDatasArray:((NSArray*)param)];
                bSyncInTime = TRUE;
            }
        }
            break;
        case ActionTypeSyncCustomerList:{
            [crb setData:((CustomerParams *)param).dataStream];
        }
            break;
            
        case ActionTypeCompanyspaceCategoryList:{
        }
            break;
            
        case ActionTypeCompanyspaceList:{
            [crb setData:((CompanySpaceParams *)param).dataStream];
        }
            break;
        case ActionTypeBusinessopportunityGet:{
           [crb setData:((BusinessOpportunityParams *) param).dataStream];
        }
            break;
            
            //申请保存
        case ActionTypeApplyItemSave:{
            [crb setData:((ApplyItem*)param).dataStream];
        }
            break;
            //申请批复保存
        case ActionTypeApplyItemReply:{
           [crb setData:((ApplyItemReply *)param).dataStream];
        }
            break;
            //获取申请列表
        case ActionTypeApplyItemList:{
            [crb setData:((ApplyItemParams *)param).dataStream];
        }
            break;
            //获取申请单详情
        case ActionTypeApplyItemGet:{
            [crb setData:((ApplyItemParams *)param).dataStream ];
        }
            break;
            //赠品采购
        case ActionTypeGiftPurchaseSave:{
            [crb setData:((GiftPurchase *)param).dataStream];
        }
            break;
            //获取赠品采购列表
        case ActionTypeGiftPurchaseList:{
            [crb setData:((GiftPurchaseParams *)param).dataStream];
        }
            break;
            //获取赠品采购详情
        case ActionTypeGiftPurchaseGet:{
            [crb setData:((GiftPurchaseParams *)param).dataStream];
        }
            break;
            //赠品配送保存
        case ActionTypeGiftDeliverySave:{
            [crb setData:((GiftDelivery *)param).dataStream];
        }
            break;
            //获取赠品配送列表
        case ActionTypeGiftDeliveryList:{
            [crb setData:((GiftDeliveryParams *)param).dataStream];
        }
            break;
            //获取赠品配送详情
        case ActionTypeGiftDeliveryGet:{
            [crb setData:((GiftDeliveryParams *)param).dataStream];
        }
            break;
            //赠品发放保存
        case ActionTypeGiftDistributeSave:{
            [crb setData:((GiftDistribute *)param).dataStream];
        }
            break;
            //获取赠品发放列表
        case ActionTypeGiftDistributeList:{
            [crb setData:((GiftDistributeParams *)param).dataStream];
        }
            break;
            //获取赠品发放详情
        case ActionTypeGiftDistributeGet:{
            [crb setData:((GiftDistributeParams *) param).dataStream];
        }
            break;
            //赠品盘库保存
        case ActionTypeGiftStockSave:{
            [crb setData:((GiftStock *)param).dataStream];
        }
            break;
            //获取赠品盘库列表
        case ActionTypeGiftStockList:{
            [crb setData:((GiftStockParams *)param).dataStream];
        }
            break;
            //获取赠品盘库详情
        case ActionTypeGiftStockGet:{
            [crb setData:((GiftStockParams *)param).dataStream];
        }
            break;
            
            //获取巡检列表
        case ActionTypeInspectionReportList:{
            [crb setData:((InspectionReportParams *)param).dataStream];
        }
            break;
            //获取巡检详情
        case ActionTypeInspectionReportGet:{
            [crb setData:((InspectionReportParams *)param).dataStream];
        }
            break;
            //巡检保存
        case ActionTypeInspectionReportSave:{
            [crb setData:((InspectionReport *)param).dataStream];
        }
            break;
        case ActionTypeInspectionReportReply:{
            [crb setData:((InspectionReportReply *)param).dataStream];
        }
            break;
            //获取巡访任务列表
        case ActionTypeTaskPatrolList:{
            [crb setData:((TaskPatrolParams *)param).dataStream];
        }
            break;
            //获取巡访任务详情V2
        case ActionTypeTaskPatrolGet:{
            [crb setData:((TaskPatrolDetailParams *) param).dataStream];
        }
            break;
            //保存巡访任务
        case ActionTypeTaskPatrolDetailSave:{
            [crb setData:((TaskPatrolDetail *)param).dataStream];        }
            break;
            //获取我的任务列表
        case ActionTypeMyTaskPatrolList:{
            [crb setData:((TaskPatrolParams *)param).dataStream];
        }
            break;
            //获取巡访任务详情
        case ActionTypeMyTaskPatrolGet:{
            [crb setData:((TaskPatrolDetailParams *) param).dataStream];
        }
            break;
            //批复巡访任务
        case ActionTypeTaskPatrolReply:{
            [crb setData:((TaskPatrolReply *) param).dataStream];
        }
            break;
            //更新用户信息
        case ActionTypeUserInfoUpdate:{
            [crb setData:((User *) param).dataStream];
        }
            break;
            //保存客户
        case ActionTypeCustomerSave:{
            [crb setData:((Customer *) param).dataStream];
        }
            break;
            //保存用户登录、登出信息
        case ActionTypeUserLogSave:{
            [crb setData:((Log *) param).dataStream];
        }
            break;
            //获取周边人员
        case ActionTypeUserList:{
            [crb setData:((UserParams *) param).dataStream];
        }
            break;
            //获取企业通讯录
        case ActionTypeCompanyContactList:{
        }
            break;
            //获取工作日志回复列表
        case ActionTypeWorklogReplyList:{
            [crb setData:((WorkLogParams *)param).dataStream];
        }
            break;
            //获取巡访报告回复列表
        case ActionTypePatrolReplyList:{
            [crb setData:((PatrolParams *)param).dataStream];
        }
            break;
            //获取申请回复列表
        case ActionTypeApplyItemReplyList:{
            [crb setData:((ApplyItemParams *)param).dataStream];
        }
            break;
            //获取任务回复列表
        case ActionTypeTaskPatrolReplyList:{
            [crb setData:((TaskPatrolParams *)param).dataStream];
        }
            break;
            //保存视频
        case ActionTypeVideoTopicSave:{
            [crb setData:((VideoTopic *) param).dataStream];
        }
            break;
            //获取视频列表
        case ActionTypeVideoTopicList:{
            [crb setData:((VideoTopicParams *)param).dataStream];
        }
            break;
            //获取视频详情
        case ActionTypeVideoTopicGet:{
            [crb setData:((VideoTopicParams *) param).dataStream];
        }
            break;
            //获取视频回复列表
        case ActionTypeVideoTopicReplyList:{
            [crb setData:((VideoTopicParams *)param).dataStream];
        }
            break;
            //批复视频
        case ActionTypeVideoTopicReply:{
            [crb setData:((VideoTopicReply *) param).dataStream];
        }
            break;
            //保存常用语
        case ActionTypeFavLangSave:{
            [crb setData:((FavoriteLang*)param).dataStream];
        }
            break;
            //获取常用语
        case ActionTypeFavLangList:{
        }
            break;
            //更新常用语
        case ActionTypeFavLangUpdate:{
            [crb setData:((FavoriteLang*)param).dataStream];
        }
            break;
            //删除常用语
        case ActionTypeFavLangDelete:{
            [crb setData:((FavoriteLang*)param).dataStream];
        }
            break;
            //打印
        case ActionTypePrintOrder:{
            [crb setData:((PrintParams*)param).dataStream];
        }
            break;
            //取消客户收藏
        case ActionTypeCustomerFavDelete:{
            [crb setDatasArray:(NSArray *)param];
        }
            break;
            //客户收藏列表
        case ActionTypeCustomerFavList:{
        }
            break;
            //收藏客户
        case ActionTypeCustomerFavSave:{
            [crb setDatasArray:(NSArray *)param];
        }
            break;
           //模板列表
        case ActionTypePaperTemplateList:{
        }
            
            break;
            //数据上报保存
        case ActionTypePaperPostSave: {
          [crb setData:((PaperPost*)param).dataStream];
            
        }
            break;
            //数据上报列表
        case ActionTypePaperPostList: {
            [crb setData:((PaperPostParams*)param).dataStream];

        }
            break;
            //数据上报获取
        case ActionTypePaperPostGet: {
            [crb setData:((PaperPostParams *) param).dataStream];
        }
            break;
            //是否拥有该假休类型
        case ActionTypeIsExistHolidayCategoryFlow:
            [crb setData:((HolidayCategory *) param).dataStream];
            break;
            //假休申请保存
        case ActionTypeHolidayApplySave:
             [crb setData:((HolidayApply *) param).dataStream];
            break;
            //获取排班表
        case ActionTypeCheckinShiftGet:
        
            break;
            //打卡记录保存
        case ActionTypeCheckinTrackSave:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //打卡记录列表
        case ActionTypeCheckinTrackList:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //获取打卡记录详情
        case ActionTypeCheckinTrackGet:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //打卡回复
        case ActionTypeCheckinTrackReply:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //打卡回复列表
        case ActionTypeCheckinTrackReplyList:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //WIFI上报
        case ActionTypeCheckinWifiSave:
            [crb setData:((CheckInWifi *) param).dataStream];
            break;
            //获取WIFI列表
        case ActionTypeCheckinWifiList:
          
            break;
            //时间查询
        case ActionTypeCheckinTrackDate:
            [crb setData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        //补卡
        case ActionTypeCheckinTrackRemark:
            [crb setData:((CheckInTrack *) param).dataStream];
            break;
            //增加云通知
        case ActionTypeAnnouncementSave:
            [crb setData:((Announce *) param).dataStream];
            break;
            //假休审批
        case ActionTypeHolidayApplyApprove:
            [crb setData:((HolidayApply *) param).dataStream];
            break;
            //审核列表
        case ActionTypeApplyItemAuditList:
            [crb setData:((ApplyItemParams *) param).dataStream];
            break;
            //审批
        case ActionTypeApplyItemApprove:
            [crb setData:((ApplyItem *) param).dataStream];
            break;
            //检查是否有审批人
        case ActionTypeApplyCategoryUsers:
            [crb setData:((ApplyCategory *) param).dataStream];
            break;
            
        default:
            break;
    }
    
    SessionRequest* cr = [crb build];
    dtRequest = [cr dataStream];
    
    return dtRequest;
}

#pragma Socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    //Socket连接建立成功后，创建定时ping
    if (!bPingIsRuning){
        [NSTimer scheduledTimerWithTimeInterval:PINGDURATION
                                         target:self
                                       selector:@selector(sendPing)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    NSLog(@"socket open code:%d",_webSocket.readyState);
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(didOpen:)]) {
        [currentSocketDelegate didOpen];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    NSLog(@"socket close with code:%ld",(long)code);
    NSLog(@"socket close reason:%@",reason);
    
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(didCloseWithCode:reason:wasClean:)]) {
        [currentSocketDelegate didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:(NSData *)message];
    /*
    if (![cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
        if (actionDelegate != nil && [actionDelegate respondsToSelector:@selector(didReceiveActionCode:)]) {
            [actionDelegate didReceiveActionCode:cr];
        }
        return;
    }*/
    
    
    //2.0版本处理
    NSLog(@"receive data size = %@ Kb",[NSString stringWithFormat:@"%.2f",((float)((NSData*)message).length / 1024)]);
    recevieResultCode = (int)INT_ACTIONCODE(cr.code);
    NSLog(@"response type:%@,response code:%@",cr.type,cr.code);
    
    //账户异常或应用异常
    if ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeErrorAppException)] || [cr.code isEqualToString:NS_ACTIONCODE(ActionCodeErrorAccountException)])  {
//        [self cleanUser:cr];
    }
    //消息
    if (([cr.type isEqualToString:NS_ACTIONTYPE(ActionTypePushMsg)]) && ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)])) {
        NSMutableArray* messageSeqs = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray* requestDatas = [[[NSMutableArray alloc] init] autorelease];
        if (cr.hasData) {
            SessionMessage* wtm = [SessionMessage parseFromData:cr.data];
            if ([self validateMessage:cr WTMsg:wtm]) {
                SessionMessage* t = [[[[wtm toBuilder] clearBody] clearHeader] build];
                [messageSeqs addObject:t.dataStream];
                
                [self parseMessage:wtm RequestDatas:requestDatas];
            }
        }else{
            for (int i = 0; i < cr.datas.count; ++i) {
                SessionMessage* wtm = [SessionMessage parseFromData:[cr.datas objectAtIndex:i]];
                if ([self validateMessage:cr WTMsg:wtm]) {
                    SessionMessage* t = [[[[wtm toBuilder] clearBody] clearHeader] build];
                    [messageSeqs addObject:t.dataStream];
                    
                    [self parseMessage:wtm RequestDatas:requestDatas];
                }
            }
        }
        if (messageSeqs.count > 0) {
            [self sendRequestWithType:ActionTypeMessageAck param:messageSeqs];
        }
        if (requestDatas.count > 0){
            [self sendRequestWithType:ActionTypeSyncBaseData param:requestDatas];
        }
        
        [self pushMessage:cr];
    }
    //更新用户信息
    if (((INT_ACTIONTYPE(cr.type) == ActionTypeUserInfoUpdate) && ([cr.code isEqualToString: NS_ACTIONCODE(ActionCodeDone)]))){
        User* crUser = [User parseFromData:cr.data];
        if (crUser.avatars.count > 0) {
            User_Builder* ub = [USER toBuilder];
            [ub setAvatarsArray:[[NSArray alloc] initWithObjects:[crUser.avatars objectAtIndex:0], nil]];
            User* u = [ub build];
            USER = [u retain];
        }
        
    }
    //实时同步消息
    if ((([cr.type isEqualToString:NS_ACTIONTYPE(ActionTypeSyncBaseData)]) && ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)]) && bSyncInTime)) {
        [self syncInTime:cr];
        [self pushMessage:cr];
    }
    //发送登录日志
    if ((([cr.type isEqualToString:NS_ACTIONTYPE(ActionTypeLogin)] ) && ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)]))){
        [USER release];
        USER = nil;
    
        //2.0服务端返回用户过期信息
        //验证当用户更换了企业，需要强制用户重新登录
        User* crUser = [User parseFromData:cr.data];
        NSLog(@"return userid:%d",crUser.id);
        NSLog(@"return local userid:%d",[LOCALMANAGER getLoginUser].id);
        if ([LOCALMANAGER getLoginUser].id != 0) {
            
            if (crUser.id != [LOCALMANAGER getLoginUser].id){
                NSLog(@"UserId Changed!");
                bUserIdChanged = TRUE;
            }
        }
        
        if (USER == nil){
            User_Builder* ub = [crUser toBuilder];
            [ub setPassword:pwd];
            User* u = [ub build];
            USER = [u retain];
        }
        
        [self pushMessage:cr];
    }
    //数据交由代理处理
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
        if (bUserIdChanged) {
            [COOKIEHEPLER clearCookie];
            [LOCALMANAGER cleanLoginUser];
            SessionResponse_Builder* crb = [SessionResponse builder];
            [crb setSequence:[NSString UUID]];
            [crb setType:cr.type];
            [crb setCode:NS_ACTIONCODE(ActionCodeErrorAccountException)];
            
            [currentSocketDelegate didReceiveMessage:[crb build].dataStream];
            
        }else{
            if ((([cr.type isEqualToString:NS_ACTIONTYPE(ActionTypeSyncBaseData)]) && ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)]) && bSyncInTime)) {
                return;
            }
            [currentSocketDelegate didReceiveMessage:message];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    NSLog(@"socket fail code:%d",_webSocket.readyState);
    NSLog(@"socket fail reason:%@",error);
    bRequesting = NO;
    if ((sendRequestType == ActionTypeAnnounceList) || (sendRequestType == ActionTypeMessageList)){
        return;
    }
    
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(didFailWithError:)]) {
        [currentSocketDelegate didFailWithError:error];
    }
}

- (void) sendPing{
    bPingIsRuning = TRUE;
    if (_webSocket.readyState != SR_OPEN)
        return;
    
    //NSData* aData = [@"" dataUsingEncoding:NSASCIIStringEncoding];
    [_webSocket sendPing:@""];
    
    NSLog(@"============send ping");
}

- (void) cleanUser:(SessionResponse*) cr{
    if (pushDelegate != nil && [pushDelegate respondsToSelector:@selector(receivePushMessage:)]) {
        //账号过期，清除本地所有数据
        [USER release];
        USER = nil;
        [LOCALMANAGER cleanLoginUser];
        [pushDelegate receivePushMessage:cr];
    }
    return;
}

- (BOOL) validateMessage:(SessionResponse*) wtr WTMsg:(SessionMessage*) wtm{
    if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeException)]) {
        ExceptionMessage* m = [ExceptionMessage parseFromData:wtm.body.content];
        [self setUserExpire:m];
        //[self cleanUser:wtr];
        return FALSE;
    }
    return TRUE;
}

- (void) parseMessage:(SessionMessage*) wtm RequestDatas:(NSMutableArray*) requestDatas{
    if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeService)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeService));
        [LOCALMANAGER saveMessage:wtm];
    }
    if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeAnnounce)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeAnnounce));
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:wtm.header.sender.realName forKey:@"announceRealName"];
        [user synchronize];
    
        User* u = [wtm.header.sender retain];
        Announce * a = [Announce parseFromData: wtm.body.content];
        // 构造对象，toBuilder
        Announce_Builder* ab = [a toBuilder];
        [ab setCreator:u];
        Announce *announce = [ab build];
        
        [LOCALMANAGER saveAnnounce2:announce];
        [LOCALMANAGER updateAnnounceSender:u];
        
    }
    
    if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeSyncdata)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeSyncdata));
        SyncDataMessage* m = [SyncDataMessage parseFromData:wtm.body.content];
        
        SyncDataParams_Builder* p = [SyncDataParams builder];
        [p setSyncType:m.syncType];
        [p setSyncTarget:m.syncTarget];
        syncType = m.syncTarget;
        [p setDataSourceId:m.dataSourceId];
        [requestDatas addObject:[p build].dataStream];
    }
    
}

- (void) syncInTime:(SessionResponse*) wtr{
    SyncData* data = [SyncData parseFromData:wtr.data];
    if (data.customerCategories.count > 0) {
        [LOCALMANAGER saveCustomerCategories:data.customerCategories];
        [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_CUSTOMER_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.customerCategories.count]];
    }
    
    if (data.patrolCategories.count > 0) {
        [LOCALMANAGER savePatrolCategories:data.patrolCategories];
        [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_PATROL_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.patrolCategories.count]];
    }
    
    if (data.functions.count > 0) {
        [LOCALMANAGER saveFunctions:data.functions];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"sync_function_menu" object:nil];
    }
    
    if (data.competitionProducts.count > 0) {
        [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_COMPETITION_PRODUCT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.competitionProducts.count]];
        [LOCALMANAGER saveCompetitionProducts:data.competitionProducts];
    }
    
    if (data.products.count > 0){
        [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_PRODUCT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.products.count]];
        [LOCALMANAGER saveProducts:data.products];
    }
    
    if (data.departments.count > 0) {
        [LOCALMANAGER saveDepartments:data.departments];
    }
    
    if (data.giftProductCategories.count > 0) {
        [LOCALMANAGER saveGiftProductCategories:data.giftProductCategories];
    }
    
    if (data.applyCategories.count > 0) {
        [LOCALMANAGER saveApplyCategories:data.applyCategories];
    }
    
    if (data.giftProducts.count > 0) {
        [LOCALMANAGER saveGiftProducts:data.giftProducts];
    }
    
    if (data.users.count > 0) {
        [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.users.count]];
        //[LOCALMANAGER saveUsers:data.users];
        [LOCALMANAGER saveAllUsers:data.users];
    }
    
    if (data.attendanceCategories.count > 0) {
        [LOCALMANAGER saveAttendanceCategories:data.attendanceCategories];
    }
    
    if (data.holidayCategories.count > 0) {
        [LOCALMANAGER saveHolidayCategories:data.holidayCategories];
    }
    if (data.checkInShift.workingTime.length) {
        [LOCALMANAGER saveChenkInShift:data.checkInShift];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"syncCheckInShift" object:nil];
    }
    
    if (data.inspectionReportCategories.count > 0) {
        [LOCALMANAGER saveInspectionCategories:data.inspectionReportCategories];
    }
    
    if (data.inspectionTypes.count > 0) {
        [LOCALMANAGER saveInspectionTypes:data.inspectionTypes];
    }
    
    if (data.inspectionModels.count > 0) {
        [LOCALMANAGER saveInspectionModels:data.inspectionModels];
    }
    
    if (data.inspectionStatuses.count > 0) {
        [LOCALMANAGER saveInspectionStatus:data.inspectionStatuses];
    }
    
    if (data.inspectionTargets.count > 0) {
        [LOCALMANAGER saveInspectionTargets:data.inspectionTargets];
    }
    
    if (syncType != nil) {
        [LOCALMANAGER savePaperTemplates:data.paperTemplates];
         [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_PAPER_TEMPLE object:nil];
        
    }

    if (data.patrolMediaCategories.count > 0) {
        [LOCALMANAGER savePatrolMediaCategories:data.patrolMediaCategories];
        //通知巡访报告界面即时更新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_VIDEO_MEDIA object:nil];
    }
    
    if (data.patrolVideoDurationCategories.count > 0) {
        [LOCALMANAGER savePatrolVideoDurationCategories:data.patrolVideoDurationCategories];
        
    }
    if (data.attendanceTypes.count>0) {
        [LOCALMANAGER saveAttendanceTypes:data.attendanceTypes];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncAttendanceCatogry" object:nil];
    }
    
    if (data.hasCompany) {
        [LOCALMANAGER saveCompany:data.company];
        User_Builder* ub = [USER toBuilder];
        
        Company_Builder* cb = [USER.company toBuilder];
        [cb setId:data.company.id];
        [cb setName:data.company.name];
        [cb setIdea:data.company.idea];
        [cb setDesc:data.company.desc];
        if (data.company.filePath.count > 0) {
            NSArray* filePath = [[NSArray alloc] initWithObjects:[data.company.filePath objectAtIndex:0], nil];
            [cb setFilePathArray:filePath];
        }
        
        [ub setCompany:[cb build]];
        
        USER = [[ub build] retain];
        
    }
    
    if (data.hasSessionUser) {
//        User_Builder* ub = [data.sessionUser toBuilder];
//        [ub setPassword:[LOCALMANAGER getLoginUser].password];
//        User* u = [ub build];
//        [LOCALMANAGER saveLoginUser:u];
//        
//        ub = [data.sessionUser toBuilder];
//        [ub setPassword:pwd];
//        u = [ub build];
//        
//        USER = [u retain];
        [LOCALMANAGER saveUserPermission:data.sessionUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncAnnouceNotification" object:nil];
    }
    
    if (data.hasAppSetting) {
        [LOCALMANAGER saveValueToUserDefaults:KEY_APP_TITLE Value:data.appSetting.appTitle];
    }
    
    if (data.videoCategories.count > 0) {
        [LOCALMANAGER saveVideoCategories:data.videoCategories];
    }
    
    if (data.videoDurationCategories.count > 0) {
        [LOCALMANAGER saveVideoDurationCategories:data.videoDurationCategories];
    }
    
    if (data.productCategories.count > 0) {
        [LOCALMANAGER saveProductCategories:data.productCategories];
    }
    if (data.productSpecifications.count > 0) {
        [LOCALMANAGER saveProductSpecifications:data.productSpecifications];
    }
    if (data.customerTags.count > 0) {
        [LOCALMANAGER saveCustomerTags:data.customerTags];
    }
    
    //客户标签 与 产品规格选择个数 限 定
    if (data.systemSetting.customerTagQueryMax > 0) {
        [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.customerTagQueryMax] key:KEY_CUSTOMERTAG_MAX_COUNT];
    }
    if (data.systemSetting.customerTagValQueryMax > 0) {
        [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.customerTagValQueryMax] key:KEY_CUSTOMERTAG_COUNT];
    }
    if (data.systemSetting.prodSpecQueryMax > 0) {
        [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.prodSpecQueryMax] key:KEY_PRODUCT_SPEC_MAX_COUNT];
    }
    if (data.systemSetting.prodSpecValQueryMax > 0) {
        [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.prodSpecValQueryMax] key:KEY_PRODUCT_SPEC_COUNT];
    }
    
    /*2.0 不在同步中同步通讯录
     [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER_CONTACT Value:[NSString stringWithFormat:@"%d",cr.users.count]];
     [LOCALMANAGER saveAllUsers:cr.users];*/
}

- (void) pushMessage:(SessionResponse*) wtr{
    if (pushDelegate != nil && [pushDelegate respondsToSelector:@selector(receivePushMessage:)]) {
        [pushDelegate receivePushMessage:wtr];
    }
}


#pragma HTTP Request
//HTTP请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"request response status code:%d",request.responseStatusCode);
    [COOKIEHEPLER saveCookie];
    [self resetResponseData];
    switch (request.responseStatusCode) {
            //// 401 用户过期标识
        case 401:
        {
            SessionResponse_Builder* crb = [SessionResponse builder];
            [crb setSequence:[NSString UUID]];
            [crb setType:NS_ACTIONTYPE(sendRequestType)];
            [crb setCode:NS_ACTIONCODE(ActionCodeErrorAccountException)];
            [crb setResultMessage:NSLocalizedString(@"error_account_expired", nil)];
            [self webSocket:nil didReceiveMessage:[crb build].dataStream];
        }
            break;
        default:
            [self webSocket:nil didFailWithError:request.error];
            break;
    }
}

//返回HTTP头信息
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}

//返回HTTP数据
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

//HTTP请求成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"request.responseStatusCode:%d",request.responseStatusCode);
     [COOKIEHEPLER saveCookie];
    if (request.responseStatusCode == 502) {
        SessionResponse_Builder* crb = [SessionResponse builder];
        [crb setSequence:[NSString UUID]];
        [crb setType:NS_ACTIONTYPE(sendRequestType)];
        [crb setCode:NS_ACTIONCODE(ActionCodeErrorServer)];
        [crb setResultMessage:NSLocalizedString(@"server_bad_error", nil)];
        [self webSocket:nil didReceiveMessage:[crb build].dataStream];
        return;
    }
    
   NSData* decryptData = nil;
    @try {
        NSLog(@"response data length:%lu",(unsigned long)responseData.length);
        DataInputStream* inputStream = [DataInputStream dataInputStreamWithData:responseData];
        NSData* d = [inputStream readData];
        //解密返回数据
        decryptData = [d AES256DecryptedDataWithKey:[APP_KEY substringToIndex:16] iv:IV_KEY];
        SessionResponse* cr = [SessionResponse parseFromData:decryptData];
        NSLog(@"HTTP Request Finished.");
        NSLog(@"Session Response Code:%@",cr.code);
        if ([cr.code isEqual:NS_ACTIONCODE(ActionCodeErrorAccountException)]) {
            [self close];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"HTTP Request Failed:%@",exception.description);
        SessionResponse_Builder* crb = [SessionResponse builder];
        [crb setSequence:[NSString UUID]];
        [crb setType:NS_ACTIONTYPE(sendRequestType)];
        [crb setCode:NS_ACTIONCODE(ActionCodeErrorServer)];
        [crb setResultMessage:S_ERROR_SERVER];
        decryptData = [crb build].dataStream;
    }
    @finally {
        [self webSocket:nil didReceiveMessage:decryptData];
        [self resetResponseData];
    }
}

- (void)resetResponseData{
    [responseData resetBytesInRange:NSMakeRange(0, [responseData length])];
    [responseData setLength:0];
}

//设置用户过期
-(void) setUserExpire:(ExceptionMessage *)m{
    //改变用户有效状态
    [LOCALMANAGER setUserExpire:USER ExceptionMessage:m];
    //清理Cookie
    [COOKIEHEPLER clearCookie];
    //断开webSocket
    bRequesting = NO;
    [self close];
}

@end
