//
//  HolidayListParams.h
//  SalesManager
//
//  Created by iOS-Dev on 16/11/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolidayListParams : NSObject

@property (nonatomic,retain)   NSString* queryUserRealName;
@property (nonatomic,assign) int holidayCatId;
@property (nonatomic,retain) NSString *startTime;
@property (nonatomic,retain) NSString *endTime;
@property (nonatomic,retain) NSString *departmentIds;

@end
