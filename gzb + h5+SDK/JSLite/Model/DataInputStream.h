//
//  DataInputStream.h
//  JSLite
//
//  Created by 章力 on 15/12/21.
//  Copyright © 2015年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

// 从输入流读取基本数据类型的方法，以便解组自定义值类型
@interface DataInputStream : NSObject {
    NSData *data;
    NSInteger length;
}

//
- (id)initWithData:(NSData *)data;

//
+ (id)dataInputStreamWithData:(NSData *)aData;

// 从输入流读取 char 值。
- (int8_t)readChar;

//从输入流读取 short 值。
- (int16_t)readShort;

//从输入流读取 int 值。
- (int32_t)readInt;

//从输入流读取 long 值。
- (int64_t)readLong;

//从输入流读取 NSString 字符串。
- (NSString *)readUTF;

//从输入流中读取NSData。
- (NSData* )readData;

@end
