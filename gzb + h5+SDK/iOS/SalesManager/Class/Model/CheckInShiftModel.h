//
//  CheckInShiftModel.h
//  SalesManager
//
//  Created by iOS-Dev on 16/12/8.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInShiftModel : NSObject
@property(nonatomic,retain)NSString *end;
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *sn;
@property(nonatomic,retain)NSString *start;

@property(nonatomic,assign)int stutus;
@property(nonatomic,strong)CheckInShiftGroup *group;
@property(nonatomic,assign)int checkInType;
@property(nonatomic,retain)NSString *checkInDat;

@property(nonatomic,retain)NSString *checkInTime;
@property(nonatomic,assign)int checkInAbnormal;
@property(nonatomic,retain)NSString *remark;
@end
