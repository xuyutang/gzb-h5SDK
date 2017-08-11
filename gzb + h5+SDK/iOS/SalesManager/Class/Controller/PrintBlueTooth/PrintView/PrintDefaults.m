//
//  PrintDefaults.m
//  BlueTooth
//
//  Created by Administrator on 16/3/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "PrintDefaults.h"

static PrintDefaults *mainPrintDefaults;
static NSString      *kPrintKey = @"kPrintKey";

@implementation PrintDefaults


+(instancetype) mainPrintDefaults{
    static dispatch_once_t printDefaultsOnce;
    dispatch_once(&printDefaultsOnce, ^{
        mainPrintDefaults = [[PrintDefaults alloc] init];
    });
    return mainPrintDefaults;
}

-(NSArray*) getList{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kPrintKey];
}

-(void) savePrint:(NSString *) uuid{
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:[self getList]];
    if (![tmpList containsObject:uuid]) {
        [tmpList addObject:uuid];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tmpList forKey:kPrintKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) clearAll{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPrintKey];
}


@end
