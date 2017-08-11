//
//  ProgressHUDView.h
//  KK UI
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define PROGRESSHUD [ProgressHUDView standardInstance]

@interface ProgressHUDView : NSObject {
    MBProgressHUD       *progressHUD_;
}

@property (nonatomic, retain, readonly) MBProgressHUD   *progressHUD;

/*
 *	Get instance
 */
+ (id) standardInstance;

/*
 *	Clean up
 */
+ (void) cleanup;

/**
 *  Show HUD with activity indicator and text
 */
- (void) showTextWithPendingState:(NSString *) text autoHide:(BOOL) shouldAutoHide;

/**
 *  Shows succeed state HUD
 */
- (void) showTextWithSucceedState:(NSString *) text autoHide:(BOOL) shouldAutoHide;

/**
 *  Shows failure statue HUD
 */
- (void) showTextWithFailureState:(NSString *) text autoHide:(BOOL) shouldAutoHide;

+ (void) showPendingText:(NSString *) text inView:(UIView *) v;
+ (void) showFailureText:(NSString *) text inView:(UIView *) v autoHide:(BOOL) shouldAutoHide;
+ (void) showSucceedText:(NSString *) text inView:(UIView *) v autoHide:(BOOL) shouldAutoHide;

+ (void) hideHudInView:(UIView *) v;

/**
 *  Return keyboard superview
 */
+ (UIView *) keyboardSuperview;

/**
 *  Set hud view y offset
 */
+ (void) setYOffset:(CGFloat) y inView:(UIView *) v;

/**
 *  Set frame of hudview
 *  default frame is super view's frame
 */
+ (void) setRect:(CGRect) rect inView:(UIView *) v;

/**
 *  Search hud view in superview
 */
+ (MBProgressHUD *) hudInView:(UIView *) v;

@end
