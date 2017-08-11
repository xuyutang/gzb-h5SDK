//
//  NSData+AES.h
//  JSLite
//
//  Created by 章力 on 15/12/21.
//  Copyright © 2015年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES256EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES256DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
@end
