//
//  PushViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/8/23.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [lblFunctionName setText:@"触发的原生页面"];

    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.com"]];
    [myWebView loadRequest:request];
    
    [self.view addSubview:myWebView];
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
