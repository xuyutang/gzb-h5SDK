//
//  FillCardViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/12/19.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "FillCardViewController.h"
#import "PlaceTextView.h"
#import "Constant.h"

@interface FillCardViewController ()<UITextViewDelegate,RequestAgentDelegate>{
    UIView *rightView;
    NSString *remarkStr;
    PlaceTextView *plaTextView;
    AppDelegate* appDelegate;

}

@end

@implementation FillCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = APPDELEGATE;
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    saveImageView.userInteractionEnabled = YES;
    [saveImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:saveImageView];
    
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [lblFunctionName setText:@"提交补卡信息"];
    self.view.backgroundColor = WT_WHITE;
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI {
    plaTextView = [[PlaceTextView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 300)];
    plaTextView.placeHolder = @"请输入补卡相关信息";

    plaTextView.delegate = self;
    [self.view addSubview:plaTextView];
}

-(void)toSave:(id)sender {
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    [hud hide:YES afterDelay:1];
    
    CheckInTrack_Builder *cb = [CheckInTrack builder];
    [cb setUser:USER];
    [cb setId:-1];
    if (appDelegate.myLocation != nil){
        [cb setLocation:appDelegate.myLocation];
    }
    [cb setCheckInShiftGroup:self.model.group];
    [cb setCheckInDate:self.model.group.shift.date];
    [cb setCheckInRemark:remarkStr];
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCheckinTrackRemark param:[cb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    plaTextView.placeHolder = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    remarkStr = [textView.text copy];
    if (textView.text.length) {
         plaTextView.text = textView.text;
    }else {
        plaTextView.placeHolder = @"请输入补卡相关信息";
 
  }
}

-(void)refreshCheckWithBlock:(refreshCheck) block{
    self.checkBlock = block ;
    
}

-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    
    if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        plaTextView.text = @"";
        plaTextView.placeHolder = @"请输入补卡相关信息";
        if (self.checkBlock != nil) {
            self.checkBlock(remarkStr);
        }
        
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:@"补卡成功"
                                 type:MessageBarMessageTypeSuccess
                          forDuration:SUCCESS_MSG_DURATION];
        [self.navigationController popViewControllerAnimated:YES];
    }
     [super showMessage2:cr Title:@"打卡考勤" Description:@""];
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
