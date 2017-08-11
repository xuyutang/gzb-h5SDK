//
//  UIImage+JSLite.m
//  JSLite
//
//  Created by ZhangLi on 14-2-18.
//  Copyright (c) 2014年 Juicyshare. All rights reserved.
//

#import "UIImage+JSLite.h"
#import "NSBundle+JSLite.h"

@implementation UIImage (JSLite)

+ (UIImage *) JSLiteImageNamed:(NSString*)name{
    UIImage *imageFromMainBundle = [UIImage imageNamed:name];
    if (imageFromMainBundle) {
        return imageFromMainBundle;
    }
    
    UIImage *imageFromJSLiteBundle = [UIImage imageWithContentsOfFile:[[[NSBundle JSLiteResourcesBundle] resourcePath] stringByAppendingPathComponent:name]];
    return imageFromJSLiteBundle;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
