//
//  RequestAgent.h
//  JSLite
//
//  Created by 章力 on 15/12/23.
//  Copyright © 2015年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "Reachability.h"
#import "Model.h"
#import "ASIHttpRequest.h"
#import "ASIHttpRequestDelegate.h"
#import "SRWebSocket.h"

@protocol AppBecomeActiveDelegate <NSObject>

- (void) appBeComeActive;

@end


@protocol PushDelegete <NSObject>

- (void) receivePushMessage:(SessionResponse*) wtr;

@end

@protocol ActionCodeDelegate <NSObject>

- (void) didReceiveActionCode:(PBGeneratedMessage*) wtr;

@end

@protocol RequestAgentDelegate <NSObject>
- (void) didReceiveMessage:(id)message;
- (void) didFailWithError:(NSError *)error;
- (void) didRejected;
- (void) didOpen;
- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@interface RequestAgent : NSObject<SRWebSocketDelegate,ASIHTTPRequestDelegate>{
    id<RequestAgentDelegate> delegate;
    id<RequestAgentDelegate> currentSocketDelegate;
    id<PushDelegete> pushDelegate;
    id<ActionCodeDelegate> actionDelegate;
    SRWebSocket *_webSocket;
    SessionRequest* clientRequest;
    NSString* pwd;
    
    NSTimer *timer;
    BOOL bPingIsRuning;
    
    BOOL bRequesting;
    NSMutableArray *requestQueue;
    
    PBArray *receivedAnnounces;
    
    BOOL bUserIdChanged;
    BOOL bSyncInTime;
    
   // NSDictionary* curRequest;
    
    NSMutableData* responseData;
    dispatch_queue_t    agentQueue;
    NSString *syncType;
    
}

@property(nonatomic,strong) SRWebSocket *webSocket;
@property(nonatomic,strong) SessionRequest* clientRequest;
@property(nonatomic,strong) id<RequestAgentDelegate> delegate;
@property(nonatomic,strong) id<PushDelegete> pushDelegate;
@property(nonatomic,strong) id<ActionCodeDelegate> actionDelegate;
@property(nonatomic,assign) int sendRequestType;
@property(nonatomic,assign) int recevieResultCode;
@property(nonatomic,assign) BOOL bUserIdChanged;
@property(nonatomic,assign) BOOL bRequesting;

- (REQUEST_STATUS) sendRequestWithType:(int)requestType param:(id)param;
-(void)loginWithUsername:(NSString *)username password:(NSString *)password;
-(void)close;
-(BOOL)isExistenceNetwork;
-(void)reconnect;


//设置用户过期
-(void) setUserExpire:(ExceptionMessage *)m;
@end
