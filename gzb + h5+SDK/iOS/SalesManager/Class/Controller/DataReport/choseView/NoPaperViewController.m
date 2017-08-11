//
//  NoPaperViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/9/18.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NoPaperViewController.h"
#import "Constant.h"
#import "DataReportListViewController.h"
#import "PaperViewController.h"

@interface NoPaperViewController () {

    UIView *rightView;
    UIImageView *saveImageView;
    UILabel *locationLabel;

}

@end

@implementation NoPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];

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
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_PAPER_POST_DES)];

    UILabel *nopaperLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, MAINWIDTH, 40)];
    nopaperLabel.text = @"请选择模板";
    nopaperLabel.textAlignment = 1;
    nopaperLabel.textColor = WT_GRAY;
    [self.view addSubview:nopaperLabel];
    // Do any additional setup after loading the view.
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

#pragma mark 去往数据上报的列表页
-(void)toList:(id)sender {
    DataReportListViewController *dataReportVC = [[DataReportListViewController alloc]init];
    [self.navigationController pushViewController:dataReportVC animated:YES];
    
}


#pragma mark 去往模板选择页面
-(void)toPaper:(id)sender {
   PaperViewController* paperController = [[PaperViewController alloc]init];
    [self.navigationController pushViewController:paperController animated:YES];
    
}

-(void)toSave:(id)sender {

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
