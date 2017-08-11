//
//  WTPrintViewController.m
//  BlueTooth
//
//  Created by Administrator on 16/3/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "WTPrintViewController.h"
#import "BabyBluetooth.h"
#import "MBProgressHUD.h"
#import "CustomPresentation.h"
#import "CustomTransition.h"
#import "PrintDefaults.h"
#import "Constant.h"

#define CONNECT_CANNAL @"setBlockOnConnectedAtChannel"

@interface WTPrintViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
    CGFloat percent;
    int printCount;
    int pcurrentIndex;
}
@end

static WTPrintViewController *mainPrintVC;

@implementation WTPrintViewController

+(instancetype)mainPrintVC{
    static dispatch_once_t oncePrint;
    dispatch_once(&oncePrint, ^{
        mainPrintVC = [[WTPrintViewController alloc] init];
        mainPrintVC.connectStatus = PrintConnectionStatusOff;
    });
    return mainPrintVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGes:)];
    [self.view addGestureRecognizer:pan];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    _bViewScan = YES;
    [self initData];
}


-(void) initData{
    if (_baby == nil) {
        _preipherals = [[NSMutableArray alloc] init];
        _baby = [BabyBluetooth shareBabyBluetooth];
        [self setBabyOptions];
        [self setBabyDelegate];
    }
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _bViewScan = YES;
    _baby.scanForPeripherals().begin();
    [self setLbTitleText:_baby.centralManager];
}

-(void) setBabyOptions{
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES,
                                     CBCentralManagerRestoredStateScanServicesKey:@YES,
                                     CBCentralManagerScanOptionSolicitedServiceUUIDsKey:@YES};
    NSDictionary *scanForPeripheralsOpetion = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES,CBCentralManagerScanOptionSolicitedServiceUUIDsKey:@YES};
    
    [_baby setBabyOptionsAtChannel:CONNECT_CANNAL
     scanForPeripheralsWithOptions:scanForPeripheralsOpetion
      connectPeripheralWithOptions:connectOptions
    scanForPeripheralsWithServices:nil
              discoverWithServices:nil
       discoverWithCharacteristics:nil];
}

//设置扫描到设备的委托
-(void) setBabyDelegate{
    __block typeof(self) _self = self;
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    //蓝牙状态监控
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        [_self cehckMgrStatus:central];
    }];
    //蓝牙状态监控
    [_baby setBlockOnCentralManagerDidUpdateStateAtChannel:CONNECT_CANNAL block:^(CBCentralManager *central) {
        [_self cehckMgrStatus:central];
    }];
    //发现设备
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"%@",peripheral.name);
        if (_self.bViewScan) {
            [_self insertRow:peripheral];;
        }else{
            NSLog(@"缓存打印机:%@",[[PrintDefaults mainPrintDefaults] getList]);
            if([[[PrintDefaults mainPrintDefaults] getList] containsObject:peripheral.identifier.UUIDString])
            {
                [_self connectPeripheral:peripheral];
            }
        }
    }];
    
    //设备连接后的委托
    /*连接状态*/
    [_baby setBlockOnConnectedAtChannel:CONNECT_CANNAL block:^(CBCentralManager *central, CBPeripheral *peripheral){
        [_self.baby cancelScan];
    }];
    [_baby setBlockOnFailToConnectAtChannel:CONNECT_CANNAL block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备连接失败\n设备已关闭或已被其它设备连接");
        if ([peripheral.identifier.UUIDString isEqualToString:_self.currentPeripheral.identifier.UUIDString]) {
            _self.connectStatus = PrintConnectionStatusOff;
            if (_self.scanNull) {
                _self.scanNull(PrintConnectionStatusOff);
                [_self.thread cancel];
            }
        }
    }];
    [_baby setBlockOnDisconnectAtChannel:CONNECT_CANNAL block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [self hudHide];
        NSLog(@"与设备 %@ 失去连接",peripheral.name);
        if ([peripheral.identifier.UUIDString isEqualToString:_self.currentPeripheral.identifier.UUIDString]) {
            _self.connectStatus = PrintConnectionStatusOff;
            if (_self.scanNull) {
                _self.scanNull(PrintConnectionStatusOff);
                [_self.thread cancel];
            }
        }
    }];
    /*服务扫描*/
    __block int index = 1;
    __block BOOL bWrit = NO;
    [_baby setBlockOnDiscoverCharacteristicsAtChannel:CONNECT_CANNAL block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"搜索到了设备UUID:%@",service.UUID);
        CBCharacteristic *ope = nil;
        for (CBCharacteristic *item in service.characteristics) {
            
            if (item.properties & CBCharacteristicPropertyWriteWithoutResponse) {
                ope = item;
                break;
            }
        }
        if (ope != nil) {
            bWrit = YES;
            _self.currentPeripheral =  peripheral;
            [_self.currentPeripheral setNotifyValue:YES forCharacteristic:ope];
            _self.printCharacteristic = ope;
            NSLog(@"打印服务:%@",ope.UUID);
            [[PrintDefaults mainPrintDefaults] savePrint:peripheral.identifier.UUIDString];
            
            _self.connectStatus = PrintConnectionStatusSuccess;
            if (_self.scanNull) {
                _self.scanNull(PrintConnectionStatusSuccess);
                [_self.thread cancel];
            }
            if (_self.bViewScan) {
                [_self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        if (index == peripheral.services.count) {
            if (!bWrit) {
                //断开与此设备的连接
                [_self.baby cancelPeripheralConnection:peripheral];
                if (_self.scanNull) {
                    _self.scanNull(PrintConnectionStatusOff);
                    [_self.thread cancel];
                }
                [_self alert:@"此设备不支持打印服务!"];
            }else{
                bWrit = NO;
            }
            //无论是否需要打印都要重置数值
            index = 1;
        }else{
            index++;
        }
    }];
    __block currentIndex = pcurrentIndex;
    [_baby setBlockOnDidWriteValueForCharacteristicAtChannel:CONNECT_CANNAL block:^(CBCharacteristic *characteristic, NSError *error) {
        [_self hudHide];
        currentIndex++;
        NSLog(@"printCount:%d,currentIndex:%d",printCount,currentIndex);
        if (currentIndex == (printCount + 1)) {
            if (_self.printEnd) {
                _self.printEnd(error);
            }
        }
    }];
}


-(void) hudHide{
    dispatch_async(dispatch_get_main_queue(), ^{
        HUDHIDE2;
    });
}


#pragma -mark -- 私有方法
-(void) setLbTitleText:(CBCentralManager *)mgr{
    if (mgr.state == CBCentralManagerStatePoweredOn) {
        self.lbtitle.text = @"设备扫描中...";
    }else{
        self.lbtitle.text = @"请手动开启蓝牙功能";
    }
}

//设置连接打印机配置
-(void) connectPrintService{
    unsigned char* cData = (unsigned char *)calloc(100, sizeof(unsigned char));
    /*打印机复位*/
    cData[0] = 0x1B;
    cData[1] = 0x40;
    /*字体加粗*/
//    cData[0] = 0x1D;
//    cData[1] = 0x21;
//    cData[2] = 0x11;
    /*默认字体*/
//    cData[0] = 0x1D;
//    cData[1] = 0x21;
//    cData[2] = 0x00;
    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);//[self.printContent dataUsingEncoding:gbk];
    NSData *cmdData = [NSData dataWithData:[NSData dataWithBytes:cData length:2]];
    NSString *str = [[NSString alloc] initWithData:cmdData encoding:gbk];
    NSLog(@"%@",str);
    [_currentPeripheral writeValue:cmdData forCharacteristic:_printCharacteristic type:CBCharacteristicWriteWithResponse];
}

//检测蓝牙状态
-(void) cehckMgrStatus:(CBCentralManager *) mgr{
    [self setLbTitleText:mgr];
    if (mgr.state == CBCentralManagerStatePoweredOn) {
        _baby.scanForPeripherals().begin();
    }else{
        [self disconnect];
        [self removeRows];
    }
}

-(void) insertRow:(CBPeripheral *) peripheral{
    if (![_preipherals containsObject:peripheral]) {
        [_preipherals addObject:peripheral];
        [self.tabView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_preipherals.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) removeRows{
    
    NSMutableArray *rowIndexes = [[NSMutableArray alloc] init];
    for (int i = 0; i < _preipherals.count; i++) {
        [rowIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [_preipherals removeAllObjects];
    [self.tabView deleteRowsAtIndexPaths:rowIndexes withRowAnimation:UITableViewRowAnimationFade];
}


#pragma -mark -- 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _preipherals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    CBPeripheral *peripheral = _preipherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    SHOWHUD;
    [self connectPeripheral:(CBPeripheral *)_preipherals[indexPath.row]];
}

//连接设备
-(void) connectPeripheral:(CBPeripheral *) peripheral{
    [_baby cancelAllPeripheralsConnection];
    _baby.having(peripheral).and.channel(CONNECT_CANNAL).then.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
}

#pragma -mark -- 转场动画处理
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
    CustomPresentation *presentation = [[CustomPresentation alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    CustomTransition * present = [[CustomTransition alloc]initWithBool:YES];
    return present;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if (dismissed) {
        CustomTransition * present = [[CustomTransition alloc]initWithBool:NO];
        return present;
    }else{
        return nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    
    if (animator) {
        return percentDrivenInteractiveTransition;
    }else{
        return nil;
    }
}

#pragma -mark -- 其它
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self disconnect];
}

-(void) print{
    //复位打印机
    [self connectPrintService];
    if (self.printContent== nil || self.printContent.length == 0) {
        return;
    }
    int printLength = 100;
    int index = 0;
    int subLength = 0;
    NSData *data;
    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSData *cmdData = [self.printContent dataUsingEncoding:gbk];
    if (cmdData.length > printLength) {
        while (true) {
            subLength = cmdData.length - index * printLength;
            if (subLength > printLength) {
                data = [cmdData subdataWithRange:NSMakeRange(index * printLength, printLength)];
                [self p:data];
                index++;
                continue;
            }
            data = [cmdData subdataWithRange:NSMakeRange(index * printLength,subLength)];
            [self p:data];
            break;
        }
    }else{
        [self p:data];
    }
    [self hudHide];
}


-(void) p:(NSData *)d{
    printCount++;
    [_currentPeripheral writeValue:d forCharacteristic:_printCharacteristic type:CBCharacteristicWriteWithResponse];
    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSLog(@"%@",[[NSString alloc] initWithData:d encoding:gbk]);
}

-(void) scan{
    HUDHIDE2;
    _bViewScan = NO;
    [self initData];
    [self disconnect];
    _baby.scanForPeripherals().begin();
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(cehckScanSource) object:nil];
    [_thread start];
}

-(void) disconnect{
    [_baby cancelAllPeripheralsConnection];
    [_baby cancelScan];
    if (_thread != nil) {
        [_thread cancel];
        _thread = nil;
    }
}


-(void) cehckScanSource{
    [NSThread sleepForTimeInterval:5.f];
    if (self.currentPeripheral == nil) {
        if (self.scanNull) {
            self.scanNull(PrintConnectionStatusOff);
        }
    }else{
        if (self.scanNull) {
            self.scanNull(PrintConnectionStatusSuccess);
        }
    }
    [_thread cancel];
    HUDHIDE2;
}

-(void)panGes:(UIPanGestureRecognizer *)gesture{
    CGFloat yOffset = [gesture translationInView:self.view].y;
    percent =  yOffset / 1800;
    //    percent = MAX(0, MIN(1, percent));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        //这句必须加上！！
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        [percentDrivenInteractiveTransition updateInteractiveTransition:percent];
    }else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded){
        [percentDrivenInteractiveTransition finishInteractiveTransition];
        //        if (percent > 0.06) {
        //
        //
        //        }else{
        
        //            [percentDrivenInteractiveTransition cancelInteractiveTransition];
        
        //        }
        //这句也必须加上！！
        percentDrivenInteractiveTransition = nil;
    }
}


-(void) alert:(NSString *) content{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"note", nil)
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
@end
