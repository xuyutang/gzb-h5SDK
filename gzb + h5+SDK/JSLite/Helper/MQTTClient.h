//
//  MQTTClient.h
//  JSLite
//
//  Created by liuxueyan on 7/5/14.
//  Copyright (c) 2014 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@protocol MQTTClientDelegate

- (void) didConnect: (NSUInteger)code;
- (void) didDisconnect;
- (void) didPublish: (NSUInteger)messageId;

- (void) didReceiveMessage: (SessionResponse*)response;
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos;
- (void) didUnsubscribe: (NSUInteger)messageId;

@end


@interface MQTTClient : NSObject{
    struct mosquitto *mosq;
    NSString *host;
    unsigned short port;
    NSString *username;
    NSString *password;
    unsigned short keepAlive;
    BOOL cleanSession;
    
    id<MQTTClientDelegate> delegate;
    NSTimer *timer;
}

@property (readwrite,retain) NSString *host;
@property (readwrite,assign) unsigned short port;
@property (readwrite,retain) NSString *username;
@property (readwrite,retain) NSString *password;
@property (readwrite,assign) unsigned short keepAlive;
@property (readwrite,assign) BOOL cleanSession;
@property (readwrite,assign) id<MQTTClientDelegate> delegate;

+ (void) initialize;
+ (NSString*) version;

- (MQTTClient*) initWithClientId: (NSString *)clientId;
- (void) setMessageRetry: (NSUInteger)seconds;
- (void) connect;
- (void) connectToHost: (NSString*)host;
- (void) connectToHost:(NSString *)_host
                 port:(unsigned short)_port
             username:(NSString *)_username
             password:(NSString *)_password
            keepAlive:(unsigned short)_keepAlive
         cleanSession:(BOOL)_cleanSession
             delegate:(id)_delegate;
- (void) reconnect;
- (void) disconnect;

- (void)setWill: (NSString *)payload toTopic:(NSString *)willTopic withQos:(NSUInteger)willQos retain:(BOOL)retain;
- (void)clearWill;

- (void)publishString: (NSString *)payload toTopic:(NSString *)topic withQos:(NSUInteger)qos retain:(BOOL)retain;

- (void)subscribe: (NSString *)topic;
- (void)subscribe: (NSString *)topic withQos:(NSUInteger)qos;
- (void)unsubscribe: (NSString *)topic;


// This is called automatically when connected
- (void) loop: (NSTimer *)timer;


@end
