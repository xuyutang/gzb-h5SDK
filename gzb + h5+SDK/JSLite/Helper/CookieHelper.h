//
//  CookieHelper.h
//  JSLite
//
//  Created by Administrator on 16/3/19.
//  Copyright © 2016年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COOKIEHEPLER [CookieHelper mainCookieHepler]

@interface CookieHelper : NSObject

+(instancetype) mainCookieHepler;

//缓存用户认证COOKIE
-(void) saveCookie;

//清除认证COOKIE
-(void) clearCookie;

-(void) setCookie;

-(NSMutableArray*) getCookie;
@end
