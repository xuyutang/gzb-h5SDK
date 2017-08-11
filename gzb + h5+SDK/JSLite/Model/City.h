//
//  City.h
//  Club
//
//  Created by ZhangLi on 13-12-13.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Province : NSObject

@property(nonatomic,assign) int id;
@property(nonatomic,retain) NSString *name;
@end

@interface City : NSObject

@property(nonatomic,assign) int id;
@property(nonatomic,assign) int provinceId;
@property(nonatomic,retain) NSString *name;
@end

@interface Area : NSObject

@property(nonatomic,assign) int id;
@property(nonatomic,assign) int provinceId;
@property(nonatomic,retain) NSString *name;

@end
