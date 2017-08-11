//
//  UIView+Util.h
//  JSLite
//
//  Created by 章力 on 15/5/26.
//  Copyright (c) 2015年 Juicyshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)
+ (void)removeAllSubViews:(UIView *)parentView;
+ (UIView *)assembleMessage : (NSString *) message;
+ (UIImage *)fitSmallImage:(UIImage *)image;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+(UIImage *)addText:(UIImage *)img text:(NSString *)text1;
+(UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo;


//朱康 2015-10-12 09:41:22 透明渐变移除视图
+(void) removeViewFormSubViews:(int) index views:(NSArray*) views;
//朱康 2015-10-16 17:00:22 透明渐变载入视图
+(void) addSubViewToSuperView:(UIView*) superView subView:(UIView*) subView;
+ (UIViewController *)findViewController:(UIView *)sourceView;
@end
