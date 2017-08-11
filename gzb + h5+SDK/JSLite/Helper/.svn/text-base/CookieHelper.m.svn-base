//
//  CookieHelper.m
//  JSLite
//
//  Created by Administrator on 16/3/19.
//  Copyright © 2016年 Juicyshare. All rights reserved.
//

#import "CookieHelper.h"
#import "Product.h"

static NSString *KCookeAuthor = @"cookie_author";
static NSString *kCookieOthor = @"cookie_othor";

static NSString *kUUS = @"WTUSS";
static NSString *kUUID = @"WTUID";

static CookieHelper *mainCookieHelper;

@implementation CookieHelper

+(instancetype)mainCookieHepler{
    static dispatch_once_t cookieOnce;
    dispatch_once(&cookieOnce, ^{
        mainCookieHelper = [[CookieHelper alloc] init];
    });
    return mainCookieHelper;
}

-(NSMutableArray*)getCookie{
    //封装Cookies
    NSMutableArray *cookie_author = [[NSUserDefaults standardUserDefaults] valueForKey:KCookeAuthor];
    NSMutableArray *cookie_other = [[NSUserDefaults standardUserDefaults] valueForKey:kCookieOthor];
    NSMutableArray *tmpCookie = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in cookie_author) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{
                                                                    NSHTTPCookieName:dic[NSHTTPCookieName],
                                                                    NSHTTPCookieValue:dic[NSHTTPCookieValue],
                                                                    NSHTTPCookiePath:dic[NSHTTPCookiePath],
                                                                    NSHTTPCookieDomain:dic[NSHTTPCookieDomain]
                                                                    }];
        NSLog(@"Cookie domain:%@",cookie.domain);
        if ([cookie.domain isEqualToString:SERVER_DOMAIN]) {
            [tmpCookie addObject:cookie];
        }
    }
    for (NSMutableDictionary *dic in cookie_other) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{
                                                                    NSHTTPCookieName:dic[NSHTTPCookieName],
                                                                    NSHTTPCookieValue:dic[NSHTTPCookieValue],
                                                                    NSHTTPCookiePath:dic[NSHTTPCookiePath],
                                                                    NSHTTPCookieDomain:dic[NSHTTPCookieDomain]
                                                                    }];
        //[tmpCookie addObject:cookie];
    }
    return tmpCookie;
}

-(void) setCookie{
    NSMutableArray *tmpArr = [self getCookie];
    for (NSHTTPCookie *item in tmpArr) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:item];
    }
}


//缓存本地
-(void)saveCookie{
    //缓存验证Cookie
    NSHTTPCookieStorage *mgr = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookie_author = [[NSMutableArray alloc] init];
    NSMutableArray *cookie_other = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *i in mgr.cookies) {
        NSLog(@"HTTP Cookies:%@",i);
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        [p setObject:i.name forKey:NSHTTPCookieName];
        [p setObject:i.value forKey:NSHTTPCookieValue];
        [p setObject:i.path forKey:NSHTTPCookiePath];
        [p setObject:i.domain forKey:NSHTTPCookieDomain];
        if ([i.domain isEqualToString:SERVER_DOMAIN]) {
            if ([i.name isEqualToString:kUUS] || [i.name isEqualToString:kUUID]) {
                [cookie_author addObject:p];
            }
        }
        else{
            [cookie_other addObject:p];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:cookie_other forKey:kCookieOthor];
    if (cookie_author.count > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:cookie_author forKey:KCookeAuthor];
    }
}

-(void)clearCookie{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCookieOthor];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KCookeAuthor];
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
