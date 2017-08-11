//
//  NSString+Util.h
//  JSLite
//
//  Created by ZhangLi on 2014/02/18.
// //

#import <Foundation/Foundation.h>

//数字
#define NUM @"0123456789"
//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface NSString (Util)

- (bool)isEmpty;
- (NSString *)trim;
- (NSNumber *)numericValue;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)onlyNumAndAlpha:(NSString *)string;
+ (NSString *)countNumAndChangeformat:(NSString *)num;

//朱康 2016-01-06 17:14:41（不兼容 iOS6）
/**
*返回值是该字符串所占的大小(width, height)
*font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
*maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
*/
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//根据宽度返回高度
-(CGSize)rebuildSizeWtihContentWidth:(double)width FontSize:(double)fontsize;
@end

@interface NSObject (NumericValueHack)
- (NSNumber *)numericValue;

@end