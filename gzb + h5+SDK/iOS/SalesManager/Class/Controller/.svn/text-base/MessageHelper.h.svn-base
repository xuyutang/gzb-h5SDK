//
//  MessageHelper.h
//  SalesManager
//
//  Created by liuxueyan on 5/6/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "SMWebSocket.h"

@interface MessageHelper : NSObject{
    OrderGoodsParams *ogParams;
    StockParams* sParams;
    SaleGoodsParams* sgParams;
    CompetitionGoodsParams *cgParams;
}

+(MessageHelper*)sharedInstance;
-(void)showMessageWithId:(int)messageType  objectId:(int)id source:(NSString *)source;


@end
