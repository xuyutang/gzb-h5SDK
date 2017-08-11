//
//  DataReportModel.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/25.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DataReportModel.h"

@implementation DataReportModel

-(NSMutableArray*)imageMulArray {
    if (_imageMulArray == nil) {
        _imageMulArray = [[NSMutableArray alloc]init];
    }
    return _imageMulArray;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
