//
//  SettingsViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "AboutViewController.h"
#import "CategoryPickerView.h"

//CELL 排列序号
#define CELL_MESSAGE 3
#define CELL_ABOUT 4
#define CELL_SERVER_TEL 5
#define CELL_VERSION 6
#define CELL_DATA_ASYNC 1
#define CELL_UPDATA_PASSWORD 7
#define CELL_COMMON_PHRASES 0
#define CELL_LOGIN_OUT 8
#define CELL_MY_FAV 2

@interface SettingsViewController ()<UIActionSheetDelegate,RequestAgentDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CategoryPickerDelegate>

@end

@implementation SettingsViewController
{
    NSMutableArray     *_videoDurations;
    int                 _selectIndex;
    CategoryPickerView *_pickerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    
    _videoDurations = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getVideoDurationCategories]];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH , MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.bounces = NO;
    tableView.allowsSelection = YES;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
    
    _pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT + 64, MAINWIDTH, 251.0) tag:self];
    _pickerView.picker.delegate = self;
    _pickerView.picker.dataSource = self;
    [self.view addSubview:_pickerView];
    [_pickerView release];
    
    [lblFunctionName setText:NSLocalizedString(@"pref_title", @"")];
    
    [_pickerView.picker selectRow:[self getPickerDefaultSelectRow] inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == CELL_ABOUT){
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_ABOUT Object:nil Delegate:nil NeedBack:YES];
        return;
    }
    if (indexPath.row == CELL_SERVER_TEL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICE_TEL]];
    }
    if (indexPath.row == CELL_VERSION) {
        if ([AGENT isExistenceNetwork]){
            [self checkVersion];
        }else{
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_other_checkversion", @"")
                              description:NSLocalizedString(@"error_network_unfind", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
    }
    if (indexPath.row == CELL_DATA_ASYNC) {
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_SYNC Object:nil Delegate:nil NeedBack:YES];
    }
    if (indexPath.row == CELL_UPDATA_PASSWORD) {
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_CHANGE_PASSWORD Object:nil Delegate:nil NeedBack:YES];
    }
    if (indexPath.row == CELL_COMMON_PHRASES) {
        NSLog(@"设置常用语");
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_COMMON_PHRASES Object:NO Delegate:nil NeedBack:YES];
    }else if (indexPath.row == CELL_LOGIN_OUT){
        UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"msg_system_exit_desc", @"")
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"no", @"")
                                     destructiveButtonTitle:NSLocalizedString(@"msg_system_exit", @"")
                                     otherButtonTitles:nil,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
    if (indexPath.row == CELL_MY_FAV) {
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_FAVORATE Object:nil Delegate:nil NeedBack:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    if (indexPath.row == CELL_MESSAGE) {
        messageCell=(SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(messageCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SettingsCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[SettingsCell class]])
                    messageCell=(SettingsCell *)oneObject;
            }
        }
        messageCell.textLabel.text = NSLocalizedString(@"pref_notification", nil);
        messageCell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        if ([LOCALMANAGER getValueFromUserDefaults:KEY_MESSAGE].intValue == 0){
            [messageCell.sw setOn:YES];
        }else{
            [messageCell.sw setOn:NO];
        }
        messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [messageCell.sw addTarget:self action:@selector(swValue:) forControlEvents:UIControlEventValueChanged];
        cell = messageCell;
    }/*else if(indexPath.row == 1){
        locationCell=(SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(locationCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SettingsCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[SettingsCell class]])
                    locationCell=(SettingsCell *)oneObject;
            }
        }
        locationCell.title.text = NSLocalizedString(@"pref_location", nil);
        if ([LOCALMANAGER getLocationSetting] == 0){
            [locationCell.sw setOn:YES];
        }else{
            [locationCell.sw setOn:NO];
        }
        [locationCell.sw addTarget:self action:@selector(swValue:) forControlEvents:UIControlEventValueChanged];
        locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = locationCell;
        
    }*/else if (indexPath.row == CELL_ABOUT){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"pref_about", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_SERVER_TEL){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_other_service", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_VERSION){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_other_checkversion", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_DATA_ASYNC){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_function_datasync", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_UPDATA_PASSWORD){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_function_changepwd", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_COMMON_PHRASES){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_function_common_phrases", nil);
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_LOGIN_OUT){
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"menu_function_logout", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }else if (indexPath.row == CELL_MY_FAV){//my_favorate
        UITableViewCell *aboutcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!aboutcell) {
            aboutcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        aboutcell.textLabel.text = NSLocalizedString(@"my_favorate", @"");
        aboutcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aboutcell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        cell = aboutcell;
    }
    return cell;
}

- (void) swValue:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    /*if(control == locationCell.sw){
        BOOL on = control.on;
        if (on){
            [LOCALMANAGER saveLocationSetting:0];
            [(APPDELEGATE).mapView setUserInteractionEnabled:YES];
        }else{
            [LOCALMANAGER saveLocationSetting:1];
            [(APPDELEGATE).mapView setUserInteractionEnabled:NO];
        }
    }*/
    if(control == messageCell.sw){
        BOOL on = control.on;
        if (on){
            [LOCALMANAGER saveValueToUserDefaults:KEY_MESSAGE Value:@"0"];
        }else{
            [LOCALMANAGER saveValueToUserDefaults:KEY_MESSAGE Value:@"1"];
        }
    }
}

-(void)checkVersion{
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_other_checkversion", @"")
                      description:NSLocalizedString(@"msg_update_info", @"")
                             type:MessageBarMessageTypeInfo
                      forDuration:ERR_MSG_DURATION];
    
    [[UpdateVersion sharedInstance] setAppID:@"688032620"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[UpdateVersion sharedInstance] setAlertType:AlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. Store, you must specify the two-letter
     country code for the region in which your applicaiton is available in. */
    //[[UpdateVersion sharedInstance] setCountryCode:@"<countryCode>"];
    
    // Perform check for new version of your app
    [[UpdateVersion sharedInstance] checkVersion:TRUE];
}

- (void) logout{
    if (![AGENT isExistenceNetwork]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_network_unfind", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Log_Builder* ub = [Log builder];
    if (APPDELEGATE.myLocation != nil) {
        [ub setLocation:APPDELEGATE.myLocation];
    }
    [ub setType:NS_USERLOGTYPE(LogTypeLogout)];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeLogout param:[ub build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
        
    }
    
}


-(void)dismiss{
    
    [self closePicker];
}

-(void)confirm{
    VideoDurationCategory *duration = _videoDurations[_selectIndex ];
    [LOCALMANAGER favVideoDurationCategory:duration.id];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"video_take_duration", nil),duration.durationValue];
    [self closePicker];
}

-(void)showPicker{
    if (_pickerView.frame.origin.y == MAINHEIGHT-251) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    _pickerView.frame = CGRectMake(0, MAINHEIGHT-251, 320, 251);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)closePicker{
    if (_pickerView.frame.origin.y == MAINHEIGHT+64) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    _pickerView.frame = CGRectMake(0, MAINHEIGHT+64, 320, 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self logout];
        }
            break;
        case 1:{
            
        }
            break;
        default:
            break;
    }
    
}

- (void) didReceiveMessage:(id)message{
//    SessionResponse* cr = [SessionResponse parseFromData:message];
    
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeLogout:{
            HUDHIDE;

            if(![LOCALMANAGER cleanLoginUser]){
                NSLog(@"clean login user error.");
                return;
            }
            
            [AGENT close];
            APPDELEGATE.currentUser = nil;
            USER = nil;
            [VIEWCONTROLLER create:nil ViewId:FUNC_LOGOUT Object:nil Delegate:self NeedBack:NO];
            [LOCALMANAGER saveShiftGroup:nil];
            APPDELEGATE.bFirstLogin = TRUE;
            [self dismissModalViewControllerAnimated:YES];
            [(APPDELEGATE) releaseAllPage];
        }}
            
        /*
    switch (INT_ACTIONTYPE(cr.type)) {
            
        case RequestTypeUserLogSave:{
            
            if (([cr.code isEqual: NS_RESULTCODE(ResultCodeResponseDone)])){
                
            }
        }
            break;
            
        default:
            break;
    }*/
}

#pragma -mark UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _videoDurations.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    VideoDurationCategory *duration = _videoDurations[row];
    return duration.durationValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectIndex = row;
}

-(int) getPickerDefaultSelectRow{
    VideoDurationCategory* videoDuration = [LOCALMANAGER getFavVideoDurationCategory];
    if (videoDuration == nil) {
        videoDuration = [[LOCALMANAGER getVideoDurationCategories] firstObject];
        if (videoDuration == nil) {
            return 0;
        }
    }
    for (int i = 0; i < _videoDurations.count; i++) {
        if ([((VideoDurationCategory*)_videoDurations[i]).durationValue isEqualToString:videoDuration.durationValue]) {
            return i;
        }
    }
    return 0;
}
@end
