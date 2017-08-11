//
//  WifiAttenceViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/11/13.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiAttenceViewController.h"
#import "LocationCell.h"
#import "TextFieldCell.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "UIView+CNKit.h"
#import "FillCardViewController.h"
#import "UIColor+hex.h"


#define kImageWidth  92
#define kImageHeight  40

@interface WifiAttenceViewController ()

@end

@implementation WifiAttenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    appDelegate = APPDELEGATE;
    checkDateBool = YES;
    [super viewDidLoad];
    //自动更新地理位置
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    //监听网络改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshNetWork) name:@"network_change" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reFreshDayWork)
                                                 name:@"refresh_daywork"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reFreshShift)
                                                 name:@"syncCheckInShift"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reFreshShift)
                                                 name:@"refreshChenkInshit"
                                               object:nil];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    _WifitableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 388) style:UITableViewStylePlain];
    _WifitableView.delegate = self;
    _WifitableView.dataSource = self;
    _WifitableView.bounces = NO;
    _WifitableView.allowsSelection = NO;
    [_WifitableView setBackgroundColor:[UIColor whiteColor]];
    _WifitableView.backgroundView = nil;
    [_WifitableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [scrollView addSubview:_WifitableView];
    
    statusMulArray = [[NSMutableArray alloc]init];
    trackMulArray = [[NSMutableArray alloc]init];
    remarkMulArray = [[NSMutableArray alloc]init];
    hasTrackBool = NO;
    [self initWifiAttenceData];
    [self initDayWork];
    //排班信息表
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_ATTENDANCE_DES)];
    //    remarks = [[NSString alloc] initWithString:@""];
    
}

-(void)initWifiAttenceData{
    /**判断是否为假期，NO:取班次，取更新时间，与当前时间进行比较
     更新时间 < 当前时间 则请求，加载页面（加载页面+是否是假期的判断）
     **/
    
    //同步数据
    holidayMulArray = [[LOCALMANAGER getHolidays] retain];
    
    //取当前日期
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:curDate];
    NSLog(@"dateString:%@",dateString);
    
    if ([holidayMulArray containsObject:dateString]) {
        return;
    }
    
    checkInShift = [[LOCALMANAGER getCheckInshift] retain];
    workTypeStr = checkInShift.name;
    if (checkInShift.workingTime.isEmpty) {
        return;
    }
    NSData *JSONData = [checkInShift.workingTime dataUsingEncoding:NSUTF8StringEncoding];
    checkInShiftMulArray = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain] ;
    
    dataArr = [[NSMutableArray alloc]init];
    for (NSDictionary* dic in checkInShiftMulArray) {
        CheckInShiftModel *model = [[CheckInShiftModel alloc] init];
        model.id = [dic objectForKey:@"id"] ;
        model.name = [dic objectForKey:@"name"];
        model.end = [dic objectForKey:@"end"];
        model.sn = [dic objectForKey:@"sn"];
        model.start = [dic objectForKey:@"start"];
        [dataArr addObject:model];
        [dataArr addObject:model];
    }
    
    //同步更新时间
    NSString *syncTime = checkInShift.syncTime;
    //取当前时间
    NSDate *curDate1 = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString1 = [dateFormatter1 stringFromDate:curDate1];
    NSLog(@"dateString:%@",dateString1);
    
    //与当前时间进行比较
    int timeInterval = [self compareDate:dateString1 withDate:syncTime];
    //更新时间 < 当前时间
    
    if ((timeInterval != 1)){
        [self reFreshDayWork];
        [statusMulArray removeAllObjects];
    }else {
        [self crateCheckInShiftTableView];
    }
}

-(void)reFreshShift {
    [self reFreshDayWork];
    
}

-(void)initDayWork {
    checkInShift = [[LOCALMANAGER getCheckInshift] retain];
    //同步更新时间
    NSString *syncTime = checkInShift.syncTime;
    //取当前时间
    NSDate *curDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:curDate];
    NSLog(@"dateString:%@",dateString);
    
    
    NSData *JSONData = [checkInShift.workingTime dataUsingEncoding:NSUTF8StringEncoding];
    checkInShiftMulArray = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain] ;
    //与当前时间进行比较
    int timeInterval = [self compareDate:dateString withDate:syncTime];
    
    NSDate *curDate1 = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString1 = [dateFormatter1 stringFromDate:curDate1];
    NSLog(@"dateString1:%@",dateString1);
    currentDate = [dateString1 retain];
    
    //更新时间 < 当前时间
    
    if ((timeInterval != 1)){
        [statusMulArray removeAllObjects];
        [LOCALMANAGER saveShiftGroup:nil];
        
    }else {
        [statusMulArray removeAllObjects];
        statusMulArray = [[LOCALMANAGER getShiftGroup] retain];;
        [remarkMulArray removeAllObjects];
        NSData *JSONData = [checkInShift.workingTime dataUsingEncoding:NSUTF8StringEncoding];
        checkInShiftMulArray = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain] ;
        
    }
    
    [_pullTableView reloadData];
    NSArray *arr = [currentDate componentsSeparatedByString:@"-"];
    //通过日期 判断是星期几
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[arr[2] integerValue]];
    [_comps setMonth:[arr[1] integerValue]];
    [_comps setYear:[arr[0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
    NSLog(@"_weekday::%d",_weekday);
    NSArray *weekdays = [NSArray arrayWithObjects: @"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    weekString = weekdays[_weekday - 1];
    workTypeStr = checkInShift.name;
    [_WifitableView reloadData];
    
}

#pragma mark 时间比较的方法
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

#pragma mark 时间比较的方法
-(int)compareDate1:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

-(void)crateCheckInShiftTableView {
    self.pullTableView = [[UITableView alloc]init];
    self.pullTableView.frame = CGRectMake(0, _WifitableView.bottom, MAINWIDTH, checkInShiftMulArray.count*90*2);
    
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    [scrollView addSubview:self.pullTableView];
    [scrollView setContentSize:CGSizeMake(MAINWIDTH,self.pullTableView.bottom + 50)];
    
}

#pragma mark 网络变化自动更新
-(void)reFreshNetWork {
    id info = nil;
    NSArray *ifs = ( id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        wifiName = info[@"SSID"];
        
        wifiCell.textLabel.font = [UIFont systemFontOfSize:14];
        wifiCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"connected_wifi", @""),wifiName];
    }
    if (wifiName == nil) {
        wifiCell.textLabel.text = NSLocalizedString(@"no_wifi", @"");
    }
    [_WifitableView reloadData];
    
}

-(void)reFreshDayWork {
    checkDateBool = YES;
    [self initDayWork];
    NSLog(@"刷新排班列表");
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCheckinShiftGet param:@""]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
    
}

#pragma mark 同步标题的方法
-(void)syncTitle {
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_ATTENDANCE_DES)];
}

#pragma mark 初始化的方法
-(void) initData{
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    remarks = @"";
}

#pragma mark 去往考勤列表
-(void)toList:(id)sender{
    [self dismissKeyBoard];
}

#pragma mark -delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不让tableviewcell有选中效果
    if(indexPath.section == 1)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_WifitableView]) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 1) {
                return 120.0f;
            }else if(indexPath.row == 2){
                return 118.0f;
            }else{
                return 50.0f;
            }
        }else{
            return kImageHeight + 10;
        }
        
    }else if ([tableView isEqual:_pullTableView]){
        return 90;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_WifitableView]) {
        if (section == 0) {
            return 5;
        }
        
    }else if ([tableView isEqual:_pullTableView]){
        return checkInShiftMulArray.count *2;
        
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_WifitableView]) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = nil;
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                static NSString *cellIdentifier = @"ChangeDateCell";
                
                changeDateCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(changeDateCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ChangeDateTableViewCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[ChangeDateTableViewCell class]])
                            changeDateCell=(ChangeDateTableViewCell *)oneObject;
                    }
                }
                //获取今天 日期 星期
                if (weekString == nil) {
                    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
                    NSDate *date = [NSDate date];
                    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
                    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
                    NSInteger unitFlags = NSYearCalendarUnit |
                    NSMonthCalendarUnit |
                    NSDayCalendarUnit |
                    NSWeekdayCalendarUnit |
                    NSHourCalendarUnit |
                    NSMinuteCalendarUnit |
                    NSSecondCalendarUnit;
                    comps = [calendar components:unitFlags fromDate:date];
                    int week = [comps weekday];
                    changeDateCell.weekLabel.text = arrWeek[week -1];
                    [changeDateCell.changeDateBtn setTitle:[NSString stringWithFormat:@"%d-%d-%d",[comps year],[comps month],[comps day]] forState:UIControlStateNormal];
                    
                }else {
                    changeDateCell.weekLabel.text = weekString;
                    [changeDateCell.changeDateBtn setTitle:currentDate forState:UIControlStateNormal];
                }
                
                //当前日期，用于判断是否是休息
                NSDate *curDate = [NSDate date];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
                NSString *dateString1 = [dateFormatter1 stringFromDate:curDate];
                NSLog(@"dateString1:%@",dateString1);
                if ([holidayMulArray containsObject:dateString1] && [currentDate isEqualToString:dateString1]) {
                    changeDateCell.workTypeLabel.text = @"休";
                    [scrollView setContentSize:CGSizeMake(MAINWIDTH,self.WifitableView.bottom + 44)];
                }else {
                    changeDateCell.workTypeLabel.text = workTypeStr;
                    
                }
                
                [changeDateCell.changeDateBtn addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
                
                cell = changeDateCell;
                
            }else if (indexPath.row == 1) {
                txtCell=(TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(txtCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[TextFieldCell class]])
                            txtCell=(TextFieldCell *)oneObject;
                    }
                }
                txtCell.txtField.frame = CGRectMake(10, 10, 300, 200);
                txtCell.title.text = NSLocalizedString(@"memo", nil);
                txtCell.title.hidden = YES;
                txtCell.txtField.delegate=self;
                txtCell.txtField.text = @"输入备注";
                txtCell.txtField.textColor = [UIColor lightGrayColor];
                CGRect rect = txtCell.txtField.frame;
                rect.size.height = 110;
                txtCell.txtField.frame = rect;
                
                if (remarks !=nil && remarks.length>0)
                    txtCell.txtField.text = remarks;
                
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                
                NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                
                
                [topView setItems:buttonsArray];
                
                cell = txtCell;
                
                [topView release];
                [helloButton release];
                [btnSpace release];
                [doneButton release];
                
                
            }else if(indexPath.row == 2){
                
                if(liveImageCell==nil){
                    liveImageCell = [[LiveImageCell alloc] init];
                    liveImageCell.delegate = self;
                }
                liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                cell = liveImageCell;
                
            }else if(indexPath.row == 4){
                
                locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(locationCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[LocationCell class]])
                            locationCell=(LocationCell *)oneObject;
                    }
                }
                
                if (appDelegate.myLocation != nil) {
                    if (!appDelegate.myLocation.address.isEmpty) {
                        [locationCell.lblAddress setText:appDelegate.myLocation.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",appDelegate.myLocation.latitude,appDelegate.myLocation.longitude]];
                    }
                }
                [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 49, MAINWIDTH, 0.5)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [locationCell addSubview:lineView];
                cell = locationCell;
            }else if (indexPath.row == 3) {
                
                wifiCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"wifiCell"];
                
                if (wifiCell == nil) {
                    wifiCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wifiCell"];
                    
                    id info = nil;
                    NSArray *ifs = ( id)CNCopySupportedInterfaces();
                    for (NSString *ifnam in ifs) {
                        info = (id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
                        wifiName = info[@"SSID"];
                        
                        wifiCell.textLabel.font = [UIFont systemFontOfSize:14];
                        wifiCell.textLabel.text =[NSString stringWithFormat:NSLocalizedString(@"connected_wifi", @""),wifiName];
                        if (wifiName == nil) {
                            wifiCell.textLabel.text =  NSLocalizedString(@"no_wifi", @"");
                        }
                    }
                    
                    
                }
                wifiCell.textLabel.userInteractionEnabled = YES;
                [wifiCell.textLabel addActionWithTarget:self action:@selector(changesNet)];
                
                cell = wifiCell;
            }
            
        }
        return cell;
        
    } else if ([tableView isEqual:_pullTableView]){
        static NSString *cellIdentifier = @"Cell";
        
        wifiAttenceCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(wifiAttenceCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"WifiAttenceCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[WifiAttenceCell class]])
                    wifiAttenceCell=(WifiAttenceCell *)oneObject;
            }
        }
        
        dataArr = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in checkInShiftMulArray) {
            CheckInShiftModel *model = [[CheckInShiftModel alloc] init];
            model.id = [dic objectForKey:@"id"] ;
            model.name = [dic objectForKey:@"name"];
            model.end = [dic objectForKey:@"end"];
            model.sn = [dic objectForKey:@"sn"];
            model.start = [dic objectForKey:@"start"];
            [dataArr addObject:model];
            [dataArr addObject:model];
        }
        
        if (indexPath.row % 2) {
            wifiAttenceCell.dayImageView.image = [UIImage imageNamed:@"work_off"];
        }else{
            wifiAttenceCell.dayImageView.image = [UIImage imageNamed:@"work_on"];
        }
        
        statusmodel = dataArr[indexPath.row];
        wifiAttenceCell.catoryLabel.text = statusmodel.name;
        if (indexPath.row % 2) {
            wifiAttenceCell.timeLabel.text = statusmodel.end;
        }else{
            wifiAttenceCell.timeLabel.text=  statusmodel.start;
        }
        
        wifiAttenceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDate *curDate = [NSDate date];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString1 = [dateFormatter1 stringFromDate:curDate];
        NSLog(@"dateString1:%@",dateString1);
        
        if (statusMulArray.count) {
            
            if (checkDateBool) {
                [trackMulArray removeAllObjects];
                [statusMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CheckInShiftModel *model = [[CheckInShiftModel alloc] init];
                    model.stutus = ((CheckInShiftGroup*)obj).checkInStatus;
                    model.checkInTime = ((CheckInShiftGroup*)obj).checkInTime;
                    model.checkInAbnormal = ((CheckInShiftGroup*)obj).checkInAbnormal;
                    model.checkInDat = ((CheckInShiftGroup*)obj).date;
                    model.id = ((CheckInShiftGroup*)obj).id;
                    model.group = (CheckInShiftGroup*)obj;
                    model.name = ((CheckInShiftGroup*)obj).name;
                    model.checkInType = ((CheckInShiftGroup*)obj).checkInType;
                    [trackMulArray addObject:model];
                    
                }];
                
            }
            
            
            statusmodel = trackMulArray[indexPath.row];
            wifiAttenceCell.catoryLabel.text = statusmodel.name;
            wifiAttenceCell.timeLabel.text = statusmodel.checkInDat;
            
            int timeInterval = [self compareDate1:dateString1 withDate:currentDate];
            
            __block NSUInteger index = 0;
            //取最后一次打卡,之前的卡不能打；
            [statusMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (((CheckInShiftGroup*)obj).checkInTime.length) {
                    index = idx;
                }
            }];
            if (indexPath.row < index) {
                wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
            }
            
            //打卡状态判断
            if (statusmodel.stutus == 1) {
                [wifiAttenceCell.chenkInBtn setTitle:@"迟到" forState:UIControlStateNormal];
                wifiAttenceCell.lateTimeLabel.text = [NSString stringWithFormat:@"迟到%@",[self timeFormatted:statusmodel.checkInAbnormal]];
                wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                
            }else if (statusmodel.stutus == 2) {
                //之前时间的重打卡为不可打状态
                if (timeInterval == -1) {
                    wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                    wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                    [wifiAttenceCell.chenkInBtn setTitle:@"早退" forState:UIControlStateNormal];
                }else{
                    
                    [wifiAttenceCell.chenkInBtn setTitle:@"重打卡" forState:UIControlStateNormal];
                }
                
                wifiAttenceCell.lateTimeLabel.text = [NSString stringWithFormat:@"早退%@",[self timeFormatted:statusmodel.checkInAbnormal]];
                
                wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                
            }else if (statusmodel.stutus == 0 && trackMulArray.count) {
                wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                [wifiAttenceCell.chenkInBtn setTitle:@"已打卡"forState:UIControlStateNormal];
                wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                
            }else {
                [wifiAttenceCell.chenkInBtn setTitle:@"未打卡" forState:UIControlStateNormal];
                
                if (remarkMulArray.count) {
                    wifiAttenceCell.lateTimeLabel.text = statusmodel.remark;
                    if (statusmodel.remark.length) {
                        wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                        wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                    }else {
                        
                        //  length = 0 小于当前时间
                        if (timeInterval == -1) {
                            wifiAttenceCell.checkInTimeLabal.text = @"您忘记打卡了";
                            wifiAttenceCell.chenkInBtn.userInteractionEnabled = YES;
                            wifiAttenceCell.chenkInBtn.backgroundColor = WT_GREEN;
                        }
                        
                    }
                    
                }
                
            }
            
        }else {
            if (!checkDateBool) {
                statusmodel = trackMulArray[indexPath.row];
                wifiAttenceCell.catoryLabel.text = statusmodel.name;
                wifiAttenceCell.timeLabel.text = statusmodel.checkInDat;
                
                int timeInterval = [self compareDate1:dateString1 withDate:currentDate];
                
                //打卡状态判断
                if (statusmodel.stutus == 1) {
                    [wifiAttenceCell.chenkInBtn setTitle:@"迟到" forState:UIControlStateNormal];
                    wifiAttenceCell.lateTimeLabel.text = [NSString stringWithFormat:@"迟到%@",[self timeFormatted:statusmodel.checkInAbnormal]];
                    wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                    wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                    wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                    
                }else if (statusmodel.stutus == 2) {
                    //之前时间的重打卡为不可打状态
                    if (timeInterval == -1) {
                        wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                        wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                        [wifiAttenceCell.chenkInBtn setTitle:@"早退" forState:UIControlStateNormal];
                    }else{
                        
                        [wifiAttenceCell.chenkInBtn setTitle:@"重打卡" forState:UIControlStateNormal];
                    }
                    
                    wifiAttenceCell.lateTimeLabel.text = [NSString stringWithFormat:@"早退%@",[self timeFormatted:statusmodel.checkInAbnormal]];
                    wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                    
                }else if (statusmodel.stutus == 0 && trackMulArray.count) {
                    wifiAttenceCell.checkInTimeLabal.text = statusmodel.checkInTime;
                    [wifiAttenceCell.chenkInBtn setTitle:@"已打卡"forState:UIControlStateNormal];
                    wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                    wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                    
                }else {
                    [wifiAttenceCell.chenkInBtn setTitle:@"未打卡" forState:UIControlStateNormal];
                    
                    if (remarkMulArray.count) {
                        wifiAttenceCell.lateTimeLabel.text = statusmodel.remark;
                        if (statusmodel.remark.length) {
                            wifiAttenceCell.chenkInBtn.backgroundColor = [UIColor colorWithHexString:@"8fbc8f"];
                            wifiAttenceCell.chenkInBtn.userInteractionEnabled = NO;
                        }else {
                            
                            //  length = 0 小于当前时间
                            if (timeInterval == -1) {
                                wifiAttenceCell.checkInTimeLabal.text = @"您忘记打卡了";
                                wifiAttenceCell.chenkInBtn.userInteractionEnabled = YES;
                                wifiAttenceCell.chenkInBtn.backgroundColor = WT_GREEN;
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                
            }
            
            
        }
        [wifiAttenceCell.chenkInBtn addTarget:self action:@selector(checkInAction:) forControlEvents:UIControlEventTouchUpInside];
        wifiAttenceCell.chenkInBtn.tag = 1000 + indexPath.row;
        
        return wifiAttenceCell;
    }
    
    return nil;
}

#pragma mark 点击班次按钮
-(void)checkInAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    
    if (statusMulArray.count) {
        if (checkDateBool) {
            [trackMulArray removeAllObjects];
            [statusMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CheckInShiftModel *model = [[CheckInShiftModel alloc] init];
                model.stutus = ((CheckInShiftGroup*)obj).checkInStatus;
                model.checkInTime = ((CheckInShiftGroup*)obj).checkInTime;
                model.checkInAbnormal = ((CheckInShiftGroup*)obj).checkInAbnormal;
                model.checkInDat = ((CheckInShiftGroup*)obj).shift.date;
                model.id = ((CheckInShiftGroup*)obj).id;
                model.group = (CheckInShiftGroup*)obj;
                [trackMulArray addObject:model];
                
            }];
            
        }
        statusmodel = trackMulArray[btn.tag - 1000];
    }
    
    
    if (hasTrackBool && trackMulArray.count) {
        CheckInShiftModel *staModel = trackMulArray[btn.tag - 1000];
        
        NSDate *curDate = [NSDate date];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString1 = [dateFormatter1 stringFromDate:curDate];
        NSLog(@"dateString1:%@",dateString1);
        int timeInterval = [self compareDate1:dateString1 withDate:currentDate];
        
        
        if (timeInterval == -1 && staModel.stutus == 3) {
            //补卡操作
            FillCardViewController *fcVC = [[FillCardViewController alloc]init];
            
            fcVC.model = staModel;
            [fcVC refreshCheckWithBlock:^(NSString*remarkStr) {
                [self refreshTable];
            }];
            
            [self.parentCtrl.navigationController pushViewController:fcVC animated:YES];
            
        }else {
            [self checkSave:btn.tag - 1000];
        }
    }else {
        [self checkSave:btn.tag - 1000];
    }
    
}

#pragma mark 打卡记录保存
-(void)checkSave:(int)index {
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    checkInShift = [LOCALMANAGER getCheckInshift];
    CheckInTrack_Builder *cb = [CheckInTrack builder];
    [cb setId:-1];
    [cb setCheckInDate:checkInShift.date];
    
    //构建group
    CheckInShiftGroup_Builder *cs = [CheckInShiftGroup builder];
    
    CheckInShiftModel *model = dataArr[index];
    [cs setId:model.id];
    [cs setShift:checkInShift];
    [cs setName:model.name];
    [cs setDate:checkInShift.date];
    
    if (index % 2) {
        [cs setCheckInType:1];
    } else {
        [cs setCheckInType:0];
    }
    ;
    [cb setCheckInShiftGroup:[cs build]];
    
    //wifi对象
    CheckInWifi_Builder *cf = [CheckInWifi builder];
    [cf setId:-1];
    [cf setName:[self getWifiName]];
    [cf setMacAddress:[self getMacAddress]];
    [cb setWifi:[cf build]];
    
    if (appDelegate.myLocation != nil){
        [cb setLocation:appDelegate.myLocation];
    }
    if (liveImageCell.imageFiles.count >0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *file in liveImageCell.imageFiles) {
            UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
            NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
            [images addObject:dataImg];
        }
        [cb setFilesArray:images];
    }
    
    if ((txtCell.txtField.textColor != [UIColor lightGrayColor])) {
        [cb setComment:[txtCell.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCheckinTrackSave param:[cb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
}
-(void)changesNet {
    //ios10 移除了canOpenURL的方法 ，不能跳到WiFi列表页，用信息提醒
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:@"请打开WIFI"type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    //ios 10 之前
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)changeDate {
    datePicker = [[DatePicker2 alloc] init];
    datePicker.topView.frame = CGRectMake(15, 0, MAINWIDTH - 30, 44);
    [self.view addSubview:datePicker];
    [datePicker setDelegate:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0) {
        [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5 + 11)];
    }else {
        [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5 + 22)];
    }
    
    [datePicker release];
}

-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}

-(void)datePickerDidDone:(DatePicker2*)picker{
    
    currentDate = [[NSString stringWithFormat:@"%d-%@-%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue]] retain];
    //通过日期 判断是星期几
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[[self intToDoubleString:datePicker.dayValue]integerValue]];
    [_comps setMonth:[[self intToDoubleString:datePicker.monthValue]integerValue]];
    [_comps setYear:datePicker.yearValue];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
    NSLog(@"_weekday::%d",_weekday);
    NSArray *weekdays = [NSArray arrayWithObjects: @"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    weekString = weekdays[_weekday - 1];
    
    [_WifitableView reloadData];
    [self datePickerDidCancel];
    //与当前时间比较 查询当前之前的班次
    
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString1 = [dateFormatter1 stringFromDate:curDate];
    NSLog(@"dateString1:%@",dateString1);
    int timeInterval = [self compareDate1:dateString1 withDate:currentDate];
    //小于当前时间
    if (timeInterval == -1){
        //日期查询
        AGENT.delegate = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        [hud hide:YES afterDelay:1];
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCheckinTrackDate param:currentDate]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
    }else {
        [self reFreshDayWork];
    }
}

-(void)refreshTable {
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    [hud hide:YES afterDelay:1];
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCheckinTrackDate param:currentDate]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
    
}
-(void)datePickerDidCancel{
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[DatePicker2 class]]){
            [view removeFromSuperview];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"输入备注"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"输入备注";
        textView.textColor = [UIColor lightGrayColor];
    }
    remarks = [textView.text copy];
}


-(void)autorefreshLocation {
    [super refreshLocation];
    [_WifitableView reloadData];
}

- (void)refreshLocation {
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [hud hide:YES afterDelay:1.0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}



-(IBAction)dismissKeyBoard {
    [txtCell.txtField resignFirstResponder];
}

-(IBAction)clearInput {
    txtCell.txtField.text = @"";
    
}

-(void)addPhoto {
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self.parentCtrl presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image {
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<720 && image.size.height<960)
    {
        return image;
    }
    CGSize size = [self fitsize:image.size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}

- (CGSize)fitsize:(CGSize)thisSize {
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    //NSLog(@"image.size.width=%f  image.size.height=%f",image.size.width,image.size.height);
    if (image.size.width > image.size.height) {
        newSize.width = (newSize.height/image.size.height) *image.size.width;
    }else{
        newSize.height = (newSize.width/image.size.width) *image.size.height;
    }
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [self fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] ;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    
    [imageFiles addObject:imagePath];
    [liveImageCell insertPhoto:imagePath];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
            //刷新排班表；
        case ActionTypeCheckinShiftGet:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                CheckInShift* ac = [CheckInShift parseFromData:cr.data];
                
                NSData *JSONData = [ac.workingTime dataUsingEncoding:NSUTF8StringEncoding];
                checkInShiftMulArray = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain];
                //checkTypeStr = [ac.name copy];
                [LOCALMANAGER saveChenkInShift:ac];
                [LOCALMANAGER saveHolidays:ac.holidays];
                [_pullTableView removeFromSuperview];
                workTypeStr = [ac.name retain];
                
                [_WifitableView reloadData];
                //加载前判断是否是假期
                //当前日期，用于判断是否是休息
                NSDate *curDate = [NSDate date];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
                NSString *dateString1 = [dateFormatter1 stringFromDate:curDate];
                NSLog(@"dateString1:%@",dateString1);
                holidayMulArray = [[LOCALMANAGER getHolidays]retain];
                if (![holidayMulArray containsObject:dateString1]) {
                    [self crateCheckInShiftTableView];
                }
                
            }
            
            
        }
            break;
            //点击打卡，打卡状态保存
        case ActionTypeCheckinTrackSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                NSLog(@"打卡成功");
                PBAppendableArray* cs = [[PBAppendableArray alloc] autorelease];
                int checkCount = cr.datas.count;
                NSMutableArray *mulArray = [[NSMutableArray alloc]init];
                [statusMulArray removeAllObjects];
                for (int i = 0 ;i < checkCount;i++){
                    CheckInTrack* ac = [CheckInTrack parseFromData:[cr.datas  objectAtIndex:i]];
                    [mulArray addObject:ac];
                    [cs addObject:ac];
                    
                    [statusMulArray addObject:ac.checkInShiftGroup];
                }
                
                [LOCALMANAGER saveShiftGroup:cs];
                // [remarkMulArray removeAllObjects];
                
                hasTrackBool = YES;
                [txtCell.txtField setText:@""];
                remarks = nil;
                [liveImageCell clearCell];
                //刷新日期
                [_WifitableView reloadData];
                [_pullTableView reloadData];
                if (!cr.resultMessage.length) {
                    
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:@"打卡成功"
                                             type:MessageBarMessageTypeSuccess
                                      forDuration:SUCCESS_MSG_DURATION];
                }else {
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:cr.resultMessage
                                             type:MessageBarMessageTypeSuccess
                                      forDuration:SUCCESS_MSG_DURATION];
                }
                
            }
            
        }
            break;
            //日期查询
        case ActionTypeCheckinTrackDate:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                PBAppendableArray* cs = [[PBAppendableArray alloc] autorelease];
                int count = cr.datas.count;
                [remarkMulArray removeAllObjects];
                NSMutableArray *mulArray = [[NSMutableArray alloc]init];
                for (int i = 0 ;i < count;i++){
                    CheckInTrack* ac = [CheckInTrack parseFromData:[cr.datas  objectAtIndex:i]];
                    [mulArray addObject:ac];
                    [cs addObject:ac];
                    [remarkMulArray addObject:ac.checkInRemark];
                }
                
                [_pullTableView removeFromSuperview];
                [trackMulArray removeAllObjects];
                if (mulArray.count) {
                    //注意 本地数据库所存的永远是当前班次
                    NSData *JSONData = [ [CheckInTrack parseFromData:[cr.datas objectAtIndex:0]].checkInShiftGroup.shift.workingTime dataUsingEncoding:NSUTF8StringEncoding];
                    checkInShiftMulArray = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain] ;
                    [mulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CheckInShiftModel *model = [[CheckInShiftModel alloc] init];
                        model.stutus = ((CheckInTrack*)obj).checkInShiftGroup.checkInStatus;
                        model.checkInTime = ((CheckInTrack*)obj).checkInShiftGroup.checkInTime;
                        model.checkInAbnormal = ((CheckInTrack*)obj).checkInShiftGroup.checkInAbnormal;
                        model.checkInDat = ((CheckInTrack*)obj).checkInShiftGroup.date;
                        model.id = ((CheckInTrack*)obj).checkInShiftGroup.id;
                        model.group = ((CheckInTrack*)obj).checkInShiftGroup;
                        model.name = ((CheckInTrack*)obj).checkInShiftGroup.name;
                        model.checkInType = ((CheckInTrack*)obj).checkInShiftGroup.checkInType;
                        model.remark = ((CheckInTrack*)obj).checkInRemark;
                        //排序
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSData *JSONData = [((CheckInTrack*)obj).checkInShiftGroup.shift.workingTime dataUsingEncoding:NSUTF8StringEncoding];
                        
                        arr = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil] retain];
                        
                        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([[obj objectForKey:@"id"] isEqualToString:model.id]) {
                                model.sn = [obj objectForKey:@"sn"];
                            }
                        }];
                        
                        [trackMulArray addObject:model];
                        
                    }];
                    NSArray *sortDescriptors2 = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sn" ascending:YES]];
                    [trackMulArray sortUsingDescriptors:sortDescriptors2];
                    
                    [scrollView setContentSize:CGSizeMake(MAINWIDTH,self.pullTableView.bottom + 44)];
                    //statusMulArray = mulArray;
                    hasTrackBool = YES;
                    checkDateBool = NO;
                    [self crateCheckInShiftTableView];
                    workTypeStr = [[CheckInTrack parseFromData:[cr.datas objectAtIndex:0]].checkInShiftGroup.shift.name retain];
                }else {
                    workTypeStr = @"";
                    [scrollView setContentSize:CGSizeMake(MAINWIDTH,self.WifitableView.bottom + 44)];
                }
                
                [_WifitableView reloadData];
                
            }
        }
        default:
            break;
    }
    
    [super showMessage2:cr Title:TITLENAME(FUNC_ATTENDANCE_DES) Description:@""];
}

@end
