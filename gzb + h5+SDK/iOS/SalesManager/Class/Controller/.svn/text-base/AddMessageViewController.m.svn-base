//
//  AddMessageViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/8.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "AddMessageViewController.h"
#import "UIView+CNKit.h"
#import "NIDropDown.h"
#import "DepartmentViewController.h"
#import "PersonViewController.h"
#import "NSString+Helpers.h"


@interface AddMessageViewController ()<UITextViewDelegate,NIDropDownDelegate,DepartmentViewControllerDelegate,RequestAgentDelegate> {
    UIView *rightView;
    NIDropDown *dropDownMenu;
    UILabel *chodeLabel;
    UITextView *titleTextView;
    UITextView *contentTextView;
    NSMutableArray* _departments;
    NSMutableArray* _checkDepartments;
    UITextView *chosedTextView;
    NSMutableArray *departNameMulArray;
    NSString *titleString;
    NSString *contentString;
    NSString *receiveType;
    NSMutableArray *departMentIdMulArray;
    NSMutableArray *personNameMularray;
    NSMutableArray *personIdMuarray;
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIView *footView;
    UIView *footView2;
    
}

@end

@implementation AddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    departNameMulArray = [[NSMutableArray alloc] init];
    lblFunctionName.text = @"云通知-新增";
    self.view.backgroundColor = WT_WHITE;
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 17, 25, 25)];
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

    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"refresh_ui" object:nil];
    // Do any additional setup after loading the view.
}

-(void)refreshUI {
    titleLabel.y = 60;
    chosedTextView.hidden = YES;
    chodeLabel.hidden = YES;
    titleTextView.y = titleLabel.bottom;
    footView.y = titleTextView.bottom;
    contentLabel.y = footView.bottom;
    contentTextView.y = contentLabel.bottom;
    footView2.y = contentTextView.bottom;
    chosedTextView.text = @"";
}
-(void)createUI {

    //选择接收范围
    UILabel *receverLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 90, 30)];
    receverLabel.text = @"接收范围";
    receverLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:receverLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(80, 20, MAINWIDTH - 120, 30);
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_button setTitle:@"请选择" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(choseStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH -40, 10, 25, 40)];
    [imageView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
    [self.view addSubview:imageView];
    chodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _button.bottom + 12, 50, 30)];
    chodeLabel.text = @"接收人";
    chodeLabel.font = [UIFont systemFontOfSize:14];
    chodeLabel.textAlignment = 0;
    
    [self.view addSubview:chodeLabel];
    chodeLabel.hidden =YES;
    
    chosedTextView = [[UITextView alloc] initWithFrame:CGRectMake(76, _button.bottom + 10, MAINWIDTH - 90, 60)];
    chosedTextView.font = [UIFont systemFontOfSize:14];
    chosedTextView.textAlignment = 0;
    chosedTextView.editable = NO;
    [self.view addSubview:chosedTextView];
    //标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 50, 30)];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    
    titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, titleLabel.bottom, MAINWIDTH - 60, 70)];
    titleTextView.font = [UIFont systemFontOfSize:14];
    titleTextView.tag = 9999;
    titleTextView.delegate = self;
   
    [self.view addSubview:titleTextView];
    footView = [self setView];
    footView.y = titleTextView.bottom;
     [self.view addSubview:footView];
    //内容
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleTextView.bottom + 30, 50, 30)];
    contentLabel.text = @"内容";
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:contentLabel];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, contentLabel.bottom, MAINWIDTH - 60, 90)];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
    footView2 = [self setView];
    footView2.y = contentTextView.bottom ;
    [self.view addSubview:footView2];
}

-(void)choseStyle:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"请选择",@"全体人员", @"按部门", @"按人员",nil];
    if(dropDownMenu == nil) {
        CGFloat f = 160;
        dropDownMenu = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDownMenu.delegate = self;
    }
    else {
    [dropDownMenu hideDropDown:sender];
         [self rel];
    }

}

-(void)rel {
    dropDownMenu = nil;
}


#pragma mark textViewDelegate 
-(void)textViewDidBeginEditing:(UITextView *)textView {
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 9999) {
        titleString = [textView.text copy];
    }else {
        contentString = [textView.text copy];
    }
}

#pragma mark dropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSLog(@"%@",_button.titleLabel.text);
    if ([_button.titleLabel.text isEqualToString:@"全体人员"]) {
        //全体人员
        titleLabel.y = 60;
        titleTextView.y = titleLabel.bottom;
        footView.y = titleTextView.bottom;
        contentLabel.y = footView.bottom;
        contentTextView.y = contentLabel.bottom;
        footView2.y = contentTextView.bottom;
        chosedTextView.text = @"";
        chodeLabel.hidden = YES;
        receiveType = @"COMPANY";
    } else if ([_button.titleLabel.text isEqualToString:@"按部门"]) {
        //按部门
        receiveType = @"DEPARTMENT";
         chosedTextView.hidden = NO;
        titleLabel.y = 120;
        titleTextView.y = titleLabel.bottom;
        footView.y = titleTextView.bottom;
        contentLabel.y = footView.bottom;
        contentTextView.y = contentLabel.bottom;
        footView2.y = contentTextView.bottom;
        
        DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
        _departments = [[LOCALMANAGER getDepartments] retain];
        departmentVC.departmentArray = _departments;
        departmentVC.delegate = self;
        departmentVC.departBool = YES;
        departmentVC.view.frame = CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT);
        [self.navigationController pushViewController:departmentVC animated:YES];
    }else if ([_button.titleLabel.text isEqualToString:@"按人员"]){
    //按人员
        chosedTextView.hidden = NO;
        titleLabel.y = 120;
        titleTextView.y = titleLabel.bottom;
        footView.y = titleTextView.bottom;
        contentLabel.y = footView.bottom;
        contentTextView.y = contentLabel.bottom;
        footView2.y = contentTextView.bottom;
        
        personNameMularray = [[NSMutableArray alloc] init];
        personIdMuarray = [[NSMutableArray alloc] init];
        receiveType = @"USER";
        PersonViewController *personVC = [[PersonViewController alloc] init];
        personVC.radioBool = NO;
        [personVC getPersonsWithBlock:^(NSMutableArray *array) {
           [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               [personNameMularray addObject:((User*)obj).realName];
               [personIdMuarray addObject:[NSString stringWithFormat:@"%d",((User*)obj).id]];
               chodeLabel.hidden = NO;
           }];
            
        chosedTextView.text =  [NSString stringWithFormat:@"%@",[personNameMularray componentsJoinedByString:@","]];
     }];
        [self.navigationController pushViewController:personVC animated:YES];
    }else {
        chodeLabel.hidden = YES;
        chosedTextView.hidden = YES;
        titleLabel.y = 60;
        titleTextView.y = titleLabel.bottom;
        footView.y = titleTextView.bottom;
        contentLabel.y = footView.bottom;
        contentTextView.y = contentLabel.bottom;
        footView2.y = contentTextView.bottom;
       receiveType = nil;
    }
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了 %lu 个部门",(unsigned long)departments.count);
    if (!departments.count) {
        [self refreshUI];
    }else {
        chodeLabel.hidden = NO;
    }
   departMentIdMulArray = [[NSMutableArray alloc] init];
    [departNameMulArray removeAllObjects];
   [departments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [departNameMulArray addObject:((Department*)obj).name];
       [departMentIdMulArray addObject:[NSString stringWithFormat:@"%d",((Department*)obj).id]];
   }];
    
   chosedTextView.text = [NSString stringWithFormat:@"%@",[departNameMulArray componentsJoinedByString:@","]];
   
    NSMutableString* sb = [[NSMutableString alloc] init];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
  
}

- (void)toSave:(id)sender  {
    if (!receiveType.length) {
    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:NSLocalizedString(@"input_recieve_not_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (!titleString.length) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:NSLocalizedString(@"input_title_not_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (titleString.length > 200) {
     [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:NSLocalizedString(@"title_input_limit_200", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    
    if (!contentString.length) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:NSLocalizedString(@"input_content_not_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if ([receiveType isEqualToString:@"DEPARTMENT"] &&  !departNameMulArray.count) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:@"部门选择不能为空"
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    
    if ([receiveType isEqualToString:@"USER"] &&  !personIdMuarray.count) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                          description:@"人员不能为空"
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    NSLog(@"通知保存");
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Announce_Builder* ab = [Announce builder];
    [ab setId:-1];
    [ab setSubject:titleString];
    [ab setContent:contentString];
    [ab setCreator:USER];
    [ab setReceiveType:receiveType];
    if ([receiveType isEqualToString:@"DEPARTMENT"]) {
        [ab setResourceIdsArray:departMentIdMulArray];
        
    }else if ([receiveType isEqualToString:@"USER"]) {
      [ab setResourceIdsArray:personIdMuarray];
     
    }
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeAnnouncementSave param:[ab build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }

    [titleTextView endEditing:YES];
    [contentTextView endEditing:YES];
   
}

-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    
    if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeErrorInvalidAction)]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"error_server", @"")
                          description:cr.resultMessage
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        HUDHIDE2;
        HUDHIDE;
        return;
      
    }
    
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeAnnouncementSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [super showMessage2:cr Title:TITLENAME(FUNC_MESSAGE_DES)
                        Description:NSLocalizedString(@"worklog_msg_saved", @"")];
                
                
                Announce *a  = [Announce parseFromData:cr.data];
                [LOCALMANAGER saveAnnounce2: a];
                // [LOCALMANAGER saveAnnounceSender:a.creator];
                 [LOCALMANAGER updateAnnounceSender:a.creator];
                titleLabel.y = 60;
                titleTextView.y = titleLabel.bottom;
                footView.y = titleTextView.bottom;
                contentLabel.y = footView.bottom;
                contentTextView.y = contentLabel.bottom;
                footView2.y = contentTextView.bottom;
                chosedTextView.hidden = YES;
                chodeLabel.hidden = YES;
                [_button setTitle:@"请选择" forState:UIControlStateNormal];
                titleTextView.text = @"";
                contentTextView.text = @"";
                chosedTextView.text = @"";
                receiveType = nil;
                titleString  = nil;
                contentString = nil;
               
            }
           
           
        }
        break;
            
        default:
            break;
    }


}
-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MAINWIDTH - 200, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 50, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 30 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftButton:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];

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
