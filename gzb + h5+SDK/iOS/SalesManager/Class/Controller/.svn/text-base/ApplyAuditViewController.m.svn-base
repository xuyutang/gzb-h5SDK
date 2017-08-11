//
//  ApplyAuditViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/16.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "ApplyAuditViewController.h"
#import "NIDropDown.h"
#import "PersonViewController.h"
#import "UIView+CNKit.h"
#import "Constant.h"
#import "NSDate+Util.h"


@interface ApplyAuditViewController ()<NIDropDownDelegate,UITextViewDelegate,RequestAgentDelegate> {
    UIView *rightView;
    NIDropDown *dropDownMenu;
    NSInteger auditResultType;
    UILabel *personLabel;
    UIButton *chosePersonBtn;
    UIImageView *arrowImaView;
    UILabel *suggestLabel;
    UITextView *suggestTextView;
    NSMutableArray *userArray;
    NSString *suggestString;
    UIView *bottomView;
    NSString *justStr;
}

@end

@implementation ApplyAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lblFunctionName.text = @"审批";
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
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 30)];
    label.text = @"审批结果";
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(80, 10, MAINWIDTH - 140, 30);
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    _button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_button setTitle:@"请选择" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(choseStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH -40, 10, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
    [self.view addSubview:imageView];
    
    personLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _button.bottom + 15, 60, 30)];
    personLabel.text = @"审批人员";
    personLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:personLabel];
    
    chosePersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chosePersonBtn.frame = CGRectMake(personLabel.x + personLabel.width + 10, _button.bottom + 15, MAINWIDTH - personLabel.x - personLabel.width - 50, 30);
    [chosePersonBtn setTitle:@"请选择人员" forState:UIControlStateNormal];
    [chosePersonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chosePersonBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [chosePersonBtn addTarget:self action:@selector(chosePerson) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chosePersonBtn];
    
    arrowImaView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH - 40, _button.bottom + 21, 14, 14)];
    arrowImaView.image = [UIImage imageNamed:@"ic_go.png"];
    [self.view addSubview:arrowImaView];
    
    suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, personLabel.bottom + 15, 60, 30)];
    suggestLabel.text = @"审批意见";
    suggestLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:suggestLabel];
    
    suggestTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, suggestLabel.bottom + 15, MAINWIDTH - 30 , 70)];
    suggestTextView.delegate = self;

    [self.view addSubview:suggestTextView];
    
    bottomView = [self setViewY:suggestTextView.bottom];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    
    
    personLabel.hidden = YES;
    chosePersonBtn.hidden = YES;
    suggestLabel.hidden = YES;
    suggestTextView.hidden = YES;
    arrowImaView.hidden = YES;
    
}

-(UIView*)setViewY:(CGFloat)Y {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, MAINWIDTH - 200, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 50, 0.3)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 30 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
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
#pragma mark toSave
-(void)toSave:(id)sender {
    //审批保存
    [suggestTextView endEditing:YES];
    if (!auditResultType && !justStr.length) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                          description:NSLocalizedString(@"chose_result", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (auditResultType == APPROVE_STATUS_NOT_PASS && !suggestTextView.text.trim.length) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                          description:NSLocalizedString(@"no_approval_suggest", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (auditResultType == APPROVE_STATUS_PASS_AND_MOVEMENT && !userArray.count) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                          description:NSLocalizedString(@"chose_approval_people", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    ApplyAudit_Builder *ab = [[ApplyAudit_Builder alloc] init];
    [ab setApplyItemId:self.applyTtemId];
    [ab setStatus:[NSString stringWithFormat:@"%d",auditResultType]];
    [ab setAuditUser:USER];
    [ab setCreateDate:[NSDate getCurrentTime]];
    if (auditResultType == APPROVE_STATUS_PASS_AND_MOVEMENT ) {
        [ab setUsersArray:userArray];
    }
    
    [ab setComment:suggestString.trim];
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemApprove param:[ab build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSLog(@"%@",_button.titleLabel.text);
    if ([_button.titleLabel.text isEqualToString:@"同意并流转"]) {
        auditResultType = APPROVE_STATUS_PASS_AND_MOVEMENT;
        justStr =@"";
        personLabel.hidden = NO;
        chosePersonBtn.hidden = NO;
        suggestLabel.hidden = NO;
        suggestTextView.hidden = NO;
        bottomView.hidden = NO;
        arrowImaView.hidden = NO;
        suggestLabel.y = personLabel.bottom  + 15;
        suggestTextView.y= suggestLabel.bottom + 15;
        bottomView.y = suggestTextView.bottom;
    }else if ([_button.titleLabel.text isEqualToString:@"同意并结束"]) {
       auditResultType = APPROVE_STATUS_PASS;
         justStr =@"";
        personLabel.hidden = YES;
        chosePersonBtn.hidden = YES;
        arrowImaView.hidden = YES;
        suggestLabel.hidden = NO;
        suggestTextView.hidden = NO;
          bottomView.hidden = NO;
        suggestLabel.y = _button.bottom  + 15;
        suggestTextView.y= suggestLabel.bottom + 15;
          bottomView.y = suggestTextView.bottom;
    }else if ([_button.titleLabel.text isEqualToString:@"不同意"]){
        auditResultType = APPROVE_STATUS_NOT_PASS;
         justStr =@"no";
        personLabel.hidden = YES;
        chosePersonBtn.hidden = YES;
        arrowImaView.hidden  =YES;
        suggestLabel.hidden = NO;
        suggestTextView.hidden = NO;
          bottomView.hidden = NO;
        suggestLabel.y = _button.bottom  + 15;
        suggestTextView.y= suggestLabel.bottom + 15;
          bottomView.y = suggestTextView.bottom;
    }else{
        justStr =@"";
        personLabel.hidden = YES;
        chosePersonBtn.hidden = YES;
        arrowImaView.hidden = YES;
        suggestLabel.hidden = YES;
        suggestTextView.hidden = YES;
          bottomView.hidden = YES;
    }
}

-(void)choseStyle:(id)sender {
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

-(void)chosePerson {
    PersonViewController *personVC = [[PersonViewController alloc] init];
    personVC.radioBool = YES;
    personVC.messageTitle = TITLENAME(FUNC_APPROVE_DES);
    [personVC getPersonsWithBlock:^(NSMutableArray *array) {
        userArray = array ;
        [chosePersonBtn setTitle:((User*)array[0]).realName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:personVC animated:YES];
    

}

-(void)rel {
    dropDownMenu = nil;
}

#pragma mark textDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView {

}

-(void)textViewDidEndEditing:(UITextView *)textView {
    suggestString = [textView.text copy];

}

#pragma mark didReceiveMessage
-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeApplyItemApprove:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshApplyDetail"object:nil];
              }
            
            [super showMessage2:cr Title:TITLENAME(FUNC_APPROVE_DES)
                    Description:NSLocalizedString(@"worklog_msg_saved", @"")];
        }
        break;
        
        default:
        break;
    }
}

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
