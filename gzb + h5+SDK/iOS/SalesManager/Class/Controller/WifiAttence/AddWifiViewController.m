//
//  AddWifiViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/11/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "AddWifiViewController.h"
#import "UIView+CNKit.h"
#import "Constant.h"

@interface AddWifiViewController ()

@end


@implementation AddWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听网络改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshWifi) name:@"network_change" object:nil];
    //自动更新地理位置
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
     
                                            object:nil];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAction)];
    [tapGesture1 setNumberOfTapsRequired:1];
    saveImageView.userInteractionEnabled = YES;
    [saveImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:saveImageView];
    
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
 
    self.rightButton = btRight;
    [btRight release];

    //添加wifi设备表格
    addWifiTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 250) style:UITableViewStylePlain];
    addWifiTabView.delegate = self;
    addWifiTabView.dataSource = self;
    addWifiTabView.scrollEnabled = NO;
    self.view.backgroundColor = WT_WHITE;
    [self.view addSubview:addWifiTabView];
    
    [lblFunctionName setText:@"添加WIFI设备"];
    
}

#pragma mark 自动更新地理位置
-(void)autorefreshLocation {
    [super refreshLocation];
    [addWifiTabView reloadData];

}

#pragma mark 网络变化时，自动更新
-(void)reFreshWifi {
    [addWifiTabView reloadData];
}

#pragma mark 提交操作
-(void)submitAction {
    if (remarks.length > 200) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"input_limit_over", @"")type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![self getWifiName].length || ![self getMacAddress].length ) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"no_get_wifi_information", @"")type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    NSLog(@"提交WIFI设备");
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    CheckInWifi_Builder *cb = [CheckInWifi builder];
    [cb setId:-1];
    [cb setUser:USER];
    [cb setName:[self getWifiName]];
    [cb setMacAddress:[self getMacAddress]];
    [cb setComment:remarks];
    [cb setLocation:APPDELEGATE.myLocation];
   
  
    if (DONE != [AGENT sendRequestWithType:ActionTypeCheckinWifiSave param:[cb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }

}

-(void)didReceiveMessage:(id)message {

    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:@"添加成功"
                                 type:MessageBarMessageTypeSuccess
                          forDuration:SUCCESS_MSG_DURATION];
        remarks = @"";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWifilist" object:nil];
        
        [addWifiTabView reloadData];
 
    }else {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:cr.resultMessage
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];

    
    }
}

#pragma mark - tabViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identStr = @"addWifi";
    cell = [tableView dequeueReusableCellWithIdentifier:identStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identStr];
    }
    if (indexPath.row == 0) {
           cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
 
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        if ([self getWifiName] == nil) {
         cell.textLabel.text = @"未开启WIFI不能添加，点击开启";
        }else {
         cell.textLabel.text = [NSString stringWithFormat:@"WIFI名称: %@",[self getWifiName]];
        }
       
    }else if (indexPath.row == 1){
       cell.textLabel.text = [NSString stringWithFormat:@"MAC地址: %@",[self getMacAddress]];
    }else if (indexPath.row == 2){
        locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:identStr];
        if(locationCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[LocationCell class]])
                    locationCell=(LocationCell *)oneObject;
            }
        }
        
        if (APPDELEGATE.myLocation != nil) {
            if (!APPDELEGATE.myLocation.address.isEmpty) {
                [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
            }else{
                [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
            }
        }
         locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
        
        cell = locationCell;
    }else if (indexPath.row == 3) {
        txtCell=(TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identStr];
        if(txtCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[TextFieldCell class]])
                    txtCell=(TextFieldCell *)oneObject;
            }
        }
       // txtCell.txtField.frame = CGRectMake(10, 0, 300, 200);
        txtCell.selectionStyle = UITableViewCellSelectionStyleNone;
        txtCell.title.text = NSLocalizedString(@"memo", nil);
        txtCell.txtField.delegate=self;
        txtCell.txtField.text = @"选填（200字以内）";
        txtCell.txtField.textColor = [UIColor lightGrayColor];
        CGRect rect = txtCell.txtField.frame;
        rect.size.height = 100;
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
        

    
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 100;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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

}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"选填（200字以内）"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<1) {
        textView.text = @"选填（200字以内）";
        textView.textColor = [UIColor lightGrayColor];
    }
     remarks = [textView.text copy];
}


#pragma mark 更新地理位置
-(void)refreshLocation {
    [super refreshLocation];
    [addWifiTabView reloadData];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 返回
-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
