//
//  InputViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-17.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InputViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "Constant.h"
@interface InputViewController ()<UITextViewDelegate>

@end

@implementation InputViewController
{
    int showCount;
    UIScrollView *scrollView;
}
@synthesize inputTextField,functionName,delegate,tag;
//@synthesize saveImageView;
@synthesize defaultText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setEditText:(NSString *)editText{
    _editText = editText;
}

- (void)viewDidLoad
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    [self.view addSubview:scrollView];
    
    [super viewDidLoad];
    if (!_bExpand) {
        defaultText = NSLocalizedString(@"title_reply_input_default_text", nil);
    }
    if (inputTextField == nil) {
        inputTextField = [[PlaceTextView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 30)];
        inputTextField.placeHolder = defaultText;
        if (_editText.length > 0) {
            inputTextField.text = _editText;
            [inputTextField.lable removeFromSuperview];
        }
        [scrollView addSubview:inputTextField];
    }
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    saveImageView.image = [UIImage imageNamed:@"ab_icon_save"];
//    saveImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
//    saveImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
//    saveImageView.textAlignment = UITextAlignmentCenter;
//    saveImageView.textColor = WT_RED;
    //[saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    
    [rightView release];
    [saveImageView release];
    [tapGesture2 release];
    
    [lblFunctionName setText:functionName];
    if (_atUser != nil && _atUser.length >0) {
        [inputTextField setText:_atUser];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboard:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [inputTextField becomeFirstResponder];
}

-(void) willKeyboardShow:(NSNotification *) notification{
    showCount++;
    if (showCount <= 1) {
        
        showCount++;
    }
    //self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    NSDictionary *dic = notification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = value.CGRectValue;
    CGRect inputRect = inputTextField.frame;
    inputRect.size.height = self.view.frame.size.height  - rect.size.height;
    inputRect.origin.y = 1;
    [UIView animateWithDuration:.1f animations:^{
        inputTextField.frame = inputRect;
    }];
}


-(void) hideKeyboard:(NSNotification *) notification{
    NSDictionary *dic = notification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = value.CGRectValue;
    CGRect inputRect = inputTextField.frame;
    inputRect.size.height = MAINHEIGHT ;
    inputRect.origin.y = 0;
    [UIView animateWithDuration:.1f animations:^{
        inputTextField.frame = inputRect;
    }];
    showCount = 0;
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) save{
    if ([NSString stringContainsEmoji:inputTextField.text]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:NSLocalizedString(@"input_content_hint_emoji", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if ([inputTextField.text isEqualToString:@""]) {
        [MESSAGE showMessageWithTitle:functionName
                          description:NSLocalizedString(@"input_content_not_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (_bExpand && self.saveButttonClicked) {
        if (inputTextField.text.length > _validateLength) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                              description:[NSString stringWithFormat:NSLocalizedString(@"validate_text_length_hint", nil),_validateLength]
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return;
        }
        self.saveButttonClicked(inputTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishInput:Input:)]) {
        [delegate didFinishInput:tag Input:inputTextField.text];
        
       // [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma -mark UITextViewDelegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [inputTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setInputTextField:nil];
    [super viewDidUnload];
}
@end
