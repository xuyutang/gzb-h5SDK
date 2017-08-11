//
//  PatrolViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "PatrolViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "PatrolListViewController.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "NSDate+Util.h"
#import "PatrolVideoDurationTypeController.h"
#import "FileHelper.h"
#import "UIView+CNKit.h"

@interface PatrolViewController ()<UIActionSheetDelegate,PatrolVideoDurationTypeDelegate,PickerVideoDelegate>

@end

@implementation PatrolViewController{
    int patrolType;//二选一 照片 视频
    int picOrVideo;//选中状态
    int locationCellIndex;
    int rowCount;
    BOOL bDeleting;
    
    //参数
    NSString *videoUrl;
    NSString *imageUrl;
    PatrolVideoDurationCategory *videoDuration;
    NSMutableArray *mediaList;
    UIImageView *saveImageView ;
}
@synthesize taskId,taskCustomer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData:(BOOL) bNeedClearImage {
    
    if ([imageFiles count]>0) {
        if (bNeedClearImage) {
            [LOCALMANAGER clearImagesWithFiles:imageFiles];
        }
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    patrolCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getPatrolCategories]];
    if ([patrolCategories count]>0) {
        currentPatrolCategory = [patrolCategories objectAtIndex:0];
    }
    
    if (self.customer != nil) {
        currentCustomer = [self.customer retain];
    }else{
        currentCustomer = taskCustomer;
    }
    textViewCell.textView.text = @"";
    
    [self initFunc];
    //记录locationCell 的位置
    [self refreshRowCountAndLocationIndex];
    if (pickerCell != nil) {
        [pickerCell release];
        pickerCell = nil;
    }
    if (imageUrl != nil && videoUrl != nil && imageUrl.length > 0 && videoUrl.length > 0) {
        [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithArray:@[imageUrl,videoUrl]]];
        imageUrl = nil;
        videoUrl = nil;
    }
    PatrolVideoDurationCategory *videoPickTime = [LOCALMANAGER getFavPatrolVideoDurationCategory];
    if (videoPickTime != nil) {
        videoDuration = [videoPickTime retain];
    }else{
        videoDuration = [[LOCALMANAGER getPatrolVideoDurationCategories].firstObject retain];
    }
    
    patrolPostTypeCell.checkbox.selectedSegmentIndex = 0;
}

-(void) initFunc {
    mediaList = [[LOCALMANAGER getPatrolMediaCategories] retain];
    if (mediaList.count >= 2) {
        patrolType = PatrolPostTypeImageAndVideo;
    }else{
        PatrolMediaCategory *mediaCategory = [mediaList firstObject];
        if (mediaCategory == nil || [mediaCategory.value isEqualToString:PATROL_FUNC_PICTURE]) {
            patrolType = PatrolPostTypeImage;
        }else{
            patrolType = PatrolPostTypeVideo;
        }
    }
    
    picOrVideo = PatrolPostTypeImage;
    if (patrolType == PatrolPostTypeImage || patrolType == PatrolPostTypeImageAndVideo) {
        picOrVideo = PatrolPostTypeImage;
    }else{
        picOrVideo = PatrolPostTypeVideo;
    }
}

-(void) refreshRowCountAndLocationIndex {
    if (patrolType == PatrolPostTypeImageAndVideo) {
        if (picOrVideo == PatrolPostTypeImage) {
            locationCellIndex = 3;
            rowCount = 4;
        }else{
            locationCellIndex = 4;
            rowCount = 5;
        }
        
    }else if (patrolType == PatrolPostTypeImage){
        locationCellIndex = 2;
        rowCount = locationCellIndex + 1;
    }else if (patrolType == PatrolPostTypeVideo){
        locationCellIndex = 3;
        rowCount = locationCellIndex + 1;
    }
}

//拍照 & 视频 切换
-(void) didCheckedChange:(UISegmentedControl *) obj {
    PatrolMediaCategory *mediaCategory = mediaList[obj.selectedSegmentIndex];
    if ([mediaCategory.value isEqualToString:PATROL_FUNC_PICTURE]) {
        picOrVideo = PatrolPostTypeImage;
    }else if([mediaCategory.value isEqualToString:PATROL_FUNC_VIDEO]){
        picOrVideo = PatrolPostTypeVideo;
    }else{
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:NSLocalizedString(@"", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    [self refreshRowCountAndLocationIndex];
    [tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData:YES];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    [tapGesture1 release];

    saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    if (self.hideListImagViewBool) {
        listImageView.hidden = YES;
        saveImageView.x = 100;
    }
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
   
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    [tapGesture2 release];
    
   
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    
    if (taskId != nil ||  bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
	
    if(tableView == nil)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    tableView.tableHeaderView.hidden = YES;
    [self.view addSubview:tableView];
    
    appDelegate = APPDELEGATE;
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_PATROL_DES)];
    AGENT.delegate = self;
    if (self.customer != nil) {
        currentCustomer = [self.customer retain];
    }
    
    //同步后及时更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:SYNC_VIDEO_MEDIA
                                               object:nil];
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_PATROL_DES)];
}

-(void) refreshUI{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"更新巡访媒体类型,即时刷新UI");
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        [self viewDidLoad];
        });
}

-(void)clickLeftButton:(id)sender {
    if (taskId != nil ||  bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
        //[self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
}

-(void)toList:(id)sender {
    [self dismissKeyBoard];
    PatrolListViewController *ctrl = [[PatrolListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)toPicture:(id)sender {
    [self dismissKeyBoard];
}

-(BOOL) validate {
    [self dismissKeyBoard];
    if (currentCustomer == nil && taskCustomer == nil) {
    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)
                          description:NSLocalizedString(@"patrol_hont_customer_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    
    if (currentPatrolCategory == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                          description:NSLocalizedString(@"patrol_hint_category_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    
    if (picOrVideo == PatrolPostTypeImage) {
        if (imageFiles == nil || [imageFiles count]<1) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                              description:NSLocalizedString(@"patrol_hint_files", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return NO;
        }
    }
    
    if (picOrVideo == PatrolPostTypeVideo) {
        if (videoDuration == nil) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                              description:NSLocalizedString(@"patrol_hint_video_duration", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return NO;
        }
        if (videoUrl.length == 0 || imageUrl.length == 0) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                              description:NSLocalizedString(@"patrol_hint_video", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return NO;
        }
    }
    
    if (textViewCell.textView.text == nil || textViewCell.textView.text.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)
              description:NSLocalizedString(@"patrol_hint_content", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return NO;
    }
    
    if (textViewCell.textView.text.length > 1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)
                          description:NSLocalizedString(@"patrol_hint_content_limit1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return NO;
    }

    if ([NSString stringContainsEmoji:textViewCell.textView.text]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return NO;
    }
    return YES;
}

-(void) saveCache {
    BOOL ret = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Patrol_Builder* pb = [Patrol builder];
    
    [pb setId:-1];
    [pb setUser:USER];
    
    if(textViewCell.textView.text != nil && textViewCell.textView.text.length>0){
        [pb setContent:textViewCell.textView.text];
    }
    
    [pb setCategory:currentPatrolCategory];
    if (currentCustomer == nil) {
        [pb setCustomer:taskCustomer];
    }else{
        [pb setCustomer:currentCustomer];
    }
    
    if (appDelegate.myLocation != nil){
        [pb setLocation:appDelegate.myLocation];
    }
    [pb setFilePathArray:liveImageCell.imageFiles];
    //图片
    if (picOrVideo == PatrolPostTypeImage) {
        [pb setMediaType:PATROL_FUNC_PICTURE];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *file in liveImageCell.imageFiles) {
            UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
            NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
            [images addObject:dataImg];
        }
        [pb setFilesArray:images];
    }
    //视频
    if (picOrVideo == PatrolPostTypeVideo) {
        [pb setMediaType:PATROL_FUNC_VIDEO];
        [pb setVideoDurationsArray:@[videoDuration.durationValue]];
        [pb setPatrolVideoDurationCategoriesArray:@[videoDuration]];
        NSString *videoSize = [FileHelper getFileSize:videoUrl];
        [pb setVideoSizesArray:@[videoSize]];
        [pb setVideoPixelsArray:@[NSLocalizedString(@"patrol_video_pixels", nil)]];
        NSData *img = [NSData dataWithContentsOfFile:imageUrl];
        [pb setFilesArray:@[img]];
        NSData *video = [NSData dataWithContentsOfFile:videoUrl];
        [pb setVideosArray:@[video]];
    }
    
    if (taskId != nil && taskCustomer != nil && taskCustomer.id == currentCustomer.id) {
        TaskPatrolDetail_Builder *tppb = [TaskPatrolDetail builder];
        
        [tppb setTaskId:taskId];
        [tppb setId:-1];
        [tppb setPatrol:[pb build]];
        [tppb setFinishDate:[[NSDate getCurrentTime] substringToIndex:10]];
        [tppb setUser:USER];
        
        ret = [LOCALMANAGER saveCache:FUNC_PATROL_TASK Content:[tppb build].dataStream];
    }else{
        ret = [LOCALMANAGER saveCache:FUNC_PATROL Content:[pb build].dataStream];
    }
    
    HUDHIDE2;
    
    if (ret) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                          description:NSLocalizedString(@"cache_msg_saved", @"")
                                 type:MessageBarMessageTypeSuccess
                          forDuration:SUCCESS_MSG_DURATION];
        [liveImageCell clearCell];
        textViewCell.textView.text = @"";
        [self initData:NO];
        [tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    }else{
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                          description:NSLocalizedString(@"cache_msg_fail", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

-(void) save {
    saveImageView.userInteractionEnabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    
    Patrol_Builder* pb = [Patrol builder];
    
    [pb setId:0];
    [pb setUser:USER];
    
    if(textViewCell.textView.text != nil && textViewCell.textView.text.length>0){
        [pb setContent:textViewCell.textView.text];
    }
    
    [pb setCategory:currentPatrolCategory];
    if (currentCustomer == nil) {
        [pb setCustomer:taskCustomer];
    }else{
        [pb setCustomer:currentCustomer];
    }
    
    if (appDelegate.myLocation != nil){
        [pb setLocation:appDelegate.myLocation];
    }
    
    //图片
    if (picOrVideo == PatrolPostTypeImage) {
        [pb setMediaType:PATROL_FUNC_PICTURE];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *file in liveImageCell.imageFiles) {
            UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
            NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
            [images addObject:dataImg];
        }
        [pb setFilesArray:images];
    }
    //视频
    if (picOrVideo == PatrolPostTypeVideo) {
        [pb setMediaType:PATROL_FUNC_VIDEO];
        [pb setVideoDurationsArray:@[videoDuration.durationValue]];
        [pb setPatrolVideoDurationCategoriesArray:@[videoDuration]];
        NSString *videoSize = [FileHelper getFileSize:videoUrl];
        [pb setVideoSizesArray:@[videoSize]];
        [pb setVideoPixelsArray:@[NSLocalizedString(@"patrol_video_pixels", nil)]];
        NSData *img = [NSData dataWithContentsOfFile:imageUrl];
        [pb setFilesArray:@[img]];
        NSData *video = [NSData dataWithContentsOfFile:videoUrl];
        [pb setVideosArray:@[video]];
    }
    
    
    AGENT.delegate = self;
    if (taskId != nil && taskCustomer != nil && taskCustomer.id == currentCustomer.id) {
        TaskPatrolDetail_Builder *tppb = [TaskPatrolDetail builder];
        
        [tppb setTaskId:taskId];
        [tppb setId:-1];
        [tppb setPatrol:[pb build]];
        [tppb setFinishDate:[[NSDate getCurrentTime] substringToIndex:10]];
        [tppb setUser:USER];
        
        
        if (DONE != [AGENT sendRequestWithType:ActionTypeTaskPatrolDetailSave param:[tppb build]]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
    }else{
        AGENT.delegate = self;
        
        if (DONE != [AGENT sendRequestWithType:ActionTypePatrolSave param:[pb build]]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
    }
}

-(void)toSave:(id)sender {
    if (![self validate]) {
        return;
    }
    [self save];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self save];
        }
            break;
        case 1:{
            [self saveCache];
        }
            break;
        default:
            break;
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


-(void) insertCommonPhrases:(FavoriteLang *) favoriteLang {
    textViewCell.textView.text = [NSString stringWithFormat:@"%@%@",textViewCell.textView.text,favoriteLang.commonLang];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == locationCellIndex) {
                return 50;
            }
            return 40;
        }
            break;
        case 1:{
            if (patrolType != PatrolPostTypeImage && picOrVideo == PatrolPostTypeVideo) {
                return 200;
            }else{
                return 110;
            }
        }
            break;
        case 2:{
            return 220;
        }
            break;
        case 3:{
            return 80;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return rowCount;
    }else{
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                PatrolTypeViewController *ctrl = [[PatrolTypeViewController alloc] init];
            
                ctrl.delegate = self;
                ctrl.bFavorate = NO;
                ctrl.bNeedAll = NO;
                ctrl.hidenBool = YES;
                UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [self presentViewController:patrolNavCtrl animated:YES completion:nil];
                [ctrl release];
            }else if(indexPath.row == 1){
                CustomerSelectViewController *ctrl = [[CustomerSelectViewController alloc] init];
                ctrl.delegate = self;
                ctrl.bNeedAll = NO;
                ctrl.bNeedAddCustomer = YES;
                UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [self presentViewController:customerNavCtrl animated:YES completion:nil];
                [ctrl release];
            }else if(patrolType != PatrolPostTypeImage && picOrVideo == PatrolPostTypeVideo && indexPath.row == locationCellIndex - 1){
                if (pickerCell.bPickerVideo) {
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_DES)

                      description:NSLocalizedString(@"patrol_msg_duration_check", nil)
                                             type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                    return;
                }
                PatrolVideoDurationTypeController *durationVC = [[PatrolVideoDurationTypeController alloc] init];
                durationVC.bNeedBack = YES;
                durationVC.delegate = self;
                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:durationVC];
                [self presentViewController:navCtrl animated:YES completion:nil];
                [durationVC release];
                [navCtrl release];
            }
            
        }
            break;
        case 1:
        {
            if (picOrVideo == PatrolPostTypeVideo) {
                PickerVideoCell *videoPicker = [tableView cellForRowAtIndexPath:indexPath];
                [videoPicker playOrPickerVide];
            }
        }
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                if (indexPath.row == 0){
                    selectCell.title.text = NSLocalizedString(@"patrol_label_category", nil);
                    if ([patrolCategories count]>0) {
                        selectCell.value.text = currentPatrolCategory.name;
                    }else{
                        selectCell.value.text = @"";
                    }
                }else if(indexPath.row == 1){
                    selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                    
                    if (currentCustomer != nil) {
                        selectCell.value.text = currentCustomer.name;
                    }else{
                        selectCell.value.text = @"请选择客户";
                        selectCell.value.textColor = WT_GRAY;
                    }
                }else if(indexPath.row == locationCellIndex){
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
                }else if(patrolType != PatrolPostTypeImage && picOrVideo == PatrolPostTypeVideo && indexPath.row == locationCellIndex - 1){
                    if (durationCell == nil) {
                        durationCell = [[[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject] retain];
                    }
                    selectCell.title.text = NSLocalizedString(@"bar_video_duration_type", nil);
                    if (videoDuration != nil) {
                        selectCell.value.text = [NSString stringWithFormat:NSLocalizedString(@"video_duration_to_seconds", nil),videoDuration.durationValue];
                    }else{
                        selectCell.value.text = NSLocalizedString(@"non_select", nil);
                    }
                    return selectCell;
                }else if (patrolType == PatrolPostTypeImageAndVideo && indexPath.row  == locationCellIndex - (picOrVideo == PatrolPostTypeVideo) ? 2 : 1){
                    if (patrolPostTypeCell == nil) {
                        patrolPostTypeCell = [[[[NSBundle mainBundle] loadNibNamed:@"PatrolPostTypeCell" owner:self options:nil] lastObject] retain];
                        [patrolPostTypeCell initMenu];
                    }
                    [patrolPostTypeCell.checkbox addTarget:self action:@selector(didCheckedChange:) forControlEvents:UIControlEventValueChanged];
                    
                    return patrolPostTypeCell;
                }
            }
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
        }
            break;
        case 1:{
            if (patrolType != PatrolPostTypeImage && picOrVideo == PatrolPostTypeVideo) {
                if (pickerCell == nil) {
                    pickerCell = [[PickerVideoCell alloc] init];
                }
                pickerCell.parentVC = self;
                pickerCell.delegate = self;
                pickerCell.pickVideoType = PickerVideoTypePatroVideo;
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
                [pickerCell.container addGestureRecognizer:longPress];
                if (videoUrl.length > 0 && imageUrl.length > 0){
                    [pickerCell.icon setHidden:NO];
                    [pickerCell.icon setImage:[UIImage imageNamed:@"video_play"]];
                    [pickerCell.icon setContentMode:UIViewContentModeScaleAspectFit];
                }else{
                    [pickerCell.icon setHidden:NO];
                    [pickerCell.icon setImage:[UIImage imageNamed:@"video_record"]];
                    [pickerCell.icon setContentMode:UIViewContentModeScaleAspectFit];
                }
                [longPress release];
                return pickerCell;
            }else{
                if(liveImageCell==nil){
                    liveImageCell = [[LiveImageCell alloc] init];
                    liveImageCell.delegate = self;
                }
                liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
                return liveImageCell;
            }
        }
            break;
        case 2:{
            
            if (textViewCell == nil) {
                textViewCell = [[CommonPhrasesTextViewCell alloc] init];
                
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
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
            }
            
            return textViewCell;
            
        }
            break;
        
            
        default:
            break;
    }
    
    return cell;
    
}

#pragma -mark -长按删除视频
-(void) longPressAction{
    if (bDeleting || pickerCell.player.rate == 1) {
        return;
    }
    if (pickerCell.bPickerVideo) {
        bDeleting = YES;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"note", nil)
                                                        message:NSLocalizedString(@"video_del_info", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"no", nil)
                                              otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        [alert show];
        [alert release];
        bDeleting = NO;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        if (videoUrl != nil && imageUrl != nil &&  videoUrl.length > 0 && imageUrl.length > 0) {
            [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithArray:@[videoUrl,imageUrl]]];
            videoUrl = nil;
            imageUrl = nil;
        }
        pickerCell.bPickerVideo = NO;
        [pickerCell.container removeFromSuperview];
        [tableView reloadData];
    }
}

#pragma -mark -PickerVideoTouchDelegate

-(void)PickerVideoTouch:(NSString *)videPath photoPath:(NSString *)photoPath{
    NSLog(@"%@\n%@",videPath,photoPath);
    videoUrl = videPath;
    imageUrl = photoPath;
    [tableView reloadData];
}

#pragma -mark -----

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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


- (void)patrolSearch:(PatrolTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentPatrolCategory = [(PatrolCategory *)aObject retain];
    [tableView reloadData];
    
}
- (void)patrolSearchDidCanceled:(PatrolTypeViewController *)controller{
    
    
}

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentCustomer = [(Customer *)aObject retain];
    [tableView reloadData];
}
- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller{
    
}
- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject{
    currentCustomer = [[(Customer_Builder *)aObject build] retain];
    [tableView reloadData];
}

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

#pragma -mark -VideoDurationTypeDelegate

-(void)PatrolVideoDurationTypeSlectedItme:(UIViewController *)controller duration:(PatrolVideoDurationCategory *)duartion{
    videoDuration = duartion;
    durationCell.value.text = [NSString stringWithFormat:NSLocalizedString(@"video_duration_to_seconds", nil),videoDuration.durationValue];
    [LOCALMANAGER favPatrolVideoDurationCategory:videoDuration.id];
    [tableView reloadData];
}

- (void)dealloc {
    [imageFiles release];
    [rightView release];
    [tableView release];
    [liveImageCell release];
    [textViewCell release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE( cr.type)) {
        case ActionTypePatrolSave:{
            HUDHIDE2;
             saveImageView.userInteractionEnabled = YES;
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
                textViewCell.textView.placeHolder = @"必填（1000字以内）";
                [self initData:YES];
                [tableView reloadData];
               
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_PATROL_DES)
         Description:NSLocalizedString(@"patrol_msg_saved", @"")];
            
        }
            break;
            
        case ActionTypeTaskPatrolDetailSave:{
            HUDHIDE2;
            [super showMessage2:cr Title:TITLENAME(FUNC_PATROL_DES)
            Description:NSLocalizedString(@"patrol_msg_saved", @"")];
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                
                [liveImageCell clearCell];
                textViewCell.textView.text = @"";
                [self initData:YES];
                [self clickLeftButton:nil];
            }
            
            
        }
            break;
            
        default:
            break;
    }
}

@end
