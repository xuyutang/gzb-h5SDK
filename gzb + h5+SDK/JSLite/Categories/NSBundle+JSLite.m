//
//  NSBundle+JSLite.m
//  JSLite
//
//  Created by ZhangLi on 14-2-18.
//  Copyright (c) 2014年 Juicyshare. All rights reserved.
//

#import "NSBundle+JSLite.h"

@implementation NSBundle (JSLite)

+ (NSBundle*)JSLiteResourcesBundle {
    static dispatch_once_t onceToken;
    static NSBundle *jsliteResourcesBundle = nil;
    dispatch_once(&onceToken, ^{
        jsliteResourcesBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JSLiteResources" withExtension:@"bundle"]];
    });
    return jsliteResourcesBundle;
}

+ (NSString *)JSLocalizedString:(NSString*) key Comment:(NSString*) comment{
    return [[NSBundle JSLiteResourcesBundle] localizedStringForKey:key value:key table:nil];
}

@end
