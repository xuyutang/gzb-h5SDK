//
//  UTPreferentialItem.m
//  KK UI
//
//  Created by KK UI on 12-12-10.
//
//

#import "UTPreferentialItem.h"
#import "TTCorePreprocessorMacros.h"

@implementation UTPreferentialItem
@synthesize caption = _caption;
@synthesize details = _details;
@synthesize target = _target;

+ (id)itemWithCaption:(NSString *)caption details:(NSString *)details target:(id)target {
    UTPreferentialItem *item = [[[UTPreferentialItem alloc] init] autorelease];
    item.caption = caption;
    item.details = details;
    item.target = target;
    
    return item;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_caption);
    TT_RELEASE_SAFELY(_details);
    [super dealloc];
}

@end
