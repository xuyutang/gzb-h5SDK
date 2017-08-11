//
//  UTStatusInfoItem.m
//  30iMonitor
//
//  Created by KK UI on 13-2-21.
//  Copyright (c) 2013年 30iMonitor. All rights reserved.
//

#import "UTStatusInfoItem.h"
#import "TTCorePreprocessorMacros.h"

@implementation UTStatusInfoItem
@synthesize caption = _caption;
@synthesize detaisText = _detaisText;
@synthesize timestamp = _timestamp;
@synthesize statusInfo = _statusInfo;

- (void)dealloc {
    [super dealloc];
    
    TT_RELEASE_SAFELY(_caption);
    TT_RELEASE_SAFELY(_detaisText);
    TT_RELEASE_SAFELY(_timestamp);
    TT_RELEASE_SAFELY(_statusInfo);
}

+ (id)itemWithCaption:(NSString *)caption
              details:(NSString *)details
            timestamp:(NSString *)timestamp
               status:(NSString *)statusInfo {

    UTStatusInfoItem *item = [[[UTStatusInfoItem alloc] init] autorelease];
    item.caption = caption;
    item.detaisText = details;
    item.timestamp = timestamp;
    item.statusInfo = statusInfo;
    
    return item;
}

@end
