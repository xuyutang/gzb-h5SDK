//
//  AboutViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "UIDevice+Util.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    //[leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
    [leftView addSubview:leftImageView];
    
    [lblFunctionName setText:NSLocalizedString(@"pref_about", @"")];
    
    [_lblVersion setText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"msg_version_info", @""),[UIDevice appVersion]]];
    [_lblVersion setTextColor:WT_RED];
    [_lblDeviceId setText:[NSString stringWithFormat:@"%@\n%@",[UIDevice deviceId],[LOCALMANAGER getDeviceToken]]];
    
    [_btnLink addTarget:self action:@selector(toServiceUrl) forControlEvents:UIControlEventTouchUpInside];
    [_btnPhone addTarget:self action:@selector(toServiceTel) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)toServiceUrl{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICE_URL]];
}

-(void)toServiceTel{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICE_TEL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblVersion release];
    [_lblDeviceId release];
    [_btnLink release];
    [_btnPhone release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblVersion:nil];
    [self setLblDeviceId:nil];
    [self setBtnLink:nil];
    [self setBtnPhone:nil];
    [super viewDidUnload];
}
@end
