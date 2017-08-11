//
//  FileHelper.m
//  JSLite
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 Juicyshare. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper


+(NSString *)getFileSize:(NSString *)filePath{
    NSLog(@"url:%@",filePath);
    NSFileManager* fileManager = [[[NSFileManager alloc] init] autorelease];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary* fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSNumber* fileSize;
        if ((fileSize = [fileDic valueForKey:NSFileSize])) {
            NSString* strSize = @"";
            if (fileSize.intValue / 1024 > 1024) {
                float s = fileSize.intValue / 1024 / 1024;
                strSize = [NSString stringWithFormat:@"%.1fMB",s];
            }else{
                strSize = [NSString stringWithFormat:@"%dKB",fileSize.intValue / 1024];
            }
            return strSize;
        }
    }
    return @"-1";
}

+(NSString *) formartFileSizeToString:(int) size{
    NSString* strSize = @"";
    if (size / 1024 > 1024) {
        float s = size / 1024 / 1024;
        strSize = [NSString stringWithFormat:@"%.1fMB",s];
    }else{
        strSize = [NSString stringWithFormat:@"%dKB",size / 1024];
    }
    return strSize;
}

+(NSString *)getVideoSeconds:(NSString *)videPath
{
    return nil;
}
@end
