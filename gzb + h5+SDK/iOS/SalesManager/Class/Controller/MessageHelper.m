//
//  MessageHelper.m
//  SalesManager
//
//  Created by liuxueyan on 5/6/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "MessageHelper.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "WorklogDetailViewController.h"
#import "NSDate+Util.h"
#import "OrderListViewController.h"
#import "PatrolDetailViewController.h"
#import "ResearchDetailViewController.h"
#import "BusinessOpportunityDetailViewController.h"
#import "StockListViewController.h"
#import "CompetitionListViewController.h"
#import "SaleListViewController.h"
#import "ApplyDetailViewController.h"
#import "GiftDeliveryDetailViewController.h"
#import "GiftDistributeDetailViewController.h"
#import "GiftPurchaseDetailViewController.h"
#import "GiftStockDetailViewController.h"
#import "AttendanceDetailViewController.h"
#import "InspectionDetailViewController.h"
#import "TaskDetailViewController.h"
#import "TaskListViewController.h"
#import "TaskPageViewController.h"

@implementation MessageHelper

+(MessageHelper*)sharedInstance{
    static MessageHelper* sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MessageHelper alloc] init];
    });
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    return self;
}

-(void)showMessageWithId:(int)messageType  objectId:(int)objectId source:(NSString*)source{
        
    switch(messageType){
            
        case MESSAGE_TASK_PATROL_APPROVAL:{
            TaskDetailViewController *vctrl = [[TaskDetailViewController alloc] init];
            vctrl.taskId = source;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
            [APPDELEGATE.drawerController presentModalViewController:patrolNavCtrl animated:YES];
            [patrolNavCtrl release];
            [vctrl release];
        }
            break;
        case MESSAGE_TASK_PATROL_FINISH:
        case MESSAGE_TASK_PATROL_ADD:{
            TaskPageViewController *vctrl = [[TaskPageViewController alloc] init];
            vctrl.showPageIndex = 2;
            vctrl.bFromMessage = YES;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
            [APPDELEGATE.drawerController presentModalViewController:patrolNavCtrl animated:YES];
            [patrolNavCtrl release];
            [vctrl release];
        }
            break;
        case MESSAGE_INSPECTION_APPROVAL:
        case MESSAGE_INSPECTION_DETAIL:{
            InspectionDetailViewController *ctrl = [[InspectionDetailViewController alloc] init];
            ctrl.inspection = nil;
            ctrl.inspectionId = objectId;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:patrolNavCtrl animated:YES];
            [patrolNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_DAILY_REPORT:
        case MESSAGE_DAILY_APPROVAL:{
            WorklogDetailViewController *ctrl = [[WorklogDetailViewController alloc] init];
            ctrl.worklog = nil;
            ctrl.worklogId = objectId;
            UINavigationController* worklogNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:worklogNavCtrl animated:YES];
            [worklogNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_VIVID_REPORT_APPROVAL:
        case MESSAGE_VIVID_REPORT:{
            PatrolDetailViewController *ctrl = [[PatrolDetailViewController alloc] init];
            ctrl.patrol = nil;
            ctrl.patrolId = objectId;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:patrolNavCtrl animated:YES];
            [patrolNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_MARKET_APPROVAL:
        case MESSAGE_MARKET_REPORT:{
            ResearchDetailViewController *ctrl = [[ResearchDetailViewController alloc] init];
            ctrl.currentMarketResearch = nil;
            ctrl.martketresearchId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
            
        case MESSAGE_BUSINESS_APPROVAL:
        case MESSAGE_BUSINESS_REPORT:{
            BusinessOpportunityDetailViewController *ctrl = [[BusinessOpportunityDetailViewController alloc] init];
            ctrl.currentBizOpp = nil;
            ctrl.bizoppId = objectId;
            UINavigationController* bizNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:bizNavCtrl animated:YES];
            [bizNavCtrl release];
            [ctrl release];
        }
            break;
            
            
        case MESSAGE_APPLY_ITEM_APPROVAL:
        case MESSAGE_APPLY_ITEM:{
            ApplyDetailViewController *ctrl = [[ApplyDetailViewController alloc] init];
            ctrl.applyItem = nil;
            ctrl.applyItemId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_PURCHASE:{
            GiftPurchaseDetailViewController *ctrl = [[GiftPurchaseDetailViewController alloc] init];
            ctrl.giftPurchase = nil;
            ctrl.giftPurchaseId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_DISTRIBUTE:{
            GiftDistributeDetailViewController *ctrl = [[GiftDistributeDetailViewController alloc] init];
            ctrl.giftDistribute = nil;
            ctrl.giftDistributeId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_DELIVERY:{
            GiftDeliveryDetailViewController *ctrl = [[GiftDeliveryDetailViewController alloc] init];
            ctrl.giftDelivery = nil;
            ctrl.giftDeliveryId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_STOCK:{
            GiftStockDetailViewController *ctrl = [[GiftStockDetailViewController alloc] init];
            ctrl.giftStock = nil;
            ctrl.giftStockId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_ATTENDANCE_APPROVAL:{
            AttendanceDetailViewController *ctrl = [[AttendanceDetailViewController alloc] init];
            ctrl.attendance = nil;
            ctrl.attendanceId = objectId;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.drawerController presentModalViewController:resNavCtrl animated:YES];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
            
        case MESSAGE_CARGO_REQ:{
            NSString *fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
            NSString *toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];
            
            Customer_Builder *customer = [Customer builder];
            CustomerV1_Builder* cv1 = [CustomerV1 builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
            CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            [tmpCategory setVersion:ccv1.version];
            [tmpCategory setV1:[ccv1 build]];
            
            [cv1 setCategory:[tmpCategory build]];
            [customer setVersion:cv1.version];
            [customer setV1:[cv1 build]];
            
            Customer*   currentCustomer = [[customer build] retain];
            //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
            OrderGoodsParams_Builder* pbparam = [OrderGoodsParams builder];
            OrderGoodsParamsV1_Builder* ogv1 = [OrderGoodsParamsV1 builder];
            BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
            if (currentCustomer.v1.id == -1) {
                [bsv1 setCustomerCategoryArray:[[NSArray alloc] initWithObjects:currentCustomer.v1.category, nil]];
            }else{
                [bsv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer, nil]];
            }
            
            [bsv1 setStartDate:fromTime];
            [bsv1 setEndDate:toTime];
            [ogv1 setBaseParams:[bsv1 build]];
            [pbparam setVersion:ogv1.version];
            [pbparam setV1:[ogv1 build]];
            
            ogParams = [[pbparam build] retain];
            
            if (ogParams != nil){
                OrderGoodsParams_Builder* pbparam = [ogParams toBuilder];
                OrderGoodsParamsV1_Builder* pbparamv1 = [pbparam.v1 toBuilder];
                BaseSearchParamsV1_Builder* bsv1 = [pbparamv1.baseParams toBuilder];
                [bsv1 setPage:1];
                [pbparamv1 setBaseParams:[bsv1 build]];
                [pbparam setVersion:pbparamv1.version];
                [pbparam setV1:[pbparamv1 build]];
                ogParams = [[pbparam build] retain];
                
                OrderListViewController *ctrl = [[OrderListViewController alloc] init];
                ctrl.orderArray = nil;
                ctrl.ogParams = ogParams;
            
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.drawerController presentModalViewController:orderNavCtrl animated:YES];
                [orderNavCtrl release];
                [ctrl release];

            }
        }
            break;
            
        case MESSAGE_INVENTORY:{
            NSString *fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
            NSString *toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];
            
            Customer_Builder *customer = [Customer builder];
            CustomerV1_Builder* cv1 = [CustomerV1 builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
            CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            [tmpCategory setVersion:ccv1.version];
            [tmpCategory setV1:[ccv1 build]];
            
            [cv1 setCategory:[tmpCategory build]];
            [customer setVersion:cv1.version];
            [customer setV1:[cv1 build]];
            
            Customer*   currentCustomer = [[customer build] retain];
            //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
            StockParams_Builder* pbparam = [StockParams builder];
            StockParamsV1_Builder* ogv1 = [StockParamsV1 builder];
            BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
            if (currentCustomer.v1.id == -1) {
                [bsv1 setCustomerCategoryArray:[[NSArray alloc] initWithObjects:currentCustomer.v1.category, nil]];
            }else{
                [bsv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer, nil]];
            }
            
            [bsv1 setStartDate:fromTime];
            [bsv1 setEndDate:toTime];
            [ogv1 setBaseParams:[bsv1 build]];
            [pbparam setVersion:ogv1.version];
            [pbparam setV1:[ogv1 build]];
            
            sParams = [[pbparam build] retain];
            
            if (sParams != nil){
                StockParams_Builder* pbparam = [sParams toBuilder];
                StockParamsV1_Builder* pbparamv1 = [pbparam.v1 toBuilder];
                BaseSearchParamsV1_Builder* bsv1 = [pbparamv1.baseParams toBuilder];
                [bsv1 setPage:1];
                [pbparamv1 setBaseParams:[bsv1 build]];
                [pbparam setVersion:pbparamv1.version];
                [pbparam setV1:[pbparamv1 build]];
                sParams = [[pbparam build] retain];
                
                StockListViewController *ctrl = [[StockListViewController alloc] init];
                ctrl.stockArray = nil;
                ctrl.sParams = sParams;
                
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.drawerController presentModalViewController:orderNavCtrl animated:YES];
                [orderNavCtrl release];
                [ctrl release];
            }

        }
            break;
            
        case MESSAGE_TODAY_SALE_REQ:{
            NSString *fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
            NSString *toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];
    
            Customer_Builder *customer = [Customer builder];
            CustomerV1_Builder* cv1 = [CustomerV1 builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
            CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            [tmpCategory setVersion:ccv1.version];
            [tmpCategory setV1:[ccv1 build]];
            
            [cv1 setCategory:[tmpCategory build]];
            [customer setVersion:cv1.version];
            [customer setV1:[cv1 build]];
            
            Customer*   currentCustomer = [[customer build] retain];
            //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
            SaleGoodsParams_Builder* pbparam = [SaleGoodsParams builder];
            SaleGoodsParamsV1_Builder* ogv1 = [SaleGoodsParamsV1 builder];
            BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
            if (currentCustomer.v1.id == -1) {
                [bsv1 setCustomerCategoryArray:[[NSArray alloc] initWithObjects:currentCustomer.v1.category, nil]];
            }else{
                [bsv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer, nil]];
            }
            
            [bsv1 setStartDate:fromTime];
            [bsv1 setEndDate:toTime];
            [ogv1 setBaseParams:[bsv1 build]];
            [pbparam setVersion:ogv1.version];
            [pbparam setV1:[ogv1 build]];
            
            sgParams = [[pbparam build] retain];
            
            if (sgParams != nil){
                SaleGoodsParams_Builder* pbparam = [sgParams toBuilder];
                SaleGoodsParamsV1_Builder* pbparamv1 = [pbparam.v1 toBuilder];
                BaseSearchParamsV1_Builder* bsv1 = [pbparamv1.baseParams toBuilder];
                [bsv1 setPage:1];
                [pbparamv1 setBaseParams:[bsv1 build]];
                [pbparam setVersion:pbparamv1.version];
                [pbparam setV1:[pbparamv1 build]];
                sgParams = [[pbparam build] retain];
                
                SaleListViewController *ctrl = [[SaleListViewController alloc] init];
                ctrl.saleArray = nil;
                ctrl.sgParams = sgParams;
                
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.drawerController presentModalViewController:orderNavCtrl animated:YES];
                [orderNavCtrl release];
                [ctrl release];
            }

        }
            break;
            
        case MESSAGE_COMPETITION_SALE_REQ:{
        
            NSString *fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
            NSString *toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];
            
            Customer_Builder *customer = [Customer builder];
            CustomerV1_Builder* cv1 = [CustomerV1 builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
            CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            [tmpCategory setVersion:ccv1.version];
            [tmpCategory setV1:[ccv1 build]];
            
            [cv1 setCategory:[tmpCategory build]];
            [customer setVersion:cv1.version];
            [customer setV1:[cv1 build]];
            
            Customer*   currentCustomer = [[customer build] retain];
            //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
            CompetitionGoodsParams_Builder* pbparam = [CompetitionGoodsParams builder];
            CompetitionGoodsParamsV1_Builder* ogv1 = [CompetitionGoodsParamsV1 builder];
            BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
            if (currentCustomer.v1.id == -1) {
                [bsv1 setCustomerCategoryArray:[[NSArray alloc] initWithObjects:currentCustomer.v1.category, nil]];
            }else{
                [bsv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer, nil]];
            }
            
            [bsv1 setStartDate:fromTime];
            [bsv1 setEndDate:toTime];
            [ogv1 setBaseParams:[bsv1 build]];
            [pbparam setVersion:ogv1.version];
            [pbparam setV1:[ogv1 build]];
            
            cgParams = [[pbparam build] retain];
            
            if (cgParams != nil){
                CompetitionGoodsParams_Builder* pbparam = [cgParams toBuilder];
                CompetitionGoodsParamsV1_Builder* pbparamv1 = [pbparam.v1 toBuilder];
                BaseSearchParamsV1_Builder* bsv1 = [pbparamv1.baseParams toBuilder];
                [bsv1 setPage:1];
                [pbparamv1 setBaseParams:[bsv1 build]];
                [pbparam setVersion:pbparamv1.version];
                [pbparam setV1:[pbparamv1 build]];
                cgParams = [[pbparam build] retain];
                
                CompetitionListViewController *ctrl = [[CompetitionListViewController alloc] init];
                ctrl.competitionArray = nil;
                ctrl.cgParams = cgParams;
                
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.drawerController presentModalViewController:orderNavCtrl animated:YES];
                [orderNavCtrl release];
                [ctrl release];
            }

        }
            break;
 
        default:
            [MESSAGE showMessageWithTitle:@"info_version"
                              description:@"info_message_update_version"
                                     type:MessageBarMessageTypeImportant
                              forDuration:2.0];
            break;
    
    }
}


@end
