//
//  AppliedDetailViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/10/8.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "AppliedDetailViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "UIView+CNKit.h"
#import "NIDropDown.h"
#import "PersonViewController.h"

@interface AppliedDetailViewController ()<NIDropDownDelegate,UIWebViewDelegate,RequestAgentDelegate,UITextViewDelegate>

@end

@implementation AppliedDetailViewController {
    UIView * rightView ;
    NIDropDown *dropDownMenu;
    UILabel *label;
    UIButton *personBtn;
    UILabel *Approverlabel;
    UILabel *suggestLab;
    UITextView *suggestTextView ;
    UIImageView *imagArrowView;
    UIImageView *imagView;
    UIImageView *saveImageView;
    CGFloat WEBY;
    CGFloat WEBhight ;
    NSInteger auditResultType;
    NSString *auditReasonString;
    NSMutableArray *userArray;
    UIView *bottomView;
    BOOL firstLoadBool;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getApproval:) name:@"approve_notifi" object:nil];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    saveImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 25, 25)] retain];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tosave:)];
    [tapGesture setNumberOfTapsRequired:1];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    saveImageView.hidden = YES;
    
    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    [refreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFresh:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    refreshImageView.userInteractionEnabled = YES;
    refreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [refreshImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:refreshImageView];
    [refreshImageView release];

    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = btRight;
        [btRight release];
    self.view.backgroundColor = [UIColor whiteColor];
    [lblFunctionName setText:[NSString stringWithFormat:@"%@-详情",TITLENAME(FUNC_HOLIDAY_DES)]];
    [leftImageView setImage:[UIImage imageNamed:@"ab_icon_back"]];
   
    NSString *urlString =  [NSString stringWithFormat:@"/holidayApply/flowDetailV2.jhtml?applyId=%@",self.applyIdString];
    [self loadURL:urlString];
    auditResultType = USER_WAIT;
}

//自定义审批收到的通知
-(void)getApproval:(NSNotification*)noti {
    //通过id判断是否是我审批
    if ([[noti.userInfo objectForKey:@"waitApprover"] isEqualToString:[NSString stringWithFormat:@"%d",USER.id]]) {
        self.isMyApproveBool = YES;
        saveImageView.hidden = NO;
       //auditResultType = USER_WAIT;
    }else {
        self.isMyApproveBool = NO;
    }
    //是我审批时的处理
    if (_isMyApproveBool) {
        //UI
        [self createUI];
        if (!firstLoadBool) {
            WEBY = 45;
            WEBhight = MAINHEIGHT- 45;
            self.webView.y = WEBY;
            self.webView.height = WEBhight;
        }
    }
}

-(void)createUI {
    //self.webView.y = 45;
   // self.webView.height = MAINHEIGHT - 45;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 45)];
        label.text = @"审批结果";
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
    }
    
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(label.width + label.x + 10, 0 , MAINWIDTH - label.width - label.x - 40, 45);
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitle:@"请选择" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(choseApprovalWay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    
    if (!imagView) {
        imagView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH - 30, 2.5, 25, 25)];
        [imagView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
        [self.view addSubview:imagView];
    }
}

#pragma mark 选择审批方法
-(void)choseApprovalWay:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"请选择", @"同意并流转", @"同意并结束",@"不同意",nil];
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

#pragma mark dropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSLog(@"%@",_button.titleLabel.text);
    firstLoadBool = YES;
    if ([_button.titleLabel.text isEqualToString:@"同意并流转"]) {
        auditResultType = USER_PASS_AND_MOVEMENT;
        WEBY = 190;
        WEBhight = MAINHEIGHT - 190;
        self.webView.y = 190;
        self.webView.height = MAINHEIGHT - 190;
        if (!Approverlabel || Approverlabel.hidden == YES) {
            Approverlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 30)];
            Approverlabel.text = @"审批人员";
            Approverlabel.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:Approverlabel];
        }
       
        
        if (!personBtn ||  personBtn.hidden == YES) {
            personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            personBtn.frame = CGRectMake(Approverlabel.width + Approverlabel.x + 10, 40, MAINWIDTH - Approverlabel.width-Approverlabel.x - 40, 30);
            [personBtn setTitle:@"请选择人员" forState:UIControlStateNormal];
            personBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [personBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [personBtn addTarget:self action:@selector(chosePerson) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:personBtn];
        }
     
        if (!imagArrowView || imagArrowView.hidden == YES ) {
            imagArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH- 25, 46, 14, 14)];
            [imagArrowView setImage:[UIImage imageNamed:@"ic_go.png"]];
            [self.view addSubview:imagArrowView];

        }
        
        if (!suggestLab) {
            suggestLab = [[UILabel alloc] initWithFrame:CGRectMake(10, Approverlabel.bottom + 10, 100, 30)];
            suggestLab.text = @"审批意见";
            suggestLab.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:suggestLab];
        }
       
        if (!suggestTextView) {
            suggestTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, suggestLab.bottom + 5, MAINWIDTH - 20, 60)];
            suggestTextView.delegate = self;
            

            [self.view addSubview:suggestTextView];
            
            bottomView = [self setViewY:suggestTextView.bottom -10];
            [self.view addSubview:bottomView];
          
        }
        suggestTextView.hidden = NO;
        suggestLab.hidden = NO;
        suggestLab.y = personBtn.bottom + 15;
        suggestTextView.y = suggestLab.bottom + 15;
      
    } else if ([_button.titleLabel.text isEqualToString:@"同意并结束"]) {
        auditResultType = USER_PASS;
        WEBY = 190;
        WEBhight = MAINHEIGHT - 190;
        if (!suggestLab) {
            self.webView.y = 190;
            self.webView.height = MAINHEIGHT - 190;
            suggestLab = [[UILabel alloc] initWithFrame:CGRectMake(10,  80, 100, 30)];
            suggestLab.text = @"审批意见";
            suggestLab.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:suggestLab];

        }
        
        if (!suggestTextView) {
            suggestTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, suggestLab.bottom + 5, MAINWIDTH - 20, 60)];
             suggestTextView.delegate = self;

            [self.view addSubview:suggestTextView];
            bottomView = [self setViewY:suggestTextView.bottom -10];
            [self.view addSubview:bottomView];
        }
        if (suggestLab.hidden) {
            suggestLab.hidden = NO;
            suggestTextView.hidden = NO;
            self.webView.y = 190;
            self.webView.height = MAINHEIGHT - 190;
        }
        suggestLab.y = _button.bottom + 15;
        suggestTextView.y = suggestLab.bottom + 15;
        Approverlabel.hidden = YES;
        personBtn.hidden = YES;
        imagArrowView.hidden = YES;
         bottomView.hidden = NO;
        
    }else if([_button.titleLabel.text isEqualToString:@"不同意"]){
        auditResultType = USER_NOT_PASS;
        WEBY = 190;
        WEBhight = MAINHEIGHT - 190;
        if (!suggestLab || suggestLab.hidden == YES) {
            self.webView.y = 190;
            self.webView.height = MAINHEIGHT - 190;
            suggestLab = [[UILabel alloc] initWithFrame:CGRectMake(10,  80, 100, 30)];
            suggestLab.text = @"审批意见";
            suggestLab.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:suggestLab];
            
        }
        
        if (!suggestTextView || suggestTextView.hidden == YES) {
            suggestTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, suggestLab.bottom + 5, MAINWIDTH - 20, 60)];
            suggestTextView.delegate = self;
            [self.view addSubview:suggestTextView];
            
            bottomView = [self setViewY:suggestTextView.bottom -10];
            [self.view addSubview:bottomView];
        }
        suggestLab.y = _button.bottom + 15;
        suggestTextView.y = suggestLab.bottom + 15;
        Approverlabel.hidden = YES;
        personBtn.hidden = YES;
        imagArrowView.hidden = YES;
         bottomView.hidden = NO;
        
    }else {
        auditResultType = USER_WAIT;
        Approverlabel.hidden = YES;
        personBtn.hidden = YES;
        imagArrowView.hidden = YES;
        suggestTextView.hidden = YES;
        suggestLab.hidden = YES;
        bottomView.hidden = YES;
        WEBY = 45;
        WEBhight = MAINHEIGHT - 45;
        self.webView.y = 45;
        self.webView.height = MAINHEIGHT - 45;
        
    }
}

-(UIView*)setViewY:(CGFloat)Y {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, MAINWIDTH - 200, 40)];
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


-(void)tosave:(id)sender {
    if (auditResultType == USER_WAIT) {
    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
                          description:NSLocalizedString(@"chose_result", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
  
    if (auditResultType == USER_PASS_AND_MOVEMENT && !userArray.count ) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
                          description:NSLocalizedString(@"chose_approval_people", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (auditResultType == USER_NOT_PASS &&!suggestTextView.text.length) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
                          description:NSLocalizedString(@"no_approval_suggest", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    HolidayAudit_Builder *ho = [HolidayAudit builder];
    
    
    HolidayApply_Builder *h = [HolidayApply builder];
    
    HolidayCategory_Builder *hb = [HolidayCategory builder];
    [hb setId:-1];
    [hb setName:@""];
    
    [h setId:[self.applyIdString intValue]];
    [h setUser:USER];
    [h setDeviceId:[UIDevice deviceId]];
    [h setHolidayCateory:[hb build]];
    [h setStartTime:@""];
    [h setEndTime:@""];
    [h setReason:@""];
    if (auditResultType == USER_PASS_AND_MOVEMENT ) {
        [h setUsersArray:userArray];
    }
    
    [ho setHolidayApply:[h build]];
    [ho setReason:auditReasonString.trim];
    [ho setType:[NSString stringWithFormat:@"%ld",(long)auditResultType]];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeHolidayApplyApprove param:[ho build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)chosePerson {
    PersonViewController *personVC = [[PersonViewController alloc] init];
    personVC.radioBool = YES;
    personVC.messageTitle =TITLENAME(FUNC_HOLIDAY_DES);
    [personVC getPersonsWithBlock:^(NSMutableArray *array) {
        userArray = array ;
        [personBtn setTitle:((User*)array[0]).realName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:personVC animated:YES];

}

-(void)rel {
    dropDownMenu = nil;
}

#pragma mark 返回
-(void)clickLeftButton:(id)sender {
    if (self.hasNavBool) {
         [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
   
}

#pragma mark 刷新操作
-(void)toFresh:(id)sender {
//    WEBY = self.webView.y;
//    WEBhight= self.webView.height;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = NSLocalizedString(@"loading", @"");
    
    [self.webView reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
   if (_isMyApproveBool) {
       [self createUI];
       saveImageView.hidden = NO;
       label.hidden = NO;
       _button.hidden = NO;
       imagView.hidden = NO;
       
       self.webView.y = WEBY;
       self.webView.height = WEBhight;
   }else {
       self.webView.y = 0;
       self.webView.height = MAINHEIGHT;
   }
    HUDHIDE2;
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHolidayList" object:nil];
    [self.hud hide:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {

}

-(void)textViewDidEndEditing:(UITextView *)textView {
    auditReasonString = [textView.text copy] ;

}

-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeHolidayApplyApprove:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                //刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHolidayList" object:nil];
                
                HolidayApply *h = [HolidayApply parseFromData:cr.data];
                if (h.users.count && ((User*)[h.users objectAtIndex:0]).id == USER.id)  {
                    _isMyApproveBool = YES;
                    WEBY = 45;
                    WEBhight = MAINHEIGHT - 45;
                }else {
                    _isMyApproveBool = NO;
                    WEBY = 0;
                    WEBhight = MAINHEIGHT;
                }
                [self toFresh:nil];
                [_button setTitle:@"请选择" forState:UIControlStateNormal];
                auditResultType = USER_WAIT;
                suggestTextView.text = @"";
                label.hidden = YES;
                _button .hidden = YES;
                imagArrowView .hidden = YES;
                imagView .hidden = YES;
                personBtn.hidden = YES;
                Approverlabel .hidden = YES;
                suggestLab.hidden = YES;
                suggestTextView  .hidden = YES;
                imagArrowView .hidden = YES;
                saveImageView .hidden = YES;
                bottomView.hidden = YES;

            }
            
            [super showMessage2:cr Title:TITLENAME(FUNC_HOLIDAY_DES)
                    Description:NSLocalizedString(@"worklog_msg_saved", @"")];
        }
            break;
            
        default:
            break;
    }
    


}


#pragma mark didReceiveMemoryWarning
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
