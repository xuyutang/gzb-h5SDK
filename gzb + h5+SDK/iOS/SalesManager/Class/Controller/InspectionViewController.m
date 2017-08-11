//
//  InspectionViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "InspectionTargetCell.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "InspectionListViewController.h"
//#import "PatrolPictureListViewController.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "InspectionStatusViewController.h"


@interface InspectionViewController ()
{
    float pickerViewCellHeight;
}
@end

@implementation InspectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    currentStatusList = [[NSMutableArray alloc] init];
    nCurrentCell = -1;
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    inspectionCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getInspectionCategories]];
    if ([inspectionCategories count]>0) {
        currentInspectionCategory = [inspectionCategories objectAtIndex:0];
    }
    if (tagetArray != nil && tagetArray.count >0) {
        [tagetArray removeAllObjects];
    }
    tagetArray = [[NSMutableArray alloc] initWithCapacity:0];
    checkedTargets = [[NSMutableArray alloc] initWithCapacity:0];
    
    [tagetArray addObjectsFromArray:[[LOCALMANAGER getInspectionTargetsWithChildPage:1 parentId:0] retain]];
    inspectionStatus = [[NSMutableArray alloc] initWithArray:[[LOCALMANAGER getInspectionStatus] retain]];
    for (InspectionStatus *status in inspectionStatus) {
        if (status.isDefault) {
            [currentStatusList addObject:[status retain]];
            break;
        }
    }
    textViewCell.textView.text = @"";
    textViewCell.textView.placeHolder = @"选填（1000字以内）";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData];
    
    //    UIImageView *picListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 30)];
    //    [picListImageView setImage:[UIImage imageNamed:@"topbar_button_pic"]];
    //    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPicture:)];
    //    [tapGesture3 setNumberOfTapsRequired:1];
    //    picListImageView.userInteractionEnabled = YES;
    //    picListImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [picListImageView addGestureRecognizer:tapGesture3];
    //    [rightView addSubview:picListImageView];
    //    [picListImageView release];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
       saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    tableView.backgroundColor = WT_WHITE;
    [self.view addSubview:tableView];
    
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT, MAINWIDTH, 251.0) tag:self];
    [self.view addSubview:pickerView];
    
    appDelegate = APPDELEGATE;
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_INSPECTION_DES)];
    
    AGENT.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSync)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_INSPECTION_DES)];
}

-(void)viewWillAppear:(BOOL)animated{
    if (bHasSync) {
//        inspectionCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getInspectionCategories]];
//        if ([inspectionCategories count]>0) {
//            currentInspectionCategory = [inspectionCategories objectAtIndex:0];
//        }
        if (tagetArray != nil) {
            [tagetArray removeAllObjects];
        }
        [tagetArray addObjectsFromArray:[[LOCALMANAGER getInspectionTargetsWithChildPage:1 parentId:0] retain]];
        inspectionStatus = [[NSMutableArray alloc] initWithArray:[[LOCALMANAGER getInspectionStatus] retain]];
        if (currentStatusList != nil) {
            [currentStatusList release];
            currentStatusList = [[NSMutableArray alloc] init];
        }
        
        for (InspectionStatus *status in inspectionStatus) {
            if (status.isDefault) {
                [currentStatusList addObject:[status retain]];
                break;
            }
        }
        
        [tableView reloadData];
    }
    bHasSync = NO;
}

-(void)hasSync{
    bHasSync = YES;
}


-(void)toList:(id)sender{
    
    [self dismissKeyBoard];
    InspectionListViewController *tctrl = [[InspectionListViewController alloc] init];
    [self.navigationController pushViewController:tctrl animated:YES];
    
}

-(void)toPicture:(id)sender{
    [self dismissKeyBoard];
    //PatrolPictureListViewController *ctrl = [[PatrolPictureListViewController alloc] init];
    //[self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    
    if (currentInspectionCategory == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)
                          description:NSLocalizedString(@"inspection_hint_category_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (checkedTargets == nil || checkedTargets.count <1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)

                          description:NSLocalizedString(@"inspection_hint_target_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (imageFiles == nil || [imageFiles count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)

                          description:NSLocalizedString(@"patrol_hint_files", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
//    if (textViewCell.textView.text == nil || textViewCell.textView.text.length == 0) {
//        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)
//
//                          description:NSLocalizedString(@"patrol_hint_content", @"")
//                                 type:MessageBarMessageTypeInfo
//                          forDuration:INFO_MSG_DURATION];
//        
//        return;
//    }
    
    if ([NSString stringContainsEmoji:textViewCell.textView.text]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)

                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    InspectionReport_Builder* pb = [InspectionReport builder];
    
    [pb setId:-1];
    
    if(textViewCell.textView.text != nil && textViewCell.textView.text.length>0){
        [pb setContent:textViewCell.textView.text];
    }
    
    [pb setInspectionReportCategory:currentInspectionCategory];
    //清除展示的父类对象
    NSMutableArray *tmpCheckedTargets = [[[NSMutableArray alloc] init] autorelease];
    for (InspectionTarget *target in checkedTargets) {
        if (target.inspectionStatus.count > 0) {
            [tmpCheckedTargets addObject:target];
        }
    }
    //    [tmpCheckedTargets removeObjectsInArray:clearArray];
    [pb setInspectionTargetsArray:tmpCheckedTargets];
    if (appDelegate.myLocation != nil){
        [pb setLocation:appDelegate.myLocation];
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in liveImageCell.imageFiles) {
        UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
        NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
        [images addObject:dataImg];
    }
    [pb setFilesArray:images];
    
    AGENT.delegate = self;
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeInspectionReportSave param:[[pb build] retain]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_INSPECTION_DES)

                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            return 50;
        }
            break;
        case 1:{
            return 120;
        }
            break;
        case 2:{
            return 130;
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                return 0;
            }
            if (indexPath.row == 2+checkedTargets.count) {
                return 0;
            }else if (checkedTargets.count>0 && (indexPath.row>1 && indexPath.row < (checkedTargets.count+2))){
                float height = 80.f;
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                height = [[[[InspectionTargetCell alloc] init] autorelease] getHeight:target.name number:target.serialNumber value:@"  " status:[self getInspectionStatusName:target]];
                return height;
            }
            return 40;

        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_inspect_target_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_live_image", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"title_live_info", nil);
        }
            break;
        case 3:{
            return NSLocalizedString(@"title_location_info", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    if ( section == 3) {
        return 2+checkedTargets.count;
    } else{
        return 1;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                InspectionTypeViewController *itvctrl = [[InspectionTypeViewController alloc] init];
                itvctrl.delegate = self;
                itvctrl.bFavorate = NO;
                itvctrl.bNeedAll = NO;
                UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:itvctrl];
                [self presentViewController:patrolNavCtrl animated:YES completion:nil];
                [ctrl release];
            }else if(indexPath.row == 1){
                if (ctrl == nil) {
                    ctrl = [[InspectionTargetsViewController alloc] init];
                    ctrl.selectedArray = checkedTargets;
                    ctrl.targetArray = tagetArray;
                    ctrl.delegate = self;
                    customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                }
                
               // [self presentViewController:customerNavCtrl animated:YES completion:nil];
                //[ctrl release];
                //[customerNavCtrl release];
            }else if (checkedTargets.count>0 && (indexPath.row>1 && indexPath.row < (checkedTargets.count+2))){
                BOOL bDefault = NO;
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                if (![self canOperateTarget:target] || target.inspectionStatus.count == 0){
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return;
                }
                nCurrentCell = indexPath.row -2;
                InspectionStatusViewController *vc = [[InspectionStatusViewController alloc] init];
                //选择状态回调
                vc.checkDone = ^(NSMutableArray *status){
                    [self confirmPicker:status];
                };
                vc.bNeedBack = YES;
                NSMutableArray *modelStatus;
                InspectionModel *model = target.inspectionModel;
                if (model == nil) {
                    bDefault = YES;
                    modelStatus = inspectionStatus;
                }else{
                    modelStatus = [LOCALMANAGER getInspectionStatusWithModelId:model.id];
                    if (modelStatus.count == 0) {
                        bDefault = YES;
                        modelStatus = inspectionStatus;
                    }
                }
                vc.status = modelStatus;
                vc.currentStatusList = [target.inspectionStatus toArrayList];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                [nav release];
                [vc release];
            }
            
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                InspectionTypeViewController *itvctrl = [[InspectionTypeViewController alloc] init];
                itvctrl.delegate = self;
                itvctrl.allBool = NO;
                itvctrl.bFavorate = NO;
                itvctrl.bNeedAll = NO;
                UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:itvctrl];
                [self presentViewController:patrolNavCtrl animated:YES completion:nil];
                [ctrl release];
            }else if(indexPath.row == 1){
                if (ctrl == nil) {
                    ctrl = [[InspectionTargetsViewController alloc] init];
                    ctrl.selectedArray = checkedTargets;
                    ctrl.targetArray = tagetArray;
                    ctrl.delegate = self;
                    customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                }
                
                [self presentViewController:customerNavCtrl animated:YES completion:nil];
                //[ctrl release];
                //[customerNavCtrl release];
            }else if (checkedTargets.count>0 && (indexPath.row>1 && indexPath.row < (checkedTargets.count+2))){
                BOOL bDefault = NO;
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                if (![self canOperateTarget:target] || target.inspectionStatus.count == 0){
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return;
                }
                nCurrentCell = indexPath.row -2;
                InspectionStatusViewController *vc = [[InspectionStatusViewController alloc] init];
                //选择状态回调
                vc.checkDone = ^(NSMutableArray *status){
                    [self confirmPicker:status];
                };
                vc.bNeedBack = YES;
                NSMutableArray *modelStatus;
                InspectionModel *model = target.inspectionModel;
                if (model == nil) {
                    bDefault = YES;
                    modelStatus = inspectionStatus;
                }else{
                    modelStatus = [LOCALMANAGER getInspectionStatusWithModelId:model.id];
                    if (modelStatus.count == 0) {
                        bDefault = YES;
                        modelStatus = inspectionStatus;
                    }
                }
                vc.status = modelStatus;
                vc.currentStatusList = [target.inspectionStatus toArrayList];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                [nav release];
                [vc release];
            }
            
        }
            break;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            if (checkedTargets.count>0 && (indexPath.row>1 && indexPath.row < (checkedTargets.count+2))){
                InspectionTargetCell *targetCell =(InspectionTargetCell *)[tableView dequeueReusableCellWithIdentifier:@"InspectionTargetCell"];
                if(targetCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InspectionTargetCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[InspectionTargetCell class]])
                            targetCell=(InspectionTargetCell *)oneObject;
                    }
                }
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                
                
                if (target.parentId != 0) {
                    targetCell.name.text = [NSString stringWithFormat:@"    %@",target.name];
                    targetCell.number.text = [NSString stringWithFormat:@"    %@",target.serialNumber];
                }else{
                    targetCell.name.text = target.name;
                    targetCell.number.text = target.serialNumber;
                }
                
                if (![self canOperateTarget:target] || target.inspectionStatus.count == 0) {
                    targetCell.value.text = @"";
                }else if (target.inspectionStatus.count > 0) {
                    targetCell.value.text = [self getInspectionStatusName:target];
                }
                [targetCell resetFrame:target.name number:target.serialNumber];
                return targetCell;
            }
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                if (indexPath.row == 0){
                    selectCell.title.text = @"类型";
                    if ([inspectionCategories count]>0) {
                        selectCell.value.text = currentInspectionCategory.name;
                    }else{
                        selectCell.value.text = @"";
                    }
                    
//                }else if(indexPath.row == 1){
//                    selectCell.title.text = NSLocalizedString(@"inspection_label_target", nil);
//                    selectCell.value.text = @"";
                }else if(indexPath.row == 1){
                    locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(locationCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[LocationCell class]])
                                locationCell=(LocationCell *)oneObject;
                        }
                    }
                    
                    locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    if (appDelegate.myLocation != nil) {
                        if (!appDelegate.myLocation.address.isEmpty) {
                            [locationCell.lblAddress setText:appDelegate.myLocation.address];
                        }else{
                            [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",appDelegate.myLocation.latitude,appDelegate.myLocation.longitude]];
                        }
                    }
                    [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                    
                    return locationCell;
                }
            }else{
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                selectCell.title.text = target.name;
                if (target.inspectionStatus.count > 0) {
                    selectCell.value.text = [self getInspectionStatusName:target];
                }else{
                    selectCell.value.text = @"";
                }
                
            }
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
        }
            break;
        case 1:{
            
            if(liveImageCell==nil){
                liveImageCell = [[LiveImageCell alloc] init];
                liveImageCell.delegate = self;
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 2:{
            
            if (textViewCell == nil) {
                textViewCell = [[CommonPhrasesTextViewCell alloc] init];
                textViewCell.textView.placeHolder = @"选填（1000字以内）";
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                
                NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                [doneButton release];
                [btnSpace release];
                [helloButton release];
                
                [topView setItems:buttonsArray];
                //[textViewCell.textView setInputAccessoryView:topView];
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
            }
            
            return textViewCell;
            
        }
            break;
        case 3:{
            if (checkedTargets.count>0 && (indexPath.row>1 && indexPath.row < (checkedTargets.count+2))){
                InspectionTargetCell *targetCell =(InspectionTargetCell *)[tableView dequeueReusableCellWithIdentifier:@"InspectionTargetCell"];
                if(targetCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InspectionTargetCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[InspectionTargetCell class]])
                            targetCell=(InspectionTargetCell *)oneObject;
                    }
                }
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                
                
                if (target.parentId != 0) {
                    targetCell.name.text = [NSString stringWithFormat:@"    %@",target.name];
                    targetCell.number.text = [NSString stringWithFormat:@"    %@",target.serialNumber];
                }else{
                    targetCell.name.text = target.name;
                    targetCell.number.text = target.serialNumber;
                }
                
                if (![self canOperateTarget:target] || target.inspectionStatus.count == 0) {
                    targetCell.value.text = @"";
                }else if (target.inspectionStatus.count > 0) {
                    targetCell.value.text = [self getInspectionStatusName:target];
                }
                [targetCell resetFrame:target.name number:target.serialNumber];
                return targetCell;
            }
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                if (indexPath.row == 0){
                    selectCell.title.text = @"";
                    if ([inspectionCategories count]>0) {
                        selectCell.value.text = @"";
                    }else{
                        selectCell.value.text = @"";
                    }
                    
                }else if(indexPath.row == 1){
                    selectCell.title.text = NSLocalizedString(@"inspection_label_target", nil);
                    selectCell.value.text = @"";
                }else if(indexPath.row == 2+checkedTargets.count){
                    locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(locationCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[LocationCell class]])
                                locationCell=(LocationCell *)oneObject;
                        }
                    }
                    
                    locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    locationCell.btnRefresh.hidden = YES;
                    if (appDelegate.myLocation != nil) {
                        if (!appDelegate.myLocation.address.isEmpty) {
                            [locationCell.lblAddress setText:@""];
                        }else{
                            [locationCell.lblAddress setText:@""];
                        }
                    }
                    [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                    
                    return locationCell;
                }
            }else{
                InspectionTarget *target = [checkedTargets objectAtIndex:indexPath.row-2];
                selectCell.title.text = target.name;
                if (target.inspectionStatus.count > 0) {
                    selectCell.value.text = [self getInspectionStatusName:target];
                }else{
                    selectCell.value.text = @"";
                }
                
            }
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
        }
            break;
 
            
        default:
            break;
    }
    
    return cell;
    
}


-(NSString *) getInspectionStatusName:(InspectionTarget *) target{
    NSMutableString *sb = [[NSMutableString alloc] init];
    for (InspectionStatus *status in target.inspectionStatus) {
        [sb appendString:status.name];
        [sb appendString:@"   "];
    }
    return sb;
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

-(void)InspectionTargetsdidFnishedCheck:(NSMutableArray *)targets{
    //tagetArray = [targets retain];
    //unCheckedParents = [[NSMutableArray alloc] initWithCapacity:0];
    //resultCheckedTargets = [[NSMutableArray alloc] initWithArray:[targets retain]];
    //    for (InspectionTarget *target in targets) {
    //        [self addParent:target];
    //    }
    checkedTargets = nil;
    checkedTargets = [[NSMutableArray alloc] initWithArray:targets];
    
    //[self sortArray];
    for (int i=0;i<checkedTargets.count;i++) {
        InspectionTarget *target = [checkedTargets objectAtIndex:i];
        InspectionTarget_Builder* itb = (InspectionTarget_Builder*)[target toBuilder];
        if (target.parentId == -1) {
            [itb setParentId:0];
            [itb clearInspectionStatus];
        }else{
            NSMutableArray *status = nil;
            if (!target.hasInspectionModel) {
                status = currentStatusList;
            }else{
                //没有默认的情况下取第一条
                status = [LOCALMANAGER getInspectionDefaultStatusWithModelId:target.inspectionModel.id];
                if (status.count == 0) {
                    InspectionStatus *tmpStatus = [LOCALMANAGER getInspectionStatusWithModelId:target.inspectionModel.id].firstObject;
                    status = [[NSMutableArray alloc] initWithObjects:tmpStatus, nil];
                }
                if (status.count == 0) {
                    status = currentStatusList;
                }
            }
            [itb setInspectionStatusArray:status];
        }
        InspectionTarget * tmp = [itb build];
        [checkedTargets removeObjectAtIndex:i];
        [checkedTargets insertObject:tmp atIndex:i];
    }
    [tableView reloadData];
}

- (void)inspectionSearch:(InspectionTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentInspectionCategory = [(InspectionReportCategory *)aObject retain];
    [tableView reloadData];
    
}
- (void)inspectionSearchDidCanceled:(InspectionTypeViewController *)controller{
    
}

-(BOOL)isExist:(InspectionTarget*) item{
    for (InspectionTarget *target in resultCheckedTargets) {
        if (item.id == target.id) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)canOperateTarget:(InspectionTarget*) item{
    for (InspectionTarget* target in unCheckedParents) {
        if (target.id == item.id) {
            return NO;
        }
    }
    return YES;
}

-(void)addParent:(InspectionTarget*) item{
    if (item.parentId == 0) {
        return;
    }
    for (InspectionTarget *target in tagetArray) {
        if (target.id == item.parentId) {
            if(![self isExist:target]){
                [unCheckedParents addObject:target];
                [resultCheckedTargets addObject:target];
            }
            [self addParent:target];
            break;
        }
    }
}

-(void)sortArray{
    for (InspectionTarget *target in tagetArray) {
        BOOL bChecked = NO;
        for (InspectionTarget *checkedTarget in resultCheckedTargets) {
            if (target.id == checkedTarget.id) {
                bChecked = YES;
                break;
            }
        }
        if (bChecked && (target.parentId == 0)) {
            [checkedTargets addObject:target];
            [self addChild:target];
        }
    }
}

-(void)addChild:(InspectionTarget*) item{
    for (InspectionTarget *target in resultCheckedTargets) {
        if (target.parentId == item.id) {
            [checkedTargets addObject:target];
            [self addChild:target];
        }
    }
}

#pragma mark - picker

//-(void)dismiss{
//    [self closePicker];
//}
//
//-(void)confirm{
//    [self confirmPicker];
//}
//
//-(void)showPicker{
//    if (pickerView.frame.origin.y == MAINHEIGHT-251) {
//        return;
//    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.3];
//    pickerView.frame = CGRectMake(0, MAINHEIGHT-251, 320, 251);
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
//}
//
//-(void)closePicker{
//    if (pickerView.frame.origin.y == MAINHEIGHT) {
//        return;
//    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.3];
//    pickerView.frame = CGRectMake(0, MAINHEIGHT, 320, 260);
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
//}

-(void)confirmPicker:(NSMutableArray *) status{
    //[self closePicker];
    if (status.count > 0) {
        InspectionTarget_Builder* ib = [((InspectionTarget*)[checkedTargets objectAtIndex:nCurrentCell]) toBuilder];
        [ib setInspectionStatusArray:status];
        InspectionTarget * tmp = [ib build];
        [checkedTargets removeObjectAtIndex:nCurrentCell];
        [checkedTargets insertObject:tmp atIndex:nCurrentCell];
        // [[[[((InspectionTarget *)[checkedTargets objectAtIndex:nCurrentCell]) toBuilder] setInspectionStatus:currentStatus] retain] build];
    }
    [tableView reloadData];
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
//
//{
//    return 1;
//}
//
//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
////    NSString *str = ((InspectionStatus *)[inspectionStatus objectAtIndex:row]).name;
////    CGSize size = [str rebuildSizeWtihContentWidth:MAINWIDTH FontSize:25.f];
//
//    NSLog(@"%d",component);
//    return 40;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
//    NSString *str = ((InspectionStatus *)[inspectionStatus objectAtIndex:row]).name;
//    UILabel *lable = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 1000)] autorelease];
//    CGSize size = [str rebuildSizeWtihContentWidth:MAINWIDTH FontSize:25.f];
//    lable.font = [UIFont systemFontOfSize:25.f];
//    lable.frame = CGRectMake(0, 0, MAINWIDTH, MAX(size.height, 40));
//
//    lable.numberOfLines = 0;
//    lable.textAlignment = UITextAlignmentCenter;
//    lable.lineBreakMode = NSLineBreakByCharWrapping;
//    lable.backgroundColor = WT_GREEN;
//    lable.text = str;
//    return lable;
//}
//
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [inspectionStatus count];
//}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//
//{
//    return ((InspectionStatus *)[inspectionStatus objectAtIndex:row]).name;
//}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//
//{
//    currentStatusList = [[[NSMutableArray alloc] initWithObjects:[inspectionStatus objectAtIndex:row], nil] autorelease];
//}

-(void)addPhoto{
    
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image
{
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
- (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    if (image.size.width > image.size.height) {
        newSize.width = (newSize.height/image.size.height) *image.size.width;
    }else{
        newSize.height = (newSize.width/image.size.width) *image.size.height;
    }
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [self fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] ;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    [imageFiles addObject:imagePath];
    [liveImageCell insertPhoto:imagePath];
    
    //[imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)dismissKeyBoard
{
    if (textViewCell.textView != nil) {
        [textViewCell.textView resignFirstResponder];
    }
}

-(IBAction)clearInput{
    
    textViewCell.textView.text = @"";
    
}

- (void)dealloc {
    
    [imageFiles release];
    [rightView release];
    [tableView release];
    [liveImageCell release];
    [textViewCell release];
    if (ctrl != nil) {
        [ctrl release];
        [customerNavCtrl release];
    }
    
    [super dealloc];
}
- (void)viewDidUnload {
    [imageFiles release];
    imageFiles = nil;
    [rightView release];
    rightView = nil;
    [tableView release];
    tableView = nil;
    [liveImageCell release];
    liveImageCell = nil;
    [textViewCell release];
    textViewCell = nil;
    if (ctrl != nil) {
        [ctrl release];
        [customerNavCtrl release];
    }
    
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeInspectionReportSave:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (cr.hasData) {
                    Customer* c = [Customer parseFromData:cr.data];
                    if ([super validateData:c]) {
                        if (c != nil){
                            [LOCALMANAGER saveCustomer:c];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
                        }
                    }
                }
                
                [liveImageCell clearCell];
              //  textViewCell.textView.placeHolder = @"";
                /*
                                                  [currentCustomer release];
                                                  currentCustomer = nil;*/
                [self initData];
                [tableView reloadData];
                
                //成功后释放巡检对象选择器
                [ctrl release];
                ctrl = nil;
                [customerNavCtrl release];
                customerNavCtrl = nil;
            }
            
            [super showMessage2:cr Title:TITLENAME(FUNC_INSPECTION_DES)
             Description:NSLocalizedString(@"inspection_msg_saved", @"")];
            
        }
            break;
            
        default:
            break;
    }
}

@end
