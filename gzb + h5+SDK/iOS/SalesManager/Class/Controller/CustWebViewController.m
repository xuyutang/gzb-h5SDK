
//
//  CustWebViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/9/13.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "CustWebViewController.h"

@interface CustWebViewController ()<UIWebViewDelegate>

@end

@implementation CustWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];

    self.custWebView =[[GZBWebView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    
    _custWebView.backgroundColor = [UIColor clearColor];
    NSLog(@"%dvvvvvvvvvvvvvv",self.custId);
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@/customer/detail.jhtml?customerId=%d",SERVER_URL,CONTEXT_PATH,self.custId];
    NSLog(@"%@kkkkkkk",urlString);
    _custWebView.delegate = self;
   
    [_custWebView loadUrl:urlString];

    [self.view addSubview:self.custWebView];
    [lblFunctionName setText:[NSString stringWithFormat:@"%@",self.custName]];
    // Do any additional setup after loading the view.
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

