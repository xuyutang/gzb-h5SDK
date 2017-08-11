//
//  ProgressHUDView.m
//  KK UI
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProgressHUDView.h"
#import "MBProgressHUD.h"

#define kDefaultAutoHideTimeInterval    1.5f

static ProgressHUDView *g_HUDInstance = nil;

@implementation ProgressHUDView

@synthesize progressHUD = progressHUD_;

- (MBProgressHUD *) progressHUD {
    if (nil == progressHUD_) {
        progressHUD_ = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] delegate].window];
        [[[UIApplication sharedApplication] delegate].window addSubview:progressHUD_];
    }
    
    return progressHUD_;
}



+(id)alloc {
	@synchronized([ProgressHUDView class])
	{
		NSAssert(g_HUDInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		g_HUDInstance = [super alloc];
		return g_HUDInstance;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
    
    }
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

+ (id) standardInstance {
	
	@synchronized([ProgressHUDView class])
	{
		if (!g_HUDInstance)
			[[self alloc] init];
		
		return g_HUDInstance;
	}
	
	return nil;
}

+ (void) cleanup {
	[g_HUDInstance release];
}

- (void) showTextWithPendingState:(NSString *) text autoHide:(BOOL) shouldAutoHide {
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.labelText = text;
    [self.progressHUD show:YES];
}

- (void) showTextWithSucceedState:(NSString *) text autoHide:(BOOL) shouldAutoHide {
 
    self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.labelText = text;
    
    if (self.progressHUD.alpha == 0.f) 
        [self.progressHUD show:YES];
    
    if (shouldAutoHide) 
        [self.progressHUD hide:YES afterDelay:kDefaultAutoHideTimeInterval];
}

- (void) showTextWithFailureState:(NSString *) text autoHide:(BOOL) shouldAutoHide {

    self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]] autorelease];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.labelText = text;
    
    if (self.progressHUD.alpha == 0.f) 
        [self.progressHUD show:YES];
    
    if (shouldAutoHide) 
        [self.progressHUD hide:YES afterDelay:kDefaultAutoHideTimeInterval];
}

+ (void) showPendingText:(NSString *) text inView:(UIView *) v {

    MBProgressHUD *hudView = [ProgressHUDView hudInView:v];    
    
    if (hudView == nil) {
        hudView = [MBProgressHUD showHUDAddedTo:v animated:YES];
        //hudView.removeFromSuperViewOnHide = YES;
    }

    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = text;
    if (hudView.alpha == 0.f) {
        [hudView show:YES];
    }
}
+ (void) showFailureText:(NSString *) text inView:(UIView *) v 
                autoHide:(BOOL) shouldAutoHide {
    
    MBProgressHUD *hudView = [ProgressHUDView hudInView:v];    
    if (hudView == nil) {
        hudView = [MBProgressHUD showHUDAddedTo:v animated:YES];
        //hudView.removeFromSuperViewOnHide = YES;
    }

    hudView.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]] autorelease];
    hudView.mode = MBProgressHUDModeCustomView;
    hudView.labelText = text;
    if (hudView.alpha == 0.f) {
        [hudView show:YES];
    }

        
    if (shouldAutoHide) 
        [hudView hide:YES afterDelay:kDefaultAutoHideTimeInterval];
    
}

+ (void) showSucceedText:(NSString *) text inView:(UIView *) v 
                autoHide:(BOOL) shouldAutoHide {

    MBProgressHUD *hudView = [ProgressHUDView hudInView:v];    
    if (hudView == nil) {
        hudView = [MBProgressHUD showHUDAddedTo:v animated:YES];
        //hudView.removeFromSuperViewOnHide = YES;
    }

    hudView.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hudView.mode = MBProgressHUDModeCustomView;
    hudView.labelText = text;
    if (hudView.alpha == 0.f) {
        [hudView show:YES];
    }

        
    if (shouldAutoHide) 
        [hudView hide:YES afterDelay:kDefaultAutoHideTimeInterval];
}

+ (void) hideHudInView:(UIView *) v {
    [MBProgressHUD hideHUDForView:v animated:NO];
}

+ (UIView *) keyboardSuperview {
    UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        return win1.windowLevel - win2.windowLevel;
        }] lastObject];
    UIView *topView = [[topWindow subviews] lastObject];
    if (topView.superview) {
        return topView.superview;
    }else {
        return [[UIApplication sharedApplication] keyWindow];
    }
}

+ (void) setYOffset:(CGFloat) y inView:(UIView *) v {
    MBProgressHUD *hudView = [ProgressHUDView hudInView:v];    
    if (hudView != nil) {
        [hudView setYOffset:y];
        [hudView layoutSubviews];
    }
}

+ (void) setRect:(CGRect) rect inView:(UIView *) v {
    MBProgressHUD *hudView = [ProgressHUDView hudInView:v];
    if (hudView != nil) {
        hudView.frame = rect;
    }
}

+ (MBProgressHUD *) hudInView:(UIView *) v {
    MBProgressHUD *hudView = nil;
	for (UIView *view in [v subviews]) {
		if ([view isKindOfClass:[MBProgressHUD class]]) {
			hudView = (MBProgressHUD *)view;
            break;
		}
	}
    
    return hudView;
}


@end
