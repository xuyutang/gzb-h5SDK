//
//  DataReportDetailViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DataReportDetailViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "PaperViewController.h"
#import "LiveImageCell.h"
#import "SelectCell.h"
#import "TextViewCell.h"
#import "CustomerSelectViewController.h"
#import "LocationCell.h"
#import "TextFieldCell.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "PlaceTextView.h"
#import "NameFilterViewController.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "TopicImageCell.h"
#import "BigImageViewController.h"
#import "SDImageView+SDWebCache.h"
#import "UIView+Util.h"

#import "LableCell.h"

#define CELL_DEFAULT_HEIGHT 60.f
@interface DataReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LiveImageCellDelegate,UITextViewDelegate,CustomerCategoryDelegate,InputFinishDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,NameFilterViewControllerDelegate>
{
    UIView *rightView;
    PaperViewController *paperController ;
    NSMutableArray *arr;
    UITableView *_tableView;
    NSMutableArray *typeArray;
    SelectCell *customerSelectCell;
    TextViewCell *textViewCell;
    UIButton *choseDataBtn;
    LiveImageCell *liveImageCell;
    LiveImageCell *liveAnyImageCell;
    TopicImageCell *topCell;
    
    NSMutableDictionary *imagesDict;
    Customer *currentCustomer;
    NSString *textString;
    NSString *digtString;
    
    NSString *keepBoxString;
    NSArray *boxArray;
    NSMutableArray *boxMulArray;
    NSMutableArray *keepBoxArray;
    
    NSError *error;
}

@end

@implementation DataReportDetailViewController
@synthesize currentPaperPost,paperPostId,delegate,msgType;
- (void)viewDidLoad {
    [super viewDidLoad];
    imagesDict = [[NSMutableDictionary dictionary] retain];
    
//    //模拟数据
//    arr =[[NSMutableArray alloc]init];
//    [arr addObjectsFromArray:@[@{@"id":@1,@"name":@"文本项",@"templateId":@1,@"type":@"TEXT",@"sn":@1,@"allowNull":@false},
//                               @{@"id":@2,@"name":@"文件类型：单选",@"templateId":@1,@"type":@"RADIO",@"allowNull":@false,@"options":@[@{@"id":@1,@"content":@"图片"},@{@"id":@2,@"content":@"视频"}]},
//                               @{@"id":@3,@"name":@"乘车体验：多选",@"templateId":@1,@"type":@"CHECKBOX",@"sn":@3,@"allowNull":@false,@"options":@[@{@"id":@3,@"content":@"驾驶技术好"},@{@"id":@4,@"content":@"车内整洁"},@{@"id":@5,@"content":@"准时安全"}]},
//                               @{@"id":@4,@"name":@"选择客户",@"templateId":@1,@"type":@"CUSTOMER",@"sn":@"4",@"allowNull":@false},
//                               @{@"id":@5,@"name":@"现场拍照（现场拍照）",@"templateId":@1,@"type":@"PHOTO_LIVE",@"sn":@"5",@"allowNull":@false},
//                               @{@"id":@6,@"name":@"现场拍照（不限来源）",@"templateId":@1,@"type":@"PHOTO_ANY",@"sn":@"6",@"allowNull":@true},
//                               @{@"id":@7,@"name":@"数字",@"templateId":@1,@"type":@"DIGITAL",@"sn":@"7",@"allowNull":@true},
//                               @{@"id":@8,@"name":@"日期",@"templateId":@1,@"type":@"DATE",@"sn":@"8",@"allowNull":@true},@{@"id":@8,@"name":@"日期",@"templateId":@1,@"type":@"DATE",@"sn":@"8",@"allowNull":@true}
//                               
//                               ]];
    
//    paperTypes = [[NSMutableArray alloc]init];
//    paperTypes = [[LOCALMANAGER getPaperTemplates] retain];
//    menuTitles = [[NSMutableArray alloc]init];
//    dataMulArray = [[NSMutableArray alloc]init];
    
//    NSArray *dataArray= [NSJSONSerialization JSONObjectWithData:[self.currentPaperPost.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"sn" ascending:YES];
//    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
//    NSArray *resultArray = [dataArray sortedArrayUsingDescriptors:descriptors];
//    NSLog(@"%@", resultArray);
//    arr = [[NSMutableArray arrayWithArray:resultArray] retain];
//    //[arr addObjectsFromArray:resultArray];

//    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [menuTitles addObject: ((PaperTemplate*)obj).name];
//        // json 相关的字段
//        [dataMulArray addObject: ((PaperPost*)obj)];
    
    [self.navigationController setNavigationBarHidden:NO];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [refreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tofreshPaperPost)];
    [tapGesture1 setNumberOfTapsRequired:1];
    refreshImageView.userInteractionEnabled = YES;
    refreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [refreshImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:refreshImageView];
    [refreshImageView release];
    [tapGesture1 release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundColor = WT_WHITE;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        NSArray *list=self.navigationController.navigationBar.subviews;
//        for (id obj in list) {
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                UIImageView *imageView=(UIImageView *)obj;
//                NSArray *list2=imageView.subviews;
//                for (id obj2 in list2) {
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
//    self.navigationController.navigationBar.backgroundColor = WT_WHITE;
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
//    [lblFunctionName setText:@"问卷调查"];
    AGENT.delegate = self;
    if (currentPaperPost != nil) {
        [self _show];
    }else{
        [self _getPaperPost];
    }
    
    
 //   lblFunctionName.text = TITLENAME_STR(FUNC_BIZOPP_DES,currentPaperPost.user.realName);
    // Do any additional setup after loading the view.
}

- (void)tofreshPaperPost{
    NSLog(@"-------------------------");
    _tableView.contentOffset = CGPointMake(0, 0);
//    currentPage = 1;
//    _tableView.pullLastRefreshDate = [NSDate date];
//    _tableView.pullTableIsRefreshing = NO;
    
    PaperPostParams_Builder* pb = [PaperPostParams builder];
    
    [pb setId:paperPostId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypePaperPostGet param:[pb build]]){
//        _tableView.pullTableIsRefreshing = NO;
//        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
}

- (void) _show
{
 //   self.lblFunctionName.text = TITLENAME_STR(FUNC_BIZOPP_DES,@"罗伯特");
    self.lblFunctionName.text = [NSString stringWithFormat:@"%@-%@",currentPaperPost.paperTemplate.name,currentPaperPost.user.realName];
    
        NSArray *dataArray= [NSJSONSerialization JSONObjectWithData:[self.currentPaperPost.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"sn" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        NSArray *resultArray = [dataArray sortedArrayUsingDescriptors:descriptors];
        NSLog(@"%@", resultArray);
        arr = [[NSMutableArray arrayWithArray:resultArray] retain];
        //[arr addObjectsFromArray:resultArray];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    [self initData];
    [tableView reloadData];
//    [self createBottomBar];
}
- (void)_getPaperPost
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    PaperPostParams_Builder *pb = [PaperPostParams builder];
    [pb setId:paperPostId];
    

    if (DONE != [AGENT sendRequestWithType:ActionTypePaperPostGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void)initData{
    
//    imageFiles = [[NSMutableArray alloc] init];
//    for (int i = 0; i<[currentPaperPost.filePath count]; i++) {
//        [imageFiles addObject:[currentPaperPost.filePath objectAtIndex:i]];
//    }
}

////固定的，显示地理位置
//-(void)createBottomBar{
//    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT-45, MAINWIDTH, 45)];
//    [bottom setBackgroundColor:[UIColor whiteColor]];
//    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, .5f)];
//    [line1 setBackgroundColor:[UIColor lightGrayColor]];
//    [bottom addSubview:line1];
//    [line1 release];
//
//    static NSString *CellIdentifier = @"CellIdentifier";
//    locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    locationCell.btnRefresh.hidden = YES;
//    if(locationCell==nil){
//        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
//        for(id oneObject in nib)
//        {
//            if([oneObject isKindOfClass:[LocationCell class]])
//                locationCell=(LocationCell *)oneObject;
//        }
//    }
//    
//    if (APPDELEGATE.myLocation != nil) {
//        if (!APPDELEGATE.myLocation.address.isEmpty) {
//            [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
//        }else{
//            [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
//        }
//    }
////    [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
//    locationCell.lblAddress.text = currentPaperPost.location.address;
//    [bottom addSubview:locationCell];
//    
//    [self.view addSubview:bottom];
//    [bottom release];
//}
- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

- (void)clickLeftButton:(id)sender{
//    if (bizReply != nil){
//        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
//            [delegate refresh:currentBizOpp];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - uitabviewDelegate
#pragma mark numberOfSectionsInTableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arr.count;

}

#pragma mark numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

#pragma mark heightForRowAtIndexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section < arr.count) {

        NSDictionary *dict = arr[indexPath.section];
        typeString = [dict objectForKey:@"type"];
        if ([typeString isEqualToString:@"TEXT"]) {
            NSDictionary *dataDict = arr[indexPath.section];
            CGSize size = [super rebuildSizeWithString:[dataDict objectForKey:@"fieldValue"] ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
            return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 12;
         //  return 60;
        }
        if ([typeString isEqualToString:@"DIGITAL"]) {
            return 60;
        }
        
        if ([typeString isEqualToString:@"RADIO"]) {
            //return 60;
            NSString *string = [dict objectForKey:@"fieldValue"];
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                return 60;
            }else{
                NSArray *fields = [self arrayWithJsonString:string];
                NSString *checkboxText = [self joinStringWithArray:fields];
                CGSize size = [super rebuildSizeWithString:checkboxText ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
                return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 5;
                
                //                checkboxtCell.lable.frame = CGRectMake(0, 0, MAINWIDTH-40, size.height);
                //              [checkboxtCell setText:checkboxText size:size];
                //            checkboxtCell.frame = CGRectMake(0, 0, MAINWIDTH, size.height + 5);
                
                //          checkboxtCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
        }
        if ([typeString isEqualToString:@"CHECKBOX"]) {
            
            NSString *string = [dict objectForKey:@"fieldValue"];
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                return 60;
            }else{
                NSArray *fields = [self arrayWithJsonString:string];
                NSString *checkboxText = [self joinStringWithArray:fields];
                CGSize size = [super rebuildSizeWithString:checkboxText ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
                return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 5;
                
//                checkboxtCell.lable.frame = CGRectMake(0, 0, MAINWIDTH-40, size.height);
  //              [checkboxtCell setText:checkboxText size:size];
    //            checkboxtCell.frame = CGRectMake(0, 0, MAINWIDTH, size.height + 5);
                
      //          checkboxtCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
            
//            
//            NSDictionary *dataDict = arr[indexPath.section];
//            NSArray *fields = [self arrayWithJsonString:string];
//            NSString *checkboxText = [self joinStringWithArray:fields];
//  //          CGSize size = [super rebuildSizeWithString:checkboxText ContentWidth:MAINWIDTH FontSize:FONT_SIZE + 1];
//            CGSize size = [super rebuildSizeWithString:[dataDict objectForKey:@"fieldValue"] ContentWidth:MAINWIDTH FontSize:FONT_SIZE + 1];
//            return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 11;
         //   return 60;
        }
        if ([typeString isEqualToString:@"PHOTO_LIVE"]) {
            return 100;
        }
        
        if ([typeString isEqualToString:@"PHOTO_ANY"]) {
            return 100;
        }
        
        if ([typeString isEqualToString:@"DATE"]) {
            return 60;
        }
        if ([typeString isEqualToString:@"CUSTOMER"]) {
            return 50;
        }
//    }
    if (indexPath.section == [arr count]+1) {
        return 60;
    }
    
    return 100;
    
}

#pragma mark cellForRowAtIndexPath

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        NSDictionary *dict = arr[indexPath.section];
    
        typeString = [dict objectForKey:@"type"];
        NSDictionary *dataDict = arr[indexPath.section];
        
        if ([typeString isEqualToString:@"TEXT"] ) {
            static NSString *identifier = @"textId";
            LableCell *texttCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(texttCell==nil){
                texttCell = [self getCellWithCellid:identifier];
            }
            
            CGSize size = [super rebuildSizeWithString:[dataDict objectForKey:@"fieldValue"] ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
            [texttCell setText:[dataDict objectForKey:@"fieldValue"] size:size];
            texttCell.lable.frame = CGRectMake(15, 0, MAINWIDTH-30, size.height);
            texttCell.frame = CGRectMake(0, 0, MAINWIDTH, size.height + 5);
            return texttCell;
            
            
//            static NSString *identifier = @"textId";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            cell.textLabel.text = [dataDict objectForKey:@"fieldValue"];
//            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//            [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
//            cell.textLabel.numberOfLines = 0;
//            return cell;
            
        }
        if ([typeString isEqualToString:@"DIGITAL"]) {
            static NSString *identifier = @"digitalId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.text = [dataDict objectForKey:@"fieldValue"];
            return cell;
        }
        
        if ([typeString isEqualToString:@"DATE"]) {
            static NSString *identifier = @"dataId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.text = [dataDict objectForKey:@"fieldValue"];
            return cell;
        }
        if ([typeString isEqualToString:@"RADIO"]) {
            
            static NSString *identifier = @"radioId";
            LableCell *radioCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(radioCell==nil){
                radioCell = [self getCellWithCellid:identifier];
            }
            NSString *string = [dict objectForKey:@"fieldValue"];
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                radioCell.textLabel.text = @"";
            }else{
                NSArray *fields = [self arrayWithJsonString:string];
                NSString *checkboxText = [self joinStringWithArray:fields];
                CGSize size = [super rebuildSizeWithString:checkboxText ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
                
                [radioCell setText:checkboxText size:size];
                radioCell.lable.frame = CGRectMake(15, 0, MAINWIDTH-30, size.height);
                radioCell.frame = CGRectMake(0, 0, MAINWIDTH, size.height + 5);
                radioCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
            return radioCell;
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            NSString *string = [dataDict objectForKey:@"fieldValue"];
//            if ([dict objectForKey:@"fieldValue"]==nil ) {
//                cell.textLabel.text = @"";
//            }else{
//                NSArray *fields = [self arrayWithJsonString:string];
//                NSLog(@"%@", fields);
//                cell.textLabel.text = [self joinStringWithArray:fields];
//                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//            }
//            return cell;
        }
        if ([typeString isEqualToString:@"CHECKBOX"]) {
            static NSString *identifier = @"checkboxId";
            LableCell *checkboxtCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(checkboxtCell==nil){
                checkboxtCell = [self getCellWithCellid:identifier];
            }
            NSString *string = [dict objectForKey:@"fieldValue"];
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                checkboxtCell.textLabel.text = @"";
            }else{
                NSArray *fields = [self arrayWithJsonString:string];
                NSString *checkboxText = [self joinStringWithArray:fields];
                CGSize size = [super rebuildSizeWithString:checkboxText ContentWidth:MAINWIDTH-30 FontSize:FONT_SIZE + 1];
                
                [checkboxtCell setText:checkboxText size:size];
                
                NSLog(@"%@", fields);
                checkboxtCell.lable.frame = CGRectMake(15, 0, MAINWIDTH-30, size.height);
                 checkboxtCell.frame = CGRectMake(0, 0, MAINWIDTH, size.height + 5);
                checkboxtCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
            return checkboxtCell;
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            
//            NSString *string = [dict objectForKey:@"fieldValue"];
//            if ([dict objectForKey:@"fieldValue"]==nil ) {
//                cell.textLabel.text = @"";
//            }else{
//                NSArray *fields = [self arrayWithJsonString:string];
//                NSLog(@"%@", fields);
//                cell.textLabel.text = [self joinStringWithArray:fields];//keepBoxString;
//                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//                
//            }
//            return cell;
        }
        if ([typeString isEqualToString:@"PHOTO_LIVE"]) {
            
//            NSData *jsonData = [[dict objectForKey:@"fieldValue"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err];
//            
//            NSMutableArray *images = [NSMutableArray arrayWithArray:array];
//            [imagesDict setObject:images forKey:@(indexPath.section)];
//            
////            if (!liveImageCell) {
//                liveImageCell = [[LiveImageCell alloc] initWithImages:images];
////            }
//            liveImageCell.tag = indexPath.section;
//            if(liveImageCell==nil){
//                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
//                for(id oneObject in nib)
//                {
//                    if([oneObject isKindOfClass:[LiveImageCell class]])
//                        liveImageCell=(LiveImageCell *)oneObject;
//                }
//            }
//            
//            liveImageCell.delegate = self;
//            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
//
//            return liveImageCell;
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                liveImageCell = [[LiveImageCell alloc] initWithImages:nil];
            }else{
                NSData *jsonData = [[dict objectForKey:@"fieldValue"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
                NSMutableArray *images = [NSMutableArray arrayWithArray:array];
                [imagesDict setObject:images forKey:@(indexPath.section)];
                liveImageCell = [[LiveImageCell alloc] initWithImages:images];
            }
            liveImageCell.tag = indexPath.section;
            if(liveImageCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LiveImageCell class]])
                        liveImageCell=(LiveImageCell *)oneObject;
                }
            }
            liveImageCell.delegate = self;
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
        if ([typeString isEqualToString:@"PHOTO_ANY"]) {
            if ([dict objectForKey:@"fieldValue"]==nil ) {
                liveImageCell = [[LiveImageCell alloc] initWithImages:nil];
            }else{
                NSData *jsonData = [[dict objectForKey:@"fieldValue"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
                NSMutableArray *images = [NSMutableArray arrayWithArray:array];
                [imagesDict setObject:images forKey:@(indexPath.section)];
                liveImageCell = [[LiveImageCell alloc] initWithImages:images];
            }
            liveImageCell.tag = indexPath.section;
            if(liveImageCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LiveImageCell class]])
                        liveImageCell=(LiveImageCell *)oneObject;
                }
            }
            liveImageCell.delegate = self;
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
        
        if ([typeString isEqualToString:@"CUSTOMER"]) {
            InputCell *customerNameCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
            if (customerNameCell == nil) {
                NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InputCell class]]) {
                        customerNameCell = (InputCell *)oneObject;
                    }
                }
                customerNameCell.title.text = NSLocalizedString(@"", nil);
            }
            customerNameCell.title.font = [UIFont systemFontOfSize:14.0f];
            customerNameCell.title.textColor = [UIColor lightGrayColor];
            customerNameCell.inputField.placeholder = @"";
            customerNameCell.inputField.enabled = NO;
            customerNameCell.inputField.frame = CGRectMake(13, 7, 260, 30);
            customerNameCell.inputField.text = [dataDict objectForKey:@"fieldValueName"];
            customerNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return customerNameCell;
        }
    
}

-(LableCell *) getCellWithCellid:(NSString *) cellid{
    LableCell *txtCell = [[LableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    CGRect r = txtCell.lable.frame;
    r.origin.x += 13;
    txtCell.lable.frame = r;
    return txtCell;
}

- (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    return array;
}

- (NSString *)joinStringWithArray:(NSArray *)array {
    NSString *string = @"";
    for (NSDictionary *dict in array) {
        NSString *option = [dict objectForKey:@"optionValue"];
        string = [[string stringByAppendingString:option] stringByAppendingString:@"\n"];
    }
    return string;
}

- (NSArray *)arrayWithJsonStringP:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    return array;
}

- (NSString *)joinStringWithArrayP:(NSArray *)array {
    NSString *string = @"";
    for (NSDictionary *dict in array) {
        NSString *option = [dict objectForKey:@"fileName"];
        string = [[string stringByAppendingString:option] stringByAppendingString:@" "];
    }
    
    return string;
}

-(void)getBoxArray:(NSMutableArray *)mulArray {
    keepBoxArray = mulArray;
//    [_tableView reloadData];
}

#pragma mark heightForHeaderInSection
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio {
 //   typeString = [self getTypeWithArray][sectio];
//    if ([typeString isEqualToString:@"CUSTOMER"] ) {
//        return 0;
//    }
    return 30;
}

#pragma mark viewForHeaderInSection
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 30)];
    titleLabel.text =[NSString stringWithFormat:@"    %@",[arr[section] objectForKey:@"fieldName"]];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor orangeColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:lineView];
    return contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == arr.count-1) {
        return 150;
    }
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 150)];
    fterView.backgroundColor = WT_WHITE;
    UILabel *lblTitleAddress = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, MAINWIDTH, 30)];
    lblTitleAddress.text = @"上传地址";
    lblTitleAddress.textColor = [UIColor orangeColor];
    lblTitleAddress.font = [UIFont systemFontOfSize:14.0f];
    [fterView addSubview:lblTitleAddress];
    
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, MAINWIDTH-28, 60)];
    if (!self.currentPaperPost.location.address.isEmpty) {
        lblAddress.text = self.currentPaperPost.location.address;
        lblAddress.numberOfLines = 0;
        //[locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
        }else{
            lblAddress.text = [NSString stringWithFormat:@"%f,%f",self.currentPaperPost.location.longitude,self.currentPaperPost.location.latitude];
            //setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
    }
    
    lblAddress.font = [UIFont systemFontOfSize:14.0f];
    [fterView addSubview:lblAddress];
    
    UILabel *lblTitleTime = [[UILabel alloc] initWithFrame:CGRectMake(14, 90, MAINWIDTH, 30)];
    lblTitleTime.text = @"上传时间";
    lblTitleTime.textColor = [UIColor orangeColor];
    lblTitleTime.font = [UIFont systemFontOfSize:14.0f];
    [fterView addSubview:lblTitleTime];
    
    UILabel *lblCreatetime = [[UILabel alloc] initWithFrame:CGRectMake(14, 120, MAINWIDTH, 30)];
    lblCreatetime.text = self.currentPaperPost.createDate;
    lblCreatetime.font = [UIFont systemFontOfSize:14.0f];
    [fterView addSubview:lblCreatetime];
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 0.5f)];
    lblLine.backgroundColor = [UIColor lightGrayColor];
    [fterView addSubview:lblLine];
    UILabel *lblLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, 0.5f)];
    lblLine2.backgroundColor = [UIColor lightGrayColor];
    [fterView addSubview:lblLine2];
    
    [lblLine release];
    [lblLine2 release];
    [lblTitleAddress release];
    [lblAddress release];
    [lblTitleTime release];
    [lblCreatetime release];
    if (section == arr.count-1) {
        return fterView;
    }
    return nil;
}

#pragma mark 获取数据类型
-(NSMutableArray*)getTypeWithArray{
    
    typeArray = [[NSMutableArray alloc]init];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [typeArray addObject:[obj objectForKey:@"type"]];
        
    }];
    return typeArray;
    
}


- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypePaperPostGet:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                PaperPost* p = [PaperPost parseFromData:cr.data];
                if ([super validateData:p]) {
                    currentPaperPost = [p retain];
                    
//                    replies = [[NSMutableArray alloc] init];
//                    for (int i = 0; i < currentPaperPost.attendanceReplies.count; ++i) {
//                        [replies addObject:[attendance.attendanceReplies objectAtIndex:i]];
//                    }
                    
                    [self _show];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",paperPostId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            [tableView reloadData];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark 让表格头一起滑动的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}
-(void)openPhotos:(UIView *)superView index:(int)index {
    NSLog(@"index = %@",@(index));
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    NSArray *array = [imagesDict objectForKey:@(superView.tag)];
    ctrl.filePath = [array objectAtIndex:index];
    //    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",attendance.category.name,attendance.user.realName];
//    [ctrl.lblFunctionName setText:NSLocalizedString(@"数据上报图片详情", @"")];
//    [lblFunctionName setText:NSLocalizedString(@"bar_patrol_image", @"")];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
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
