//
//  PaperPostModel.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaperPostModel : NSObject

@property (nonatomic, copy)NSString *fieldId;
@property (nonatomic, copy)NSString *fieldName;
@property (nonatomic, copy)NSString *fieldValue;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)int sn;
@property (nonatomic, copy)NSString *fieldValueName;


@end
