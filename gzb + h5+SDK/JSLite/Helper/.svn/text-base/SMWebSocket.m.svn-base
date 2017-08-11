                                                   //  SMWebSocket.m
//  SaleManager

#import <malloc/malloc.h>
#import "SMWebSocket.h"
#import "GlobalConstant.h"
#import "LocalManager.h"
#import "NSDate+Util.h"
#import "NSString+Helpers.h"
#import "UIDevice+Util.h"
#import "NSDate+Util.h"
#import "Product.h"
#import "ASIHTTPRequest.h"
#import "ASIHttpRequestDelegate.h"

#define NO_RECEIVE_CODE 10000
#define DIC_KEY_REQUESTTYPE @"requestType"
#define DIC_KEY_DELEGATE @"delegate"
#define DIC_KEY_PARAM @"param"
#define DIC_KEY_REQUESTTIME @"requestTime"

@implementation SMWebSocket
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

-(id)loginWithUsername:(NSString *)username password:(NSString *)password {
    pwd = [password copy];
    _webSocket.delegate = nil;
    [_webSocket close];
    if (_webSocket != nil){
        [_webSocket release];
        _webSocket = nil;
    }
    NSLog(@"Deivce model:%@",[UIDevice deviceModel]);
    NSLog(@"Device id:%@",[UIDevice deviceId]);
    NSLog(@"Device token:%@",[LOCALMANAGER getDeviceToken]);
    //_password = password;
    //_username = username;
    
    NSString* serverUrl = [[NSString stringWithFormat:@"%@?log=%@&pwd=%@&osVersion=%@&deviceType=%@&appVersion=%@&model=%@&deviceId=%@&vCode=%@&deviceToken=%@",WS_SERVER,username,password,[UIDevice osVersion],DEVICE_TYPE,[UIDevice appVersion],[UIDevice deviceModel],[UIDevice deviceId],[UIDevice bundleVersion],[LOCALMANAGER getDeviceToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"socket login URL:%@",serverUrl);
    NSURL* url = [NSURL URLWithString:serverUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    //NSString* timestamp = [NSDate stringFromDate:[NSDate date ] withFormat:[NSDate timestampFormatString]];
    //NSLog(@"timestamp:%@",timestamp);
    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString* token = [NSString stringWithFormat:@"%@%@%f",APP_KEY,APP_SECRET,timeInMiliseconds];
    
    NSLog(@"Request MD5 header:%@",token.md5);
    [request setValue:[NSString stringWithFormat:@"%f",timeInMiliseconds] forHTTPHeaderField:@"tokenTime"];
    [request setValue:token.md5 forHTTPHeaderField:@"token"];
    [request setValue:APP_KEY forHTTPHeaderField:@"appKey"];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    currentSocketDelegate = delegate;
    [_webSocket open];
    

    bRequesting = YES;
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
    
    return self;
}

-(void) close{
    while (bRequesting) {
        NSLog(@"waiting.....");
        sleep(1);
    }
    if (requestQueue != nil) {
        [requestQueue removeAllObjects];
        [requestQueue release];
        requestQueue = nil;
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
        [self loginWithUsername:u.v1.userName password:u.v1.password.sha256];
    }
}

-(REQUEST_STATUS) sendRequestWithType:(int)requestType param:(id)param{
    if (USER == nil) {
        return WEBSOCKET_NOT_OPEN;
    }
    //NSLog(@"socket status code:%d",_webSocket.readyState);
    sendRequestType = requestType;
    recevieResultCode = NO_RECEIVE_CODE;
    
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
    }

    
    //如果有网络请求正在进行，就进入队列等待；
    if (param == nil) {
        param = @"";
    }
    
    //判断请求是否存在
    BOOL bRequestInQueue = FALSE;
    NSLog(@"curRequest:%d,requestType:%d",curRequest == nil ? -1 : [[curRequest objectForKey:DIC_KEY_REQUESTTYPE] intValue],requestType);
    if (curRequest == nil || ([[curRequest objectForKey:DIC_KEY_REQUESTTYPE] intValue] != requestType)) {
        bRequestInQueue = TRUE;
    }
    for (int i = 0; i < requestQueue.count; ++i) {
        NSDictionary* dic = [requestQueue objectAtIndex:i];
        if ([[dic objectForKey:DIC_KEY_REQUESTTYPE] intValue] == requestType) {
            return DONE;
        }
        bRequestInQueue = TRUE;
    }
    
    if (!bRequestInQueue) {
        return DONE;
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:requestType],DIC_KEY_REQUESTTYPE,param,DIC_KEY_PARAM,delegate,DIC_KEY_DELEGATE, nil];
    //NSLog(@"request param dict = %@",[dict description]);
    [requestQueue addObject:dict];
    [dict release];
    
    return DONE;
}

-(void)requestTimer{
    if (USER == nil || _webSocket.readyState != SR_OPEN) {
        return;
    }
    if (bRequesting || (requestQueue.count<=0)){
        if (curRequest != nil) {
            NSLog(@"socket is requesting...");
            NSString* curRequestType = NS_REQUESTTYPE([(NSNumber *)[curRequest objectForKey:DIC_KEY_REQUESTTYPE] intValue]);
            NSLog(@"socket current requesting type:%@",curRequestType);
            NSDate* requestTime = [NSDate dateFromString:[curRequest objectForKey:DIC_KEY_REQUESTTIME]];
            NSLog(@"socket current requset time:%@",requestTime);
            NSTimeInterval late = [requestTime timeIntervalSince1970];
            NSTimeInterval now = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            
            if ((now-late) > 60){
                ASIHTTPRequest* req = [[ASIHTTPRequest alloc] init];
                req.error = [NSError errorWithDomain:[NSString stringWithFormat:@"request type %@ time out",curRequestType] code:60 userInfo:nil];
                [self requestFailed:req];
            }
        }
        
        return;
    }
    
    int tryTimes = 0;
    while (_webSocket.readyState != SR_OPEN) {
        if (tryTimes == 3) {
            return ;
        }
        ++tryTimes;
        sleep(1);
    }
    bRequesting = YES;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[requestQueue objectAtIndex:0]];
    //NSLog(@"execute param dict = %@",[dict description]);
    [requestQueue removeObjectAtIndex:0];
    
    int requestType = [(NSNumber *)[dict objectForKey:DIC_KEY_REQUESTTYPE] intValue];
    id param = [dict objectForKey:DIC_KEY_PARAM];
    currentSocketDelegate = [dict objectForKey:DIC_KEY_DELEGATE];
    
    //当前正在运行的请求
    curRequest = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:requestType],DIC_KEY_REQUESTTYPE,param,DIC_KEY_PARAM,currentSocketDelegate,DIC_KEY_DELEGATE,[NSDate getCurrentDateTime],DIC_KEY_REQUESTTIME, nil];
    
    
    NSData *dtRequest = nil;
    
    Device_Builder* db = [Device builder];
    DeviceV1_Builder* dv1 = [DeviceV1 builder];
    [dv1 setAppVersion:[UIDevice appVersion]];
    [dv1 setAppVersionCode:[UIDevice bundleVersion].intValue];
    [dv1 setDeviceType:DEVICE_TYPE];
    [dv1 setModel:[UIDevice model]];
    [dv1 setDeviceId:[UIDevice deviceId]];
    [dv1 setDeviceToken:[LOCALMANAGER getDeviceToken]];
    [db setVersion:dv1.version];
    [db setV1:[dv1 build]];
    Device* d = [db build];
    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString* tokenStr = [NSString stringWithFormat:@"%@%@%f",APP_KEY,APP_SECRET,timeInMiliseconds];

    Token_Builder* tb = [Token builder];
    [tb setToken:tokenStr.md5];
    [tb setTokenTime:[NSString stringWithFormat:@"%f",timeInMiliseconds]];
    [tb setAppKey:APP_KEY];
    Token* token = [tb build];
    
    LoginTokenV1_Builder* ltvb = [LoginTokenV1 builder];
    LoginToken_Builder* ltb = [LoginToken builder];
    [ltvb setToken:tokenStr.md5];
    [ltvb setTokenTime:[NSString stringWithFormat:@"%f",timeInMiliseconds]];
    [ltvb setAppKey:APP_KEY];
    [ltb setVersion:ltvb.version];
    [ltb setV1:[ltvb build]];
    LoginToken* loginToken = [ltb build];
    
    switch (requestType) {
        case RequestTypeLoginV1:
        {
            ;
        }
            break;
        case RequestTypeUserInfoGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeUserInfoGetV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((UserParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeCountDataGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCountDataGetV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((CountParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeAttendanceCategoryListV1:{
            
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAttendanceCategoryListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case   RequestTypeCustomerListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCustomerListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((CustomerParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeAttendanceSaveV1:{
        
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAttendanceSaveV1)];
            [crb setSequence:[NSString UUID]];

            [crb setSessionUser:USER];
            [crb setDevice:d];

            [crb setData:((Attendance*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        case RequestTypeAttendanceGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAttendanceGetV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((AttendanceParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeWorklogSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeWorklogSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((WorkLog*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeWorklogListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeWorklogListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((WorkLogParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
            
        case RequestTypeChangePwdV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeChangePwdV1)];
            [crb setSequence:[NSString UUID]];
            [crb setData:((User*)param).dataStream];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeStockSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeStockSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((Stock*)param).dataStream ];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeStockListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeStockListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((StockParams*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeSalegoodsSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeSalegoodsSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((SaleGoods*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeSalegoodsListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeSalegoodsListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((SaleGoodsParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeOrdergoodsSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeOrdergoodsSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((OrderGoods*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeOrdergoodsListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeOrdergoodsListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((OrderGoodsParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        case RequestTypeCompetitiongoodsSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCompetitiongoodsSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((CompetitionGoods*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeCompetitiongoodsListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCompetitiongoodsListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((CompetitionGoodsParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;

        case RequestTypeMessageListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMessageListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            SysMessageParams* m = (SysMessageParams*)param;
            [crb setData:m.dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeAnnounceListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAnnounceListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            AnnounceParams* m = (AnnounceParams*)param;
            [crb setData:m.dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypePatrolSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypePatrolSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((Patrol*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeAttendanceReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAttendanceReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((AttendanceReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypePatrolReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypePatrolReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((PatrolReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypePatrolListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypePatrolListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((PatrolParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        
        case RequestTypeFavSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeFavSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((FavData *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        case RequestTypeAttendanceListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAttendanceListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((AttendanceParams*)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeWorklogReplyV1 :{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeWorklogReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((WorkLogReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];

        }
            break;
        
        case RequestTypeLocationSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeLocationSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((Location *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];

        }
            break;
        case RequestTypeMarketresearchReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMarketresearchReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((MarketResearchReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;

        case RequestTypeMarketresearchSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMarketresearchSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((MarketResearch*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeMarketresearchListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMarketresearchListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((MarketResearchParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;

            
        case RequestTypeBusinessopportunitySaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeBusinessopportunitySaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];;
            [crb setData:((BusinessOpportunity *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeBusinessopportunityListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeBusinessopportunityListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];;
            [crb setData:((BusinessOpportunityParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeBusinessopportunityReplyV1 :{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeBusinessopportunityReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];;
            [crb setData:((BusinessOpportunityReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
            
        }
            break;

        case RequestTypeAnnounceAckV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeAnnounceAckV1)];
            [crb setSequence:[NSString UUID]];
            [crb setDatasArray:(NSArray *)param ];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeMessageAckV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMessageAckV1)];
            [crb setSequence:[NSString UUID]];
            [crb setDatasArray:(NSArray *)param];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeWorklogGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeWorklogGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((WorkLogParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        case RequestTypeMarketresearchGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMarketresearchGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((MarketResearchParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }

            break;
        case RequestTypePatrolGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypePatrolGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((PatrolParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }

            break;

        case RequestTypeSyncBaseDataV1:
        {
            bSyncInTime = FALSE;
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeSyncBaseDataV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            if ([param isKindOfClass:[NSArray class]]) {
                [crb setDatasArray:((NSArray*)param)];
                bSyncInTime = TRUE;
            }
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeSyncCustomerListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeSyncCustomerListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setData:((CustomerParams *)param).dataStream];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeCompanyspaceCategoryListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCompanyspaceCategoryListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        case RequestTypeCompanyspaceListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCompanyspaceListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((CompanySpaceParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeBusinessopportunityGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeBusinessopportunityGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((BusinessOpportunityParams *) param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        
        //申请保存
        case RequestTypeApplyItemSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeApplyItemSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((ApplyItem*)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];

        }
            break;
        //申请批复保存
        case RequestTypeApplyItemReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeApplyItemReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((ApplyItemReply *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];

        }
            break;
        //获取申请列表
        case RequestTypeApplyItemListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeApplyItemListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setData:((ApplyItemParams *)param).dataStream];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取申请单详情
        case RequestTypeApplyItemGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeApplyItemGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((ApplyItemParams *)param).dataStream ];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
            
        }
            break;
        //赠品采购
        case RequestTypeGiftPurchaseSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftPurchaseSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftPurchase *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品采购列表
        case RequestTypeGiftPurchaseListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftPurchaseListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftPurchaseParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品采购详情
        case RequestTypeGiftPurchaseGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftPurchaseGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftPurchaseParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //赠品配送保存
        case RequestTypeGiftDeliverySaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDeliverySaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDelivery *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品配送列表
        case RequestTypeGiftDeliveryListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDeliveryListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDeliveryParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品配送详情
        case RequestTypeGiftDeliveryGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDeliveryGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDeliveryParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //赠品发放保存
        case RequestTypeGiftDistributeSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDistributeSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDistribute *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品发放列表
        case RequestTypeGiftDistributeListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDistributeListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDistributeParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品发放详情
        case RequestTypeGiftDistributeGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftDistributeGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftDistributeParams *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //赠品盘库保存
        case RequestTypeGiftStockSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftStockSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftStock *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品盘库列表
        case RequestTypeGiftStockListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftStockListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftStockParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取赠品盘库详情
        case RequestTypeGiftStockGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeGiftStockGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((GiftStockParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
            
        //获取巡检列表
        case RequestTypeInspectionReportListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeInspectionReportListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((InspectionReportParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取巡检详情
        case RequestTypeInspectionReportGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeInspectionReportGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((InspectionReportParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //巡检保存
        case RequestTypeInspectionReportSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeInspectionReportSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((InspectionReport *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        case RequestTypeInspectionReportReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeInspectionReportReplyV1)];
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setSequence:[NSString UUID]];
            [crb setData:((InspectionReportReply *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取巡访任务列表
        case RequestTypeTaskPatrolListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeTaskPatrolListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取巡访任务详情
        case RequestTypeTaskPatrolGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeTaskPatrolGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolDetailParams *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //保存巡访任务
        case RequestTypeTaskPatrolDetailSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeTaskPatrolDetailSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolDetail *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取我的任务列表
        case RequestTypeMyTaskPatrolListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMyTaskPatrolListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolParams *)param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取巡访任务详情
        case RequestTypeMyTaskPatrolGetV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeMyTaskPatrolGetV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolDetailParams *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //批复巡访任务
        case RequestTypeTaskPatrolReplyV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeTaskPatrolReplyV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolReply *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //更新用户信息
        case RequestTypeUserInfoUpdateV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeUserInfoUpdateV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((User *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //保存客户
        case RequestTypeCustomerSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCustomerSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((Customer *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //保存用户登录、登出信息
        case RequestTypeUserLogSaveV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeUserLogSaveV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((UserLog *) param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取周边人员
        case RequestTypeUserListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeUserListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((UserParams *) param).dataStream];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取企业通讯录
        case RequestTypeCompanyContactListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeCompanyContactListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取工作日志回复列表
        case RequestTypeWorklogReplyListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeWorklogReplyListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((WorkLogParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取巡访报告回复列表
        case RequestTypePatrolReplyListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypePatrolReplyListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((PatrolParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取申请回复列表
        case RequestTypeApplyItemReplyListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeApplyItemReplyListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((ApplyItemParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取任务回复列表
        case RequestTypeTaskPatrolReplyListV1:{
            WTRequest_Builder* crb = [WTRequest builder];
            [crb setType:NS_REQUESTTYPE(RequestTypeTaskPatrolReplyListV1)];
            [crb setSequence:[NSString UUID]];
            
            [crb setSessionUser:USER];
            [crb setDevice:d];
            [crb setData:((TaskPatrolParams *)param).dataStream];
            
            [crb setLoginToken:loginToken];
            WTRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //保存视频
        case ActionTypeVideoTopicSaveV1:{
            SessionRequest_Builder* crb = [SessionRequest builder];
            [crb setType:NS_ACTIONTYPE(ActionTypeVideoTopicSaveV1)];
            [crb setSequence:[NSString UUID]];
            [crb setParam:SUSER.dataStream];
            [crb setData:((VideoTopicV1 *) param).dataStream];
            [crb setToken:token];
            SessionRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取视频列表
        case ActionTypeVideoTopicListV1:{
            SessionRequest_Builder* crb = [SessionRequest builder];
            [crb setType:NS_ACTIONTYPE(ActionTypeVideoTopicListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setParam:SUSER.dataStream];
            [crb setData:((VideoTopicParamsV1 *)param).dataStream];
            [crb setToken:token];
            SessionRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取视频详情
        case ActionTypeVideoTopicGetV1:{
            SessionRequest_Builder* crb = [SessionRequest builder];
            [crb setType:NS_ACTIONTYPE(ActionTypeVideoTopicGetV1)];
            [crb setSequence:[NSString UUID]];
            [crb setParam:SUSER.dataStream];
            [crb setData:((VideoTopicParamsV1 *) param).dataStream];
            [crb setToken:token];
            SessionRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //获取视频回复列表
        case ActionTypeVideoTopicReplyListV1:{
            SessionRequest_Builder* crb = [SessionRequest builder];
            [crb setType:NS_ACTIONTYPE(ActionTypeVideoTopicReplyListV1)];
            [crb setSequence:[NSString UUID]];
            [crb setParam:SUSER.dataStream];
            [crb setData:((VideoTopicParamsV1 *)param).dataStream];
            [crb setToken:token];
            SessionRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        //批复视频
        case ActionTypeVideoTopicReplyV1:{
            SessionRequest_Builder* crb = [SessionRequest builder];
            [crb setType:NS_ACTIONTYPE(ActionTypeVideoTopicReplyV1)];
            [crb setSequence:[NSString UUID]];
            [crb setParam:SUSER.dataStream];
            [crb setData:((VideoTopicReplyV1 *) param).dataStream];
            [crb setToken:token];
            SessionRequest* cr = [crb build];
            
            dtRequest = [cr dataStream];
        }
            break;
        default:
            break;
    }
    
    if (dtRequest !=  nil){
        NSLog(@"socket send request type:%@",NS_REQUESTTYPE(requestType));
        NSLog(@"socket send data length:%lu",(unsigned long)dtRequest.length);
        [_webSocket send:dtRequest];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [self resetCurRequest];
    
    NSLog(@"socket open code:%d",_webSocket.readyState);
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [currentSocketDelegate webSocketDidOpen:webSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    [self resetCurRequest];
    
    NSLog(@"socket close with code:%ld",(long)code);
    NSLog(@"socket close reason:%@",reason);
    
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(webSocket: didCloseWithCode:reason:wasClean:)]) {
        [currentSocketDelegate webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    [self resetCurRequest];
    
    //测试HTTP
    NSData* recData = (NSData*)message;
    NSString* str = [[NSString alloc] initWithData:recData encoding:NSUTF8StringEncoding];
    NSLog(@"response string:%@",str);
    
    bRequesting = NO;
    
    //2.1版本新功能返回为SessionResponse
    WTResponse* cr = nil;
    SessionResponse* sr = nil;
    @try {
        cr = [WTResponse parseFromData:(NSData*)message];
    }
    @catch (NSException *exception) {
        sr = [SessionResponse parseFromData:(NSData *)message];
        if (![sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
            if (actionDelegate != nil && [actionDelegate respondsToSelector:@selector(didReceiveActionCode:)]) {
                [actionDelegate didReceiveActionCode:sr];
            }
            return;
        }
    }
    if (sr != nil) {
        if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(webSocket: didReceiveMessage:)]) {
            [currentSocketDelegate webSocket:webSocket didReceiveMessage:message];
        }
        return;
    }
    
    //2.0版本处理
    NSLog(@"socket receive data size = %@ Kb",[NSString stringWithFormat:@"%.2f",((float)((NSData*)message).length / 1024)]);
    recevieResultCode = (int)INT_RESULTCODE(cr.code);
    NSLog(@"socket response type:%@,response code:%@",cr.type,cr.code);
    
    //账户异常或应用异常
    if ([cr.code isEqual:NS_RESULTCODE(ResultCodeResponseErrorAppException)] || [cr.code isEqual:NS_RESULTCODE(ResultCodeResponseErrorAccountException)] || [cr.code isEqual:NS_ACTIONCODE(ActionCodeErrorAppException)] || [cr.code isEqual:NS_ACTIONCODE(ActionCodeErrorAccountException)]) {
        [self cleanUser:cr];
    }
    //消息
    if (([cr.type isEqual:NS_REQUESTTYPE(RequestTypePushMsg)] && [cr.code isEqual:NS_RESULTCODE(ResultCodeResponseDone)]) || ([cr.type isEqual:NS_ACTIONTYPE(ActionTypePushMsg)] && [cr.code isEqual:NS_ACTIONTYPE(ActionCodeDone)])) {
        NSMutableArray* messageSeqs = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray* requestDatas = [[[NSMutableArray alloc] init] autorelease];
        if (cr.hasData) {
            WTMessage* wtm = [WTMessage parseFromData:cr.data];
            if ([self validateMessage:cr WTMsg:wtm]) {
                WTMessage* t = [[[[wtm toBuilder] clearBody] clearHeader] build];
                [messageSeqs addObject:t.dataStream];
                
                [self parseMessage:wtm RequestDatas:requestDatas];
            }
        }else{
            for (int i = 0; i < cr.datas.count; ++i) {
                WTMessage* wtm = [WTMessage parseFromData:[cr.datas objectAtIndex:i]];
                if ([self validateMessage:cr WTMsg:wtm]) {
                    WTMessage* t = [[[[wtm toBuilder] clearBody] clearHeader] build];
                    [messageSeqs addObject:t.dataStream];
                    
                    [self parseMessage:wtm RequestDatas:requestDatas];
                }
            }
        }
        if (messageSeqs.count > 0) {
            [self sendRequestWithType:RequestTypeMessageAckV1 param:messageSeqs];
        }
        if (requestDatas.count > 0){
            [self sendRequestWithType:RequestTypeSyncBaseDataV1 param:requestDatas];
        }

        [self pushMessage:cr];
    }
    //更新用户信息
    if (((INT_REQUESTTYPE(cr.type) == RequestTypeUserInfoUpdateV1) && ([cr.code isEqual: NS_RESULTCODE(ResultCodeResponseDone)])) || ((INT_ACTIONTYPE(cr.type) == ActionTypeUserInfoUpdateV1) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]))){
        User* crUser = [User parseFromData:cr.data];
        if (crUser.v1.avatars.count > 0) {
            User_Builder* ub = [USER toBuilder];
            UserV1_Builder *ubv1 = [ub.v1 toBuilder];
            
            [ubv1 setAvatarsArray:[[NSArray alloc] initWithObjects:[crUser.v1.avatars objectAtIndex:0], nil]];
            [ub setVersion:ubv1.version];
            [ub setV1:[ubv1 build]];
            User* u = [ub build];
            USER = [u retain];
        }
        
    }
    //实时同步消息
    if ((([cr.type isEqual:NS_REQUESTTYPE(RequestTypeSyncBaseDataV1)]) && ([cr.code isEqual:NS_RESULTCODE(ResultCodeResponseDone)]) && bSyncInTime) || (([cr.type isEqual:NS_ACTIONTYPE(ActionTypeSyncBaseDataV1)]) && ([cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) && bSyncInTime)) {
        [self syncInTime:cr];
        [self pushMessage:cr];
    }
    //发送登录日志
    if ((([cr.type isEqual:NS_REQUESTTYPE(RequestTypeLoginV1)] ) && ([cr.code isEqual:NS_RESULTCODE(ResultCodeResponseDone)])) || (([cr.type isEqual:NS_ACTIONTYPE(ActionTypeLoginV1)] ) && ([cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]))){
        [USER release];
        USER = nil;
        
        [SUSER release];
        SUSER = nil;
        
//        //开启请求任务阶列
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(requestTimer)
                                       userInfo:nil
                                        repeats:YES];
        
        //2.0服务端返回用户过期信息
        //验证当用户更换了企业，需要强制用户重新登录
        User* crUser = [User parseFromData:cr.data];
        NSLog(@"return userid:%d",crUser.v1.id);
        NSLog(@"return local userid:%d",[LOCALMANAGER getLoginUser].v1.id);
        if ([LOCALMANAGER getLoginUser].v1.id != 0) {
            
            if (crUser.v1.id != [LOCALMANAGER getLoginUser].v1.id){
                NSLog(@"UserId Changed!");
                bUserIdChanged = TRUE;
            }
        }
        
        if (!bPingIsRuning){
            [NSTimer scheduledTimerWithTimeInterval:PINGDURATION
                                     target:self
                                   selector:@selector(sendPing)
                                   userInfo:nil
                                    repeats:YES];
        }
        
        if (USER == nil){
            User_Builder* ub = [crUser toBuilder];
            UserV1_Builder *ubv1 = [ub.v1 toBuilder];
            [ubv1 setPassword:pwd];
            [ub setVersion:ubv1.version];
            [ub setV1:[ubv1 build]];
            User* u = [ub build];
            USER = [u retain];
            
            //2.1采用SessionUser
            UserDevice_Builder* db = [UserDevice builder];
            [db setAppVersion:[UIDevice appVersion]];
            [db setAppVersionCode:[UIDevice bundleVersion].intValue];
            [db setDeviceType:DEVICE_TYPE];
            [db setModel:[UIDevice model]];
            [db setDeviceId:[UIDevice deviceId]];
            [db setOsVersion:[UIDevice osVersion]];
            [db setDeviceToken:[LOCALMANAGER getDeviceToken]];
            UserDevice* d = [db build];
            
            SessionUser_Builder* sub = [SessionUser builder];
            [sub setId:USER.v1.id];
            [sub setUserName:USER.v1.userName];
            [sub setPassword:USER.v1.password];
            [sub setRealName:USER.v1.realName];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i < USER.v1.avatars.count; i++) {
                [array addObject:[USER.v1.avatars objectAtIndex:i]];
            }
            [sub setAvatarsArray:array];
            [sub setDevice:d];
            SessionUser* su = [sub build];
            SUSER = [su retain];
        }
        
        [self pushMessage:cr];
    }
    //数据交由代理处理
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(webSocket: didReceiveMessage:)]) {
        if (bUserIdChanged) {
            [LOCALMANAGER cleanLoginUser];
            WTResponse_Builder* crb = [WTResponse builder];
            [crb setSequence:[NSString UUID]];
            [crb setType:cr.type];
            [crb setCode:NS_RESULTCODE(ResultCodeResponseErrorAccountException)];
            
            [currentSocketDelegate webSocket:webSocket didReceiveMessage:[crb build].dataStream];

        }else{
            if ((([cr.type isEqual:NS_REQUESTTYPE(RequestTypeSyncBaseDataV1)]) && ([cr.code isEqual:NS_RESULTCODE(ResultCodeResponseDone)]) && bSyncInTime) || (([cr.type isEqual:NS_ACTIONTYPE(ActionTypeSyncBaseDataV1)]) && ([cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) && bSyncInTime)) {
                return;
            }
            [currentSocketDelegate webSocket:webSocket didReceiveMessage:message];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    [self resetCurRequest];
    
    NSLog(@"socket fail code:%d",_webSocket.readyState);
    NSLog(@"socket fail reason:%@",error);
    bRequesting = NO;
    if ((sendRequestType == RequestTypeAnnounceListV1) || (sendRequestType == RequestTypeMessageListV1)){
        return;
    }
    
    if (currentSocketDelegate != nil && [currentSocketDelegate respondsToSelector:@selector(webSocket: didFailWithError:)]) {
        [currentSocketDelegate webSocket:webSocket didFailWithError:error];
    }
}

- (void) sendPing{
    bPingIsRuning = TRUE;
    if (_webSocket.readyState != SR_OPEN)
        return;

    //NSData* aData = [@"" dataUsingEncoding:NSASCIIStringEncoding];
    [_webSocket sendPing:@""];
    
   // NSLog(@"============send ping");
}

- (void) cleanUser:(WTResponse*) cr{
    if (pushDelegate != nil && [pushDelegate respondsToSelector:@selector(receivePushMessage:)]) {
        //账号过期，清除本地所有数据
        [USER release];
        USER = nil;
        [LOCALMANAGER cleanLoginUser];
        [pushDelegate receivePushMessage:cr];
    }
    return;
}

- (BOOL) validateMessage:(WTResponse*) wtr WTMsg:(WTMessage*) wtm{
    if ([wtm.header.v1.messageType isEqual:NS_MESSAGETYPE(MessageTypeException)]) {
        [self cleanUser:wtr];
        return FALSE;
    }
    return TRUE;
}

- (void) parseMessage:(WTMessage*) wtm RequestDatas:(NSMutableArray*) requestDatas{
    if ([wtm.header.v1.messageType isEqual:NS_MESSAGETYPE(MessageTypeService)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeService));
        [LOCALMANAGER saveMessage:wtm];
    }
    if ([wtm.header.v1.messageType isEqual:NS_MESSAGETYPE(MessageTypeAnnounce)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeAnnounce));
        Announce* a = [Announce parseFromData:wtm.body.content];
        [LOCALMANAGER saveAnnounce:a];
    }
    if ([wtm.header.v1.messageType isEqual:NS_MESSAGETYPE(MessageTypeSyncdata)]) {
        NSLog(@"MessageType:%@",NS_MESSAGETYPE(MessageTypeSyncdata));
        SyncDataMessage* m = [SyncDataMessage parseFromData:wtm.body.content];
        
        SyncDataParams_Builder* p = [SyncDataParams builder];
        SyncDataParamsV1_Builder* pv1 = [SyncDataParamsV1 builder];
        [pv1 setSyncType:m.v1.syncType];
        [pv1 setSyncTarget:m.v1.syncTarget];
        [pv1 setDataSourceId:m.v1.dataSourceId];
        [p setVersion:pv1.version];
        [p setV1:[pv1 build]];
        [requestDatas addObject:[p build].dataStream];
    }

}

- (void) syncInTime:(WTResponse*) wtr{
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
    
    if (data.hasCompany) {
        [LOCALMANAGER saveCompany:data.company];
        User_Builder* ub = [USER toBuilder];
        UserV1_Builder *ubv1 = [USER.v1 toBuilder];
        
        Company_Builder* cb = [USER.v1.company toBuilder];
        CompanyV1_Builder* cbv1 = [USER.v1.company.v1 toBuilder];
        [cbv1 setId:data.company.v1.id];
        [cbv1 setName:data.company.v1.name];
        [cbv1 setIdea:data.company.v1.idea];
        [cbv1 setDesc:data.company.v1.desc];
        if (data.company.v1.filePath.count > 0) {
            NSArray* filePath = [[NSArray alloc] initWithObjects:[data.company.v1.filePath objectAtIndex:0], nil];
            [cbv1 setFilePathArray:filePath];
        }
        [cb setVersion:cbv1.version];
        [cb setV1:[cbv1 build]];

        [ubv1 setCompany:[cb build]];
        [ub setVersion:ubv1.version];
        [ub setV1:[ubv1 build]];
        
        USER = [[ub build] retain];
        
    }
    
    if (data.hasSessionUser) {
        User_Builder* ub = [data.sessionUser toBuilder];
        UserV1_Builder *ubv1 = [ub.v1 toBuilder];
        [ubv1 setPassword:[LOCALMANAGER getLoginUser].v1.password];
        [ub setVersion:ubv1.version];
        [ub setV1:[ubv1 build]];
        User* u = [ub build];
        [LOCALMANAGER saveLoginUser:u];
        
        ub = [data.sessionUser toBuilder];
        ubv1 = [ub.v1 toBuilder];
        [ubv1 setPassword:pwd];
        [ub setVersion:ubv1.version];
        [ub setV1:[ubv1 build]];
        u = [ub build];
        
        USER = [u retain];
    }
    
    if (data.hasAppSetting) {
        [LOCALMANAGER saveValueToUserDefaults:KEY_APP_TITLE Value:data.appSetting.v1.appTitle];
    }
    
    if (data.videoCategories.count > 0) {
        [LOCALMANAGER saveVideoCategories:data.videoCategories];
    }
    
    if (data.videoDurationCategories.count > 0) {
        [LOCALMANAGER saveVideoDurationCategories:data.videoDurationCategories];
    }
    /*2.0 不在同步中同步通讯录
     [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER_CONTACT Value:[NSString stringWithFormat:@"%d",cr.users.count]];
     [LOCALMANAGER saveAllUsers:cr.users];*/
}

- (void) pushMessage:(WTResponse*) wtr{
    if (pushDelegate != nil && [pushDelegate respondsToSelector:@selector(receivePushMessage:)]) {
        [pushDelegate receivePushMessage:wtr];
    }
}

- (void)resetCurRequest{
    if (curRequest != nil) {
        [curRequest release];
        curRequest = nil;
    }
}

//HTTP请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    [self resetCurRequest];
    [self resetResponseData];
    [self webSocket:nil didFailWithError:request.error];
}

//返回HTTP头信息
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{

}

//返回HTTP数据
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    [self resetCurRequest];
    [responseData appendData:data];
}

//HTTP请求成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    //NSData* data = [responseData subdataWithRange:NSMakeRange(4, responseData.length - 4)];
    [self webSocket:nil didReceiveMessage:responseData];
    NSLog(@"requestFinished");
    
    [self resetResponseData];
}

- (void)resetResponseData{
    [responseData resetBytesInRange:NSMakeRange(0, [responseData length])];
    [responseData setLength:0];
}


@end
