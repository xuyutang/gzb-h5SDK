//
//  WTPrintViewController.h
//  BlueTooth
//
//  Created by Administrator on 16/3/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PrintConnectionStatus{
    PrintConnectionStatusSuccess = 0,
    PrintConnectionStatusOff
} PrintStatus;

@class BabyBluetooth;
@class CBCharacteristic;
@class CBPeripheral;
@interface WTPrintViewController : UIViewController<UIViewControllerTransitioningDelegate>
{
    
}
@property (nonatomic,strong) NSThread *thread;
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UILabel *lbtitle;
@property (nonatomic,strong) NSString *printContent;

@property (nonatomic) enum PrintConnectionStatus connectStatus;
@property (nonatomic,strong) NSMutableArray *preipherals;
@property (nonatomic,strong) BabyBluetooth *baby;
@property (nonatomic,strong) CBCharacteristic *printCharacteristic;
@property (nonatomic,strong) CBPeripheral *currentPeripheral;

@property (nonatomic) BOOL bViewScan;
@property (nonatomic,copy) void(^scanNull) (enum PrintConnectionStatus printConnectStatus);

@property (nonatomic,copy) void(^printEnd) (NSError *error);

+(instancetype) mainPrintVC;
-(void) print;
-(void) disconnect;
-(void) scan;
@end
