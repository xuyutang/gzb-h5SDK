//
//  SMWebSocket.h
//  SaleManager


#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "SRWebSocket.h"
#import "Reachability.h"
#import "Model.h"
#import "ASIHttpRequest.h"
@protocol AppBecomeActiveDelegate <NSObject>

- (void) appBeComeActive;

@end


@protocol PushDelegete <NSObject>

- (void) receivePushMessage:(WTResponse*) wtr;

@end

@protocol ActionCodeDelegate <NSObject>

- (void) didReceiveActionCode:(PBGeneratedMessage*) wtr;

@end

@protocol SMWebSocketDelegate <NSObject>

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocketDidRejected:(SRWebSocket *)webSocket;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@interface SMWebSocket : NSObject<SRWebSocketDelegate>{
    id<SMWebSocketDelegate> delegate;
    id<SMWebSocketDelegate> currentSocketDelegate;
    id<PushDelegete> pushDelegate;
    id<ActionCodeDelegate> actionDelegate;
    SRWebSocket *_webSocket;
    WTRequest* clientRequest;
    NSString* pwd;
    
    NSTimer *timer;
    BOOL bPingIsRuning;
    
    BOOL bRequesting;
    NSMutableArray *requestQueue;
    
    PBArray *receivedAnnounces;
    
    BOOL bUserIdChanged;
    BOOL bSyncInTime;
    
    NSDictionary* curRequest;
    
    NSMutableData* responseData;
}

@property(nonatomic,strong) SRWebSocket *webSocket;
@property(nonatomic,strong) WTRequest* clientRequest;
@property(nonatomic,strong) id<SMWebSocketDelegate> delegate;
@property(nonatomic,strong) id<PushDelegete> pushDelegate;
@property(nonatomic,strong) id<ActionCodeDelegate> actionDelegate;
@property(nonatomic,assign) int sendRequestType;
@property(nonatomic,assign) int recevieResultCode;
@property(nonatomic,assign) BOOL bUserIdChanged;
@property(nonatomic,assign) BOOL bRequesting;

- (REQUEST_STATUS) sendRequestWithType:(int)requestType param:(id)param;
-(id)loginWithUsername:(NSString *)username password:(NSString *)password;
-(void)close;
-(BOOL)isExistenceNetwork;
-(void)reconnect;
@end
