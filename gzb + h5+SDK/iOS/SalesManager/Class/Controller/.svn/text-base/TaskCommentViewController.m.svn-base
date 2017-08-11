//
//  TaskCommentViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TaskCommentViewController.h"
#import "IMGCommentView.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "NSDate+Util.h"

@interface TaskCommentViewController (){
    IMGCommentView *popCommentView;
    TaskPatrolReply* taskPatrolReply;
}

@end

@implementation TaskCommentViewController
@synthesize taskId,taskPatrol,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =WT_WHITE;
    popCommentView = [[IMGCommentView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    popCommentView.parentCtrl = _parentController;
    popCommentView.target = self;
    [self.view addSubview:popCommentView];
    [lblFunctionName setText:NSLocalizedString(@"worklog_label_reply", @"")];
}

-(void)submitComment{
    if (popCommentView.textViewCell.textView.text == nil || popCommentView.textViewCell.textView.text.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"回复内容必填且最多只能输入1000字", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    TaskPatrolReply_Builder* tpb = [TaskPatrolReply builder];
    [tpb setSender:USER];
    [tpb setContent:popCommentView.textViewCell.textView.text];
    [tpb setCreateDate:[NSDate getCurrentTime]];
    
    [tpb setTaskId:taskId];
    [tpb setId:-1];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in popCommentView.imageFiles) {
        UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
        NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
        [images addObject:dataImg];
    }
    if (images.count > 0) {
        [tpb setFilesArray:images];
    }
    
    AGENT.delegate = self;
    TaskPatrolReply* wr = [tpb build];
    taskPatrolReply = [wr retain] ;
    if (DONE != [AGENT sendRequestWithType:ActionTypeTaskPatrolReply param:[wr retain]]) {
        [hud hide:YES];
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }


}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeTaskPatrolReply:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                
                [popCommentView.imageFiles removeAllObjects];
                [popCommentView.liveImageCell clearCell];
                [popCommentView.liveImageCell release];
                popCommentView.liveImageCell = nil;
                popCommentView.textViewCell.textView.text = @"";
                popCommentView.textViewCell.textView.placeHolder = @"必填（1000字以内）";
                [popCommentView.tableView reloadData];
                //[popCommentView removeFromSuperview];
                [popCommentView release];
                popCommentView = nil;
                
                
                if (delegate != nil && [delegate respondsToSelector:@selector(finishedComment:)]) {
                    [delegate finishedComment:taskPatrolReply];
                }

            }
            [super showMessage2:cr Title:TITLENAME(FUNC_PATROL_TASK_DES)Description:NSLocalizedString(@"patrol_task_reply_finished", @"")];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
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
