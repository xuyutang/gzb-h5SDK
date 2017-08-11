//
//  PrintDefaults.h
//  BlueTooth
//
//  Created by Administrator on 16/3/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintDefaults : NSObject

+(instancetype) mainPrintDefaults;

-(NSArray *) getList;

-(void) savePrint:(NSString *) uuid;

-(void) clearAll;
@end
