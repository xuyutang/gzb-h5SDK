//
//  UIImage+RemoteSize.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-16.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);

@interface UIImage (RemoteSize)

+ (void) requestSizeFor: (NSURL*) imgURL completion: (UIImageSizeRequestCompleted) completion;

@end
