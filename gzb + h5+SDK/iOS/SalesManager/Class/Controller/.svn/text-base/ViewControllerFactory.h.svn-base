//
//  ViewControllerFactory.h
//  Club
//
//  Created by ZhangLi on 13-12-4.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ViewControllerFactory : NSObject{
}
+ (ViewControllerFactory*) sharedInstance;

- (void) create:(UINavigationController*) nav ViewId:(int) viewId Object:(id)obj Delegate:(id)delegate NeedBack:(BOOL) needBack;
- (void) showMessageWithId:(UINavigationController*) nav MessageType:(int)messageType  objectId:(SysMessage*)objectId  Delegate:(id)delegate;
@end
