//
//  NSBundle+JSLite.h
//  JSLite
//
//  Created by ZhangLi on 14-2-18.
//  Copyright (c) 2014年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (JSLite)

+ (NSBundle *) JSLiteResourcesBundle;
+ (NSString *) JSLocalizedString:(NSString*) key Comment:(NSString*) comment;
@end
