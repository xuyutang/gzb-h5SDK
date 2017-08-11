//
//  DataReportModel.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/25.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,DataReportType) {
    TEXT = 0,
    DIGITAL = 1,
    DATE = 2,
    RADIO = 3,
    CHECKBOX = 4,
    PHOTO_LIVE = 5,
    PHOTO_ANY = 6,
    CUSTOMER = 7
};

@interface DataReportModel : NSObject

@property (nonatomic ,assign) DataReportType TYPE;

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger templateId;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)int sn;
@property (nonatomic, assign)BOOL allowNull;
@property (nonatomic, copy)NSMutableArray *options;



@property (nonatomic, copy)NSString *textString;
@property (nonatomic, copy)NSString *radioValueString;
@property (nonatomic, copy)NSString *radioIdString;
@property (nonatomic, assign)NSMutableArray *boxchoseIdArray;
@property (nonatomic, assign)NSMutableArray *boxchoseValueArray;
@property (nonatomic, copy)NSString *custName;
@property (nonatomic, copy)NSString *custId;

@property (nonatomic, copy)NSString *signTime;
@property (nonatomic ,copy)NSString *imagepath;
@property (nonatomic,copy) NSMutableArray *imageMulArray;

@end

