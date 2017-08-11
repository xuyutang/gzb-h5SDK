//
//  DataReportViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DataReportViewController.h"
#import "PaperViewController.h"
#import "LiveImageCell.h"
#import "SelectCell.h"
#import "TextViewCell.h"
#import "CustomerSelectViewController.h"
#import "LocationCell.h"
#import "TextFieldCell.h"
#import "CustomerSelectViewController.h"
#import "DataReportListViewController.h"
#import "DatePicker2.h"
#import "RadioViewController.h"
#import "BoxViewController.h"
#import "DataReportModel.h"
#import "PaperPostModel.h"
#import "PaperPostOption.h"
#import "MJExtension.h"
#import "TextFieldCell.h"

@interface DataReportViewController ()<UITableViewDelegate,UITableViewDataSource,LiveImageCellDelegate,UITextViewDelegate,CustomerCategoryDelegate,UIActionSheetDelegate,UIPickerViewDelegate,RequestAgentDelegate> {
    UIView *rightView;
    PaperViewController *paperController ;
    NSMutableArray *dataArr;
    UITableView *_tableView;
    NSMutableArray *typeArray;
    SelectCell *customerSelectCell;
    TextViewCell *textTextViewCell;
    TextViewCell *textDigtViewCell;
    TextFieldCell *dateSelectCell;
    UIButton *choseDataBtn;
    LiveImageCell *liveImageCell;
    LiveImageCell *liveAnyImageCell;
    TextViewCell *textViewRadioCell;
    TextViewCell *textViewBoxCell;
    NSMutableArray *imageFiles;
    Customer *currentCustomer;
    NSString *radioString;
    NSString *keepBoxString;
    DatePicker2* datePicker;
    int distance;
    BOOL liveBool;
    UILabel *locationLabel;
    NSArray *radioArry;
    NSMutableArray *mulRadioArray;
    NSMutableArray *boxMulArray;
    NSMutableArray *keepBoxArray;
    int indexSection;
    int timeInt;
    int photoIndex;
    UIImageView *saveImageView;
}

@end


@implementation DataReportViewController

#pragma mark 数据初始化
-(void)initDate {
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    
    imageFiles = [[NSMutableArray alloc] init];
    
    if (_paperTemplate == nil) {
    _paperTemplate = [LOCALMANAGER getFavPaperTempate];
}
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
  [self initDate];
 //测试数据
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:@[@{@"id":@1,@"name":@"文本  项",@"templateId":@2,@"type":@"TEXT",@"sn":@1,@"allowNull":@false},
    
    
                                   @{@"id":@2,@"name":@"文件类型：单选",@"templateId":@1,@"type":@"RADIO",@"allowNull":@false,@"options":@[@{@"id":@1,@"content":@"图片"},@{@"id":@2,@"content":@"视频"}]},
    
                                   @{@"id":@3,@"name":@"乘车体验：多选",@"templateId":@1,@"type":@"CHECKBOX",@"sn":@3,@"allowNull":@false,@"options":@[@{@"id":@3,@"content":@"驾驶技术好"},@{@"id":@4,@"content":@"车内整洁"},@{@"id":@5,@"content":@"准时安全"}]},
    
                                   @{@"id":@4,@"name":@"选择客户",@"templateId":@1,@"type":@"CUSTOMER",@"sn":@"4",@"allowNull":@false},
    
                                   @{@"id":@5,@"name":@"现场拍照（现场拍照）",@"templateId":@1,@"type":@"PHOTO_LIVE",@"sn":@"5",@"allowNull":@false},
    
                                   @{@"id":@6,@"name":@"现场拍照（）",@"templateId":@1,@"type":@"PHOTO_LIVE",@"sn":@"6",@"allowNull":@true},
                                      @{@"id":@6,@"name":@"现场拍照（现场拍照6666）",@"templateId":@1,@"type":@"PHOTO_ANY",@"sn":@"5",@"allowNull":@false},
                                      @{@"id":@6666,@"name":@"现场拍照（不限来源）",@"templateId":@1,@"type":@"PHOTO_ANY",@"sn":@"6",@"allowNull":@true},
                                   @{@"id":@7,@"name":@"数字",@"templateId":@1,@"type":@"DIGITAL",@"sn":@"7",@"allowNull":@true},
                                   @{@"id":@8,@"name":@"日期",@"templateId":@1,@"type":@"DATE",@"sn":@"8",@"allowNull":@true}
                                 ]];
  NSString *datastr = [_paperTemplate retain].fieldContent ;
    
   _paperTitle= [_paperTemplate retain].name ;
    
    lblFunctionName.frame =CGRectMake(35, 0, 150, 44);
    
  dataArr  = [[NSMutableArray alloc]init];
   
    
  NSArray *dataArray= [NSJSONSerialization JSONObjectWithData:[datastr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary* dic in dataArray) {
        DataReportModel* model = [[DataReportModel alloc] init];
        model.id = [dic objectForKey:@"id"] ;
        model.name = [dic objectForKey:@"name"];
        model.templateId = [[dic objectForKey:@"templateId"] intValue];
        model.sn = [[dic objectForKey:@"sn"] intValue];
        model.options = [dic objectForKey:@"options"];
        model.type = [dic objectForKey:@"type"];
        model.allowNull = [[dic objectForKey:@"allowNull"] integerValue];
        [dataArr addObject:model];
        
    }
    
    [self.navigationController setNavigationBarHidden:NO];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
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
    
    UIImageView *paperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [paperImageView setImage:[UIImage imageNamed:@"ic_func_list"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPaper:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    paperImageView.userInteractionEnabled = YES;
    paperImageView.contentMode = UIViewContentModeScaleAspectFit;
    [paperImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:paperImageView];
    [paperImageView release];
    [tapGesture2 release];
    
   saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture3 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture3];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    [tapGesture3 release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    
    self.view.backgroundColor = WT_WHITE;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MAINWIDTH, MAINHEIGHT - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = WT_WHITE;
    [self.view addSubview:_tableView];
    
    locationLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, MAINWIDTH - 70, 50)];
    locationLabel.lineBreakMode = UILineBreakModeWordWrap;
    locationLabel.numberOfLines = 0;
    locationLabel.font = [UIFont systemFontOfSize:13];
    [self setLocation];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH - 50, 10, 25, 25)];
    locationImageView.image = [UIImage imageNamed:@"icon_loc_refresh"];
    locationImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshLocation)];
    [tapGesture setNumberOfTapsRequired:1];
    locationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [locationImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:locationImageView];
    [locationImageView release];
    
    [self.view addSubview:locationLabel];
    if (_paperTitle.length) {
        [lblFunctionName setText:[NSString stringWithFormat:@"%@-上报",_paperTitle]];
    }else {
     [lblFunctionName setText:TITLENAME_REPORT(FUNC_PAPER_POST_DES)];
    }
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_PAPER_POST_DES)];
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [self setLocation];
}

#pragma mark 重新定位
- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [self setLocation];
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 获取位置信息
-(void)setLocation {
    if (APPDELEGATE.myLocation != nil) {
        if (!APPDELEGATE.myLocation.address.isEmpty) {
            locationLabel.text = [NSString stringWithFormat:@"%@",APPDELEGATE.myLocation.address];
        }else{
            locationLabel.text  = [NSString stringWithFormat:@"  %f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude];
        }
    }
}

#pragma mark 去往模板选择页面
-(void)toPaper:(id)sender {
    paperController = [[PaperViewController alloc]init];
  [self.navigationController pushViewController:paperController animated:YES];
    
}

#pragma mark 去往数据上报的列表页
-(void)toList:(id)sender {
    DataReportListViewController *dataReportVC = [[DataReportListViewController alloc]init];
    [self.navigationController pushViewController:dataReportVC animated:YES];
    
}

#pragma mark 判断不全为空格 换行 及两者混合的方法
-(BOOL) isValueBool:(NSString *)textStr {
   NSString * valueStr = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    if (valueStr.length) {
        return YES;
    } else {
        return NO;
    
    }
}

#pragma mark 数据上报的数据保存
-(void)toSave:(id)sender {
 
    [_tableView reloadData];
   
    //上报数据保存前校验
    for (int i = 0; i < dataArr.count; i ++) {
        DataReportModel *model = dataArr[i];
    //文本类型
     if ([model.type isEqualToString:@"TEXT"] ) {
        
           if(model.textString == nil  && !model.allowNull){
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                      description:[NSString stringWithFormat:@"%@为必填项",model.name]type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                    return;
                }
         
         BOOL valueBool  = [self isValueBool:model.textString];
         
         if (!valueBool && !model.allowNull) {
             [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                               description:@"请输入有效的字符"type:MessageBarMessageTypeInfo
                               forDuration:INFO_MSG_DURATION];
             return;
         }

            }
    //数字类型
     if ([model.type isEqualToString:@"DIGITAL"]) {
        if (model.textString == nil && !model.allowNull) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                  description:[NSString stringWithFormat:@"%@为必填项",model.name]type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;
                
        }else {
            if (!model.allowNull) {
                BOOL valueBool =  [self validateNumber:model.textString];
                if (!valueBool) {
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                      description:[NSString stringWithFormat:NSLocalizedString(@"paper_field_digital_maxlength", @""),model.name]type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                    return;
                }

            }
        }
    }
     //时间类型
        if ([model.type isEqualToString:@"DATE"]) {
            if (model.signTime == nil && !model.allowNull) {
                
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                  description:[NSString stringWithFormat:@"%@为必填项",model.name]type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;

            }
        }
    //单选类型
        if ([model.type isEqualToString:@"RADIO"]) {
            if (model.radioValueString == nil && !model.allowNull) {
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                  description:[NSString stringWithFormat:@"%@为必选项",model.name]type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;
            }
            
        }
     //对选类型
    if ([model.type isEqualToString:@"CHECKBOX"]) {
        if (model.boxchoseValueArray.count == 0 && !model.allowNull) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                  description:[NSString stringWithFormat:@"%@为必选项",model.name]type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;
            }
        }
     //选择客户类型
        if ([model.type isEqualToString:@"CUSTOMER"]) {
            if(model.custName == nil && !model.allowNull ){
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                                  description:NSLocalizedString(@"patrol_hint_customer_select", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;
            }

        }
     //照片类型 包括实时拍照和不限来源的拍照
        if ([model.type isEqualToString:@"PHOTO_LIVE"] || [model.type isEqualToString:@"PHOTO_ANY"]) {
            if (!model.allowNull && model.imageMulArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)                                  description:[NSString stringWithFormat:@"%@至少一张图片",model.name]
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                return;

            }
        }
        
    }
    
    saveImageView.userInteractionEnabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    PaperPost_Builder *pb = [PaperPost builder];
    [pb setId:-1];
    [pb setUser:USER];
    [pb setPaperTemplate:_paperTemplate];
  
    if (APPDELEGATE.myLocation != nil) {
        [pb setLocation:APPDELEGATE.myLocation];
    }
    
    //上报数据json组装
    NSMutableArray * mediaMulArray = [[NSMutableArray alloc] init];
    NSMutableArray *paperArray = [[NSMutableArray alloc]init];
      for (int i = 0; i < dataArr.count; i++) {
          DataReportModel* model  = dataArr[i];
          PaperPostModel *paperModel  = nil;
          if ([model.type isEqualToString:@"PHOTO_LIVE"] || [model.type isEqualToString:@"PHOTO_ANY"] ) {
              paperModel = [[PaperPostModel alloc]init];
              paperModel.fieldId = model.id;
              paperModel.fieldName = model.name;
              paperModel.type = model.type;
              paperModel.sn = model.sn;
              
                 [paperArray addObject:[[paperModel mj_JSONObject] retain]];
                  
                  if (model.imageMulArray.count >0) {
                      NSMutableArray *images = [[NSMutableArray alloc] init];
                      for (NSString *file in model.imageMulArray) {
                          UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
                          NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
                          [images addObject:dataImg];
                      }
                      PaperPostMedia_Builder *paper = [PaperPostMedia builder];
                      [paper setFieldId:model.id];
                      [paper setFilesArray:images];
                      
                      [mediaMulArray addObject:[paper build]];
                  }
              
          }else{
              NSLog(@"mode type:%@",model.type);
              paperModel = [[PaperPostModel alloc]init];
              paperModel.fieldId = model.id;
              paperModel.fieldName = model.name;
              paperModel.type = model.type;
              paperModel.sn = model.sn;
              
          if ([model.type isEqualToString:@"CUSTOMER"]) {
              if (model.custName.length != 0) {
                  paperModel.fieldValueName = model.custName;
                  paperModel.fieldValue =  model.custId;
              }
          
            }
              
          if ([model.type isEqualToString:@"CHECKBOX"]) {
              NSMutableArray *optonMulArray = [[NSMutableArray alloc]init];
              [model.boxchoseValueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  PaperPostOption *option = [[PaperPostOption alloc]init];
                  option.optionValue = obj ;
                  option.optionId = model.boxchoseIdArray[idx];
                  [optonMulArray addObject:[option mj_JSONObject]];
                }];
              if (optonMulArray.count) {
                paperModel.fieldValue = [optonMulArray mj_JSONString];
              }
            
          }
          if ([model.type isEqualToString:@"RADIO"]){
              NSMutableArray *radioMulArray = [[NSMutableArray alloc]init];
              
              PaperPostOption *option = [[PaperPostOption alloc]init];
              option.optionValue = model.radioValueString ;
              option.optionId    = model.radioIdString;
              
              [radioMulArray addObject:[option mj_JSONObject]];
              if (model.radioValueString.length ) {
                   paperModel.fieldValue = [radioMulArray mj_JSONString];
              } else {
                  paperModel.fieldValue = nil;
              }
             
          }if ([model.type isEqualToString:@"DATE"]) {
              paperModel.fieldValue = model.signTime;
              
          }if ([model.type isEqualToString:@"TEXT"]) {
                paperModel.fieldValue = model.textString;
          }
          
         if ([model.type isEqualToString:@"DIGITAL"]) {
                paperModel.fieldValue = model.textString;
            }
        NSLog(@"%@",[paperModel mj_JSONObject]);
              
        [paperArray addObject:[[paperModel mj_JSONObject] retain]];
          }
    }
    
    if (mediaMulArray.count) {
         [pb setPaperPostMediasArray:mediaMulArray];
    }
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:[paperArray mj_JSONObject] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [pb setContent:jsonStr];
  
     PaperPost* p = [pb build];
    
     NSLog(@"%@",p);
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypePaperPostSave param:p]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

#pragma mark didReceiveMessage
-(void)didReceiveMessage:(id)message {
      saveImageView.userInteractionEnabled = YES;
    SessionResponse* cr = [SessionResponse parseFromData:message];
    
        if ([super validateResponse:cr]) {
            return;
        }
    
        switch (INT_ACTIONTYPE( cr.type)) {
        case ActionTypePaperPostSave:{
      
         if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                     HUDHIDE2;
             
                    //提交成功后，表格清空
                    for (int i = 0; i < dataArr.count; i ++) {
                        DataReportModel *model = dataArr[i];
                        model.textString = @"";
                        model.signTime = @"";
                        model.radioValueString = @"";
                        model.boxchoseValueArray = nil;
                        model.imageMulArray = nil;
                        model.custName = @"";
                    }
          
                    [_tableView reloadData];
             
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_PAPER_POST_DES)
                    Description:NSLocalizedString(@"data_report_save", @"")];
                
    }
                break;
            default:
                break;
        }
}

#pragma mark - 正则表达式的数字判断
-(BOOL)validateNumber:(NSString *) textString {
    NSString* number=@"^-?(?=([0-9]{1,10}$|[0-9]{1,10}\\.))(0|[1-9][0-9]*)(\\.[0-9]{1,3})?$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark 返回
-(void)clickLeftButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - uitabviewDelegate
#pragma mark numberOfSectionsInTableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
    
}

#pragma mark numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

#pragma mark heightForRowAtIndexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataReportModel* model  = dataArr[indexPath.section];
    if ([model.type isEqualToString:@"TEXT"]) {
        return 70;
    }
    if ([model.type isEqualToString:@"DIGITAL"]) {
        return 60;
    }
    if ([model.type isEqualToString:@"RADIO"]) {
        return 50;
    }
    if ([model.type isEqualToString:@"CHECKBOX"]) {
        return 50;
    }
    if ([model.type isEqualToString:@"PHOTO_LIVE"]) {
        return 120;
    }
    if ([model.type isEqualToString:@"PHOTO_ANY"]) {
        return 120;
    }
    if ([model.type isEqualToString:@"DATE"]) {
        return 50;
    }
    if ([model.type isEqualToString:@"CUSTOMER"]) {
        return 50;
    }
    return 100;
}

#pragma mark cellForRowAtIndexPath
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataReportModel* model  = dataArr[indexPath.section];
    
    if ([model.type isEqualToString:@"TEXT"] ) {
        textTextViewCell = [[TextViewCell alloc] init];
       textTextViewCell.textView.tag = indexPath.section+1000;
       textTextViewCell.textView.delegate = self;
       textTextViewCell.textView.frame = CGRectMake(15, 0, MAINWIDTH -30 , 50);
        textTextViewCell.textView.textColor = WT_GRAY;
        textTextViewCell.selectionStyle=UITableViewCellSelectionStyleNone;

        if (model.allowNull) {
          textTextViewCell.textView.text = NSLocalizedString(@"editText_hint_optional", nil);;
        }else {
          textTextViewCell.textView.text = NSLocalizedString(@"editText_hint_mandatory", nil);;
        }
        
        if (textTextViewCell != nil && model.textString.length != 0) {
            textTextViewCell.textView.text =  model.textString ;
        }
          [textTextViewCell addSubview:[self setView]];
        return textTextViewCell;
    }
    
    //数字类型
    if ([model.type isEqualToString:@"DIGITAL"]) {
        textDigtViewCell = [[TextViewCell alloc] init];
        textDigtViewCell.textView.delegate = self;
        textDigtViewCell.textView.scrollEnabled = NO;
        textDigtViewCell.textView.tag = indexPath.section + 1000;
        textDigtViewCell.textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textDigtViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
        textDigtViewCell.textView.frame =  CGRectMake(15, 0, MAINWIDTH - 30,50);
        textDigtViewCell.textView.textColor = WT_GRAY;
        
        if (textDigtViewCell != nil && model.textString.length != 0) {
            textDigtViewCell.textView.text = model.textString;
        }else {
            if (model.allowNull) {
                textDigtViewCell.textView.text = NSLocalizedString(@"editText_hint_optional", nil);
            }else {
                textDigtViewCell.textView.text = NSLocalizedString(@"editText_hint_mandatory", nil);;
            }
        }
          [textDigtViewCell addSubview:[self setView]];
        return textDigtViewCell;
    }
    
    //时间选择类型
    if ([model.type isEqualToString:@"DATE"]) {
        
     dateSelectCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        if (dateSelectCell == nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                    dateSelectCell = (TextFieldCell *)oneObject;
                }
            }
            
            dateSelectCell.txtField.editable = NO;
            dateSelectCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dateSelectCell.tag = 1000 + indexPath.section;
            dateSelectCell.txtField.delegate = self;
            UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [tapGesture1 setNumberOfTapsRequired:1];
            dateSelectCell.userInteractionEnabled = YES;
            [dateSelectCell addGestureRecognizer:tapGesture1];
            dateSelectCell.txtField.text = @"长按选择框可以清空";
            dateSelectCell.txtField.font = [UIFont systemFontOfSize:10];
            dateSelectCell.txtField.textColor = WT_GRAY;
            dateSelectCell.title.frame = CGRectMake(20, 0, MAINWIDTH, 30);
            dateSelectCell.title.textColor = WT_GRAY;
            dateSelectCell.title.font = [UIFont systemFontOfSize:12];
            
            UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDate:)];
            longPressGr.minimumPressDuration = 1.0;
            dateSelectCell.userInteractionEnabled = YES;
            [dateSelectCell addGestureRecognizer:longPressGr];

            if (model.allowNull) {
                dateSelectCell.title.text  = NSLocalizedString(@"editText_hint_optional", nil);
            }else {
                dateSelectCell.title.text  = NSLocalizedString(@"editText_hint_mandatory", nil);
            }
            
          [dateSelectCell.txtField setFrame:CGRectMake(15, 25, MAINWIDTH, 30)];
         }
        
         if ( dateSelectCell != nil && model.signTime.length != 0)dateSelectCell.title.text  = model.signTime;
        [dateSelectCell addSubview:[self setDateView]];
        return dateSelectCell;
    }
  

    //单选类型
    if ([model.type isEqualToString:@"RADIO"]) {
        textViewRadioCell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        if (textViewRadioCell == nil) {
            textViewRadioCell = [[TextViewCell alloc] init];
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRadioAction:)];
        [tapGesture setNumberOfTapsRequired:1];
        textViewRadioCell.tag = indexPath.section + 1000;
        textViewRadioCell.userInteractionEnabled = YES;
        textViewRadioCell.textView.scrollEnabled = NO;

        [textViewRadioCell addGestureRecognizer:tapGesture];
        textViewRadioCell.textView.textColor = WT_GRAY;
        if (model.radioValueString.length == 0) {
            if (model.allowNull) {
                textViewRadioCell.textView.text = NSLocalizedString(@"spinner_hint_optional", nil);
            }else {
            textViewRadioCell.textView.text = NSLocalizedString(@"spinner_hint_mandatory", nil);
            }
        }else {
         textViewRadioCell.textView.text =  model.radioValueString ;
        }
       
        textViewRadioCell.textView.editable = NO;
        textViewRadioCell.textView.frame = CGRectMake(15, 0, MAINWIDTH - 70, 50);
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH - 60, -15, 40, 50)];
        [iconImageView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
        [textViewRadioCell addSubview:iconImageView];
        return textViewRadioCell;
    }
    
    //多选类型
    if ([model.type isEqualToString:@"CHECKBOX"]) {
        textViewBoxCell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        if (textViewBoxCell == nil) {
            textViewBoxCell = [[TextViewCell alloc] init];
        }
        
     ;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBoxAction:)];
        [tapGesture setNumberOfTapsRequired:1];
        textViewBoxCell.userInteractionEnabled = YES;
        textViewBoxCell.textView.scrollEnabled = YES;
        [textViewBoxCell addGestureRecognizer:tapGesture];
        textViewBoxCell.tag = indexPath.section + 1000;
        NSString *boxChoseStr = [model.boxchoseValueArray componentsJoinedByString:@"\n"] ;
        
        textViewBoxCell.textView.textColor = WT_GRAY;
        if (boxChoseStr.length == 0) {
            if (model.allowNull) {
                textViewBoxCell.textView.text = NSLocalizedString(@"spinner_hint_optional", nil);
            }else {
                textViewBoxCell.textView.text = NSLocalizedString(@"spinner_hint_mandatory", nil);
            }

        }else {
            textViewBoxCell.textView.text = boxChoseStr;
        }
      
        textViewBoxCell.textView.editable = NO;
        textViewBoxCell.textView.frame = CGRectMake(15, 0, MAINWIDTH - 70, 50);
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH - 60, -15, 40, 50)];
        [iconImageView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
        [textViewBoxCell addSubview:iconImageView];

        return textViewBoxCell;
    }
    
    //实时拍照
    if ([model.type isEqualToString:@"PHOTO_LIVE"]) {
        
        liveImageCell = (LiveImageCell *)[tableView dequeueReusableCellWithIdentifier:@"LiveImageCell"];
        if (liveImageCell == nil) {
            liveImageCell = [[LiveImageCell alloc] init];
            liveImageCell.delegate = self;
            
        }
       
        liveImageCell.tag = indexPath.section + 100;
       [liveImageCell addCallback:^(NSInteger tag) {
            photoIndex = tag;
           
        }];
        
        if (model.imageMulArray.count) {
             [liveImageCell clearCell];
            [model.imageMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [liveImageCell insertPhoto:obj];
            }];
          }
        liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return liveImageCell;
        
        
    }
    
    //拍照 不限来源
    if ([model.type isEqualToString:@"PHOTO_ANY"]) {
       
        liveAnyImageCell = (LiveImageCell *)[tableView dequeueReusableCellWithIdentifier:@"LiveImageCell"];
        if (liveAnyImageCell == nil) {
            liveAnyImageCell = [[LiveImageCell alloc] init];
            liveAnyImageCell.delegate = self;
            liveAnyImageCell.liveBool = NO;
        }
        
        liveAnyImageCell.tag = indexPath.section + 100;
        
        [liveAnyImageCell addCallback:^(NSInteger tag) {
            photoIndex = tag;
            
        }];
        
        if (model.imageMulArray.count) {
            [liveAnyImageCell clearCell];
            [model.imageMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [liveAnyImageCell insertPhoto:obj];
            }];
        }
        
        liveAnyImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return liveAnyImageCell;
        
    }
    
    //客户类型
    if ([model.type isEqualToString:@"CUSTOMER"]) {
        customerSelectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell00"];
        if(customerSelectCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[SelectCell class]])
                    customerSelectCell=(SelectCell *)oneObject;
            }
            customerSelectCell.tag = 1000 + indexPath.section;
            customerSelectCell.title.text = @"";
            customerSelectCell.value.text = @"";
            customerSelectCell.value.center = CGPointMake(100, 20);
            if ( [customerSelectCell.value.text isEqualToString:@""]) {
                customerSelectCell.value.text = @"请选择客户";
                customerSelectCell.value.textColor = WT_GRAY;
                
            }
        }
        UILabel *longTapLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, MAINWIDTH -15, 30)];
                   longTapLabel.text = @"长按选择框可以清空";
        longTapLabel.textColor = WT_GRAY;
        longTapLabel.font = [UIFont systemFontOfSize:10];
        [customerSelectCell addSubview:longTapLabel];
   
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [customerSelectCell addGestureRecognizer:longPressGr];
        if (model.custName.length != 0) {
            customerSelectCell.value.text = model.custName;
            customerSelectCell.value.textColor = WT_BLACK;
        }
        customerSelectCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return customerSelectCell;
    }
}

#pragma mark 长按删除已选择的客户
-(void)longPressToDo:(UILongPressGestureRecognizer*)longPress {
    DataReportModel *model = dataArr[longPress.view.tag - 1000];
    model.custName = nil;
    [_tableView reloadData];}

#pragma mark 长按删除已选择时间
-(void)longPressDate:(UILongPressGestureRecognizer*)tap {
    DataReportModel *model = dataArr[tap.view.tag - 1000];
    model.signTime = nil;
    [_tableView reloadData];

}

#pragma mark didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataReportModel *model = dataArr[indexPath.section];
    indexSection = indexPath.section;
    if ([model.type isEqualToString:@"CUSTOMER"]) {
        CustomerSelectViewController *custVC = [[CustomerSelectViewController alloc] init];
        custVC.delegate = self;
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:custVC];
        [self presentViewController:navCtrl animated:YES completion:nil];
        [navCtrl release];
        [custVC release];
    }
}

#pragma mark heightForHeaderInSection
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio {
    return 30;
}

#pragma mark viewForHeaderInSection
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DataReportModel *model = dataArr[section];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 30)];
    contentView.backgroundColor = WT_WHITE;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, MAINWIDTH, 29)];
    titleLabel.text =[NSString stringWithFormat:@"    %@",model.name];
    titleLabel.font = [UIFont systemFontOfSize:14];
     UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, MAINWIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:titleLabel];
    //[contentView addSubview:lineView];
    return contentView;
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, MAINWIDTH - 100, 20)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 40, 0.4)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    contView.userInteractionEnabled = NO;
    return contView;
}

-(UIView*)setDateView {
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, MAINWIDTH - 100, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 40, 0.4)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    return contView;
}

#pragma mark dismissKeyBoard
-(void)dismissKeyBoard{
    if (textTextViewCell.textView != nil) {
         [textTextViewCell.textView resignFirstResponder];
    }
   
    if (textDigtViewCell.textView != nil) {
        [textDigtViewCell.textView resignFirstResponder];
    }

}

#pragma mark 单选
-(void)tapRadioAction:(UITapGestureRecognizer*)tap {
    DataReportModel* model = dataArr[tap.view.tag-1000];
    RadioViewController *radioVC = [[RadioViewController alloc]init];
    radioVC.radioMulArray = model.options;
    [radioVC getUserTrtByBlock:^(NSDictionary *dic) {
    model.radioValueString = [dic objectForKey:@"content"];
    model.radioIdString = [dic objectForKey:@"id"];
    [_tableView reloadData];
    }];
    [self.navigationController pushViewController:radioVC animated:YES];
}

#pragma mark 多选
-(void)tapBoxAction:(UITapGestureRecognizer*)tap {
    DataReportModel* model = dataArr[tap.view.tag-1000];
    BoxViewController *boxVC = [[BoxViewController alloc]init];
    boxVC.boxMulArray = model.options;model.boxchoseValueArray = [[NSMutableArray alloc]init];
    [boxVC getUserTrtByBlock:^(NSMutableArray *mulArray) {
        NSMutableArray *valueStringArray = [[NSMutableArray alloc]init];
         NSMutableArray *idStringArray = [[NSMutableArray alloc]init];
        [mulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              [valueStringArray addObject:[obj objectForKey:@"content"]];
              [idStringArray addObject:[obj objectForKey:@"id"]];
        }];
        
        if (mulArray.count != 0) {
             model.boxchoseValueArray = valueStringArray;
            model.boxchoseIdArray = idStringArray;
        }
       
        [_tableView reloadData];
        
    }];

    [self.navigationController pushViewController:boxVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

#pragma mark 获取多选选中的数组
-(void)getBoxArray:(NSMutableArray *)mulArray {
    keepBoxArray = mulArray;
    [_tableView reloadData];
}

#pragma mark 相机 相册访问
-(void)camerAction {
    UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                 initWithTitle:@"请选择图片"
                                 delegate:self
                                 cancelButtonTitle:@"取消"                                 destructiveButtonTitle:@"拍照"
                                 otherButtonTitles:@"从相册选择",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

#pragma mark - textView
#pragma mark textViewDidBeginEditing
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"必填"] || [textView.text isEqualToString:@"选填"]) {
        textView.text = nil;
    }
}

#pragma mark textViewDidEndEditing
-(void)textViewDidEndEditing:(UITextView *)textView{
    DataReportModel* model = dataArr[textView.tag-1000];
    if (textView.text.length != 0) {
          model.textString = textView.text;
    }else {
        model.textString = nil;
        if (model.allowNull) {
             textView.text = @"选填";
        }else {
             textView.text = @"必填";
        }
    
    }
}

#pragma mark 时间选择
-(void)tapAction:(UITapGestureRecognizer*)tap {
    timeInt = tap.view.tag - 1000;
    [self datePickerDidCancel];
    datePicker = [[DatePicker2 alloc] init];
    [self.view addSubview:datePicker];
    [datePicker setDelegate:self];
    [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
    CGRect tableFrame = _tableView.frame;
    distance = IS_IPHONE5?0:80;
    tableFrame.origin.y -= distance;
    [_tableView setFrame:tableFrame];
    [datePicker release];
}

#pragma mark datePickerDidCancel
-(void)datePickerDidCancel{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[DatePicker2 class]]){
            [view removeFromSuperview];
        }
    }
    
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y += distance;
    distance = 0;
    [_tableView setFrame:tableFrame];
}

#pragma mark datePickerDidDone
-(void)datePickerDidDone:(DatePicker2*)picker{
    DataReportModel * model = dataArr[timeInt];
    model.signTime = [[NSString stringWithFormat:@"%d-%@-%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue]] retain];
    
    [self datePickerDidCancel];
    [_tableView reloadData];
}

#pragma mark intToDoubleString
-(NSString *)intToDoubleString:(int)d {
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}

#pragma mark 照片的删除
-(void)deletePhoto:(int)index {
    DataReportModel *model = dataArr[photoIndex -100];
    [model.imageMulArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

#pragma mark addPhoto
-(void)addPhoto {
    liveBool = YES;
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

#pragma mark anyPhoto 不限来源 包含相册
-(void)anyPhoto {
    liveBool = NO;
    UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                 initWithTitle:@"请选择图片"
                                 delegate:self
                                 cancelButtonTitle:@"取消"                                 destructiveButtonTitle:@"拍照"
                                 otherButtonTitles:@"从相册选择",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
}

#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
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
            break;
        case 1:{
            [self takeAPhotoWithAlbum];
        }
            break;
        default:
            break;
    }
}

#pragma mark  访问相册
-(void)takeAPhotoWithAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
        [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
        [imgPickerVC setDelegate:self];
        [imgPickerVC setAllowsEditing:NO];
        //显示Image Picker
        [self presentModalViewController:imgPickerVC animated:YES];
        
        
    }else {
        NSLog(@"Album is not available.");
    }
    
    
}

#pragma mark imagePickerController:
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
    //图片的存储
    DataReportModel *model = dataArr[photoIndex -100];
    [model.imageMulArray addObject:imagePath];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    [_tableView reloadData];
    
}

#pragma mark fitSmallImage
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

#pragma mark fitsize
- (CGSize)fitsize:(CGSize)thisSize {
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

#pragma mark imageWithImageSimple
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
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


#pragma -mark - CustomerSelectDelegate
#pragma mark didSelectWithObject
- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject {
    currentCustomer = [(Customer *)aObject retain];
    DataReportModel *model = dataArr[indexSection];
    model.custName = currentCustomer.name;
    model.custId = [NSString stringWithFormat:@"%d",currentCustomer.id];
    
    [_tableView reloadData];
}

#pragma mark customerSearchDidCanceled
- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller{
    
}

#pragma markewCustomerDidFinished
- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject{
    currentCustomer = [[(Customer_Builder *)aObject build] retain];
    [_tableView reloadData];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
